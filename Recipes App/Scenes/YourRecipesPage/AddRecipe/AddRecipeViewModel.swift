//
//  AddRecipeViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 29.01.24.
//

import Foundation
import Firebase
import FirebaseFirestore


final class AddRecipeViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var ingredientsList = [String]()    
    
    //MARK: - Functions

    func removeIngredient(item: String) {
        if let index = ingredientsList.firstIndex(of: item) {
            ingredientsList.remove(at: index)
        }
    }
            
    func updateRecipeData(recipeData: RecipeData) async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            let encodedRecipe = try Firestore.Encoder().encode(recipeData)
            try await Firestore.firestore().collection("users").document(user.uid).updateData([
                "recipes": FieldValue.arrayUnion([encodedRecipe])
            ])

        } catch {
            throw error
        }
    }
}
