//
//  AuthViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import Foundation
import Firebase
import FirebaseFirestore

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
    
    //MARK: - init
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
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
    
    func signUp(email: String, password: String, repeatPassword: String, fullname: String, photoURL: String) async throws {
        guard password == repeatPassword else {
            showAlert = true
            alertMessage = "პაროლები არ ემთხვევა"
            return
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, photoURL: photoURL)
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
}
