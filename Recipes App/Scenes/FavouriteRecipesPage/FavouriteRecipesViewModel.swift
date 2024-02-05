//
//  FavouriteRecipesViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 04.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FavouriteRecipesViewModel {
    
    //MARK: - Properties
    
    private var likedRecipesListener: ListenerRegistration?
    private let recipes = FireStoreManager.shared.allRecipes
    
    //MARK: - Fetch Liked Recipes
    
    func fetchLikedRecipes(completion: @escaping ([RecipeData]?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let ref = Firestore.firestore().collection("users").document(userId)
        ref.getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error)")
                completion(nil)
            } else {
                if let likedRecipesIds = document?.data()?["likedRecipes"] as? [String] {
                    let likedRecipes = self.recipes.filter { likedRecipesIds.contains($0.id) }
                    completion(likedRecipes)
                } else {
                    completion([])
                }
            }
        }
    }
    
    //MARK: - Firebase Change Listener
    
    func startListeningLikedRecipesChanges(completion: @escaping ([RecipeData]?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let ref = Firestore.firestore().collection("users").document(userId)
        likedRecipesListener = ref.addSnapshotListener { (document, error) in
            if let error = error {
                print("Error listening for liked recipes changes: \(error)")
                completion(nil)
            } else {
                if let likedRecipesIds = document?.data()?["likedRecipes"] as? [String] {
                    let likedRecipes = self.recipes.filter { likedRecipesIds.contains($0.id) }
                    completion(likedRecipes)
                } else {
                    completion([])
                }
            }
        }
    }

    func stopListeningLikedRecipesChanges() {
        likedRecipesListener?.remove()
    }
    
}
