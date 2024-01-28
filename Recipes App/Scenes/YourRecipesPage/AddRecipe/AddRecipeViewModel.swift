//
//  AddRecipeViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 29.01.24.
//

import Foundation

class AddRecipeViewModel: ObservableObject {
    
    @Published var ingredientsList = [String]()

    func removeIngredient(item: String) {
        if let index = ingredientsList.firstIndex(of: item) {
            ingredientsList.remove(at: index)
        }
    }
}
