//
//  AuthViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol AuthenticationValidationProtocol {
    var isValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    @Published var showAlert = false
    @Published var showSuccessAlert = false
    @Published var alertMessage = ""
    
    var credential: AuthCredential?
    
    let storage: Storage
    
    //MARK: - init
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.storage = Storage.storage()
        checkLoggedUser()
        
        Task {
            await fetchUser()
        }
    }
    
    private func checkLoggedUser() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.userSession = user
        }
    }
    
    //MARK: - Auth Methods
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            showAlert = true
            alertMessage = "მეილი ან პაროლი არასწორია"
        }
    }
    
    func signUp(email: String, password: String, repeatPassword: String, fullname: String, image: UIImage?) async throws {
        guard password == repeatPassword else {
            showAlert = true
            alertMessage = "პაროლები არ ემთხვევა"
            return
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            if let image = image {
                persistImageToStorage(image: image)
            }
            
            let user = User(id: result.user.uid, fullname: fullname, email: email, photoURL: "", recipes: [], likedRecipes: [], highContrast: false, boldText: false, fontSize: 12)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("failed to create user. error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("sign out failed. error: \(error)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    private func persistImageToStorage(image: UIImage?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: "\(uid)/profile/profile_image")
        
        guard let imageData = image?.jpegData(compressionQuality: 0.1) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Failed to push image to Storage: \(error)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve downloadURL: \(error)")
                    return
                }
                
                if let downloadURL = url {
                    Firestore.firestore().collection("users").document(uid).updateData(["photoURL" : downloadURL.absoluteString])
                    
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func changeImage(image: UIImage?) {
        persistImageToStorage(image: image)
        Task {
            await fetchUser()
        }
    }
    
    // MARK: - Change Fullname
    
    func changeFullname(newFullname: String) async throws {
        guard let currentUser = currentUser else {
            print("Current user is nil.")
            return
        }
        
        do {
            let updatedUser = User(id: currentUser.id, fullname: newFullname, email: currentUser.email, photoURL: currentUser.photoURL, recipes: currentUser.recipes, likedRecipes: currentUser.likedRecipes, highContrast: currentUser.highContrast, boldText: currentUser.boldText, fontSize: currentUser.fontSize)
            
            let encodedUser = try Firestore.Encoder().encode(updatedUser)
            try await Firestore.firestore().collection("users").document(currentUser.id).setData(encodedUser, merge: true)
            self.currentUser?.fullname = newFullname
            self.objectWillChange.send()
        } catch {
            print("Failed to change fullname. Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Change Email
    
    func changeEmail(newEmail: String, currentPassword: String) async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            let credentials = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
            try await user.reauthenticate(with: credentials)
            try await user.sendEmailVerification(beforeUpdatingEmail: newEmail)
            try await updateFirestoreEmail(newEmail)
            await fetchUser()
        } catch {
            print("Failed to change email. Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateFirestoreEmail(_ newEmail: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userReference = Firestore.firestore().collection("users").document(userId)
        try await userReference.updateData(["email": newEmail])
    }
    
    // MARK: - Change Password
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        let credentials = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        
        do {
            try await user.reauthenticate(with: credentials)
            try await user.updatePassword(to: newPassword)
            self.showSuccessAlert = true
        } catch {
            print("Failed to reauthenticate or change password. Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    //MARK: - Delete User Account
    
    func deleteUser(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        do {
            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
            try await user.reauthenticate(with: credential)
            
            try await deleteUserFromFirestore()
            try await user.delete()
            userSession = nil
            currentUser = nil

        } catch {
            print("Failed to reauthenticate or delete user account. Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func deleteUserFromFirestore() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw URLError(.badURL)
        }
        do {
            try await Firestore.firestore().collection("users").document(uid).delete()
        } catch {
            print("Failed to delete user data from Firestore. Error: \(error.localizedDescription)")
            throw error
        }
    }
    
}
