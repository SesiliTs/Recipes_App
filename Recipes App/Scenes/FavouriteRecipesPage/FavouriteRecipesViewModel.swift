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
                    let likedRecipes = mockRecipes.filter { likedRecipesIds.contains($0.id) }
                    completion(likedRecipes)
                } else {
                    completion([])
                }
            }
        }
    }
    
}
