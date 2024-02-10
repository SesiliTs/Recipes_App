//
//  YourRecipesViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 10.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class YourRecipesViewModel {
    
    //MARK: - Delete Recipe
    
    func deleteRecipe(recipeId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                var recipes = userData?["recipes"] as? [[String: Any]] ?? []
                
                recipes = recipes.filter { $0["id"] as? String != recipeId }
                
                userRef.updateData(["recipes": recipes]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Recipe removed successfully")
                    }
                }
            } else {
                print("User document not found")
            }
        }
    }
}
