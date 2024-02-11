//
//  RecipeDetailsViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.01.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class RecipeDetailsViewModel {
    
    //MARK: - Properties
    
    private var recipe: RecipeData
    
    func heartButtonImage() async -> UIImage {
        let isLiked = await isRecipeLiked(recipe: recipe)
        let imageName = isLiked ? "HeartButtonFilled" : "HeartButton"
        return UIImage(named: imageName) ?? UIImage()
    }
    
    //MARK: - init
    
    init(recipe: RecipeData) {
        self.recipe = recipe
    }
    
    //MARK: - Heart Button Action
    
    func setupButton(button: UIButton) {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let _ = user {
                Task { [weak self] in
                    if let self {
                        let image = await self.heartButtonImage()
                        await button.setImage(image, for: .normal)
                    }
                }
                button.addAction(UIAction { [weak self] _ in
                    self?.handleHeartButtonClick(button: button)
                }, for: .touchUpInside)
            } else {
                button.isHidden = true
            }
        }
    }
    
    func handleHeartButtonClick(button: UIButton) {
        Task {
            if await isRecipeLiked(recipe: recipe) {
                removeRecipeFromLikedRecipes(recipe: recipe)
            } else {
                addRecipeToLikedRecipes(recipe: recipe)
            }
            await button.setImage(heartButtonImage(), for: .normal)
        }
    }

    private func addRecipeToLikedRecipes(recipe: RecipeData) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users").document(userId)
        ref.updateData([
            "likedRecipes": FieldValue.arrayUnion([recipe.id])
        ])
    }

    private func removeRecipeFromLikedRecipes(recipe: RecipeData) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users").document(userId)
        ref.updateData([
            "likedRecipes": FieldValue.arrayRemove([recipe.id])
        ])
    }

    private func isRecipeLiked(recipe: RecipeData) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        let ref = Firestore.firestore().collection("users").document(userId)
        do {
            let documentSnapshot = try await ref.getDocument()

            if let likedRecipes = documentSnapshot.data()?["likedRecipes"] as? [String] {
                return likedRecipes.contains(recipe.id)
            }
        } catch {
            print("Error getting user document: \(error)")
        }

        return false
    }
}
