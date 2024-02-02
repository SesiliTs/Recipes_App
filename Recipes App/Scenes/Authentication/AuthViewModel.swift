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
    @Published var alertMessage = ""
    
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
            
            let user = User(id: result.user.uid, fullname: fullname, email: email, photoURL: "", recipes: [])
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
        
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
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
}
