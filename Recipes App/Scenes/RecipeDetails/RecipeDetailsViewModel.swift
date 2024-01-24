//
//  RecipeDetailsViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.01.24.
//

import UIKit

final class RecipeDetailsViewModel {
    
    //MARK: - Properties
    
    private var recipe: RecipeData
    
    var heartButtonImage: UIImage {
        if recipe.isLiked {
            return UIImage(named: "HeartButtonFilled") ?? UIImage()
        } else {
            return UIImage(named: "HeartButton") ?? UIImage()
        }
    }
    
    //MARK: - init
    
    init(recipe: RecipeData) {
        self.recipe = recipe
    }
    
    //MARK: - Heart Button Action
    
    func handleHeartButtonClick() {
        recipe.isLiked.toggle()
    }
    
}
