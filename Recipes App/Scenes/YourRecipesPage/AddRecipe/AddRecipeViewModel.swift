//
//  AddRecipeViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 29.01.24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage


protocol ValidationProtocol {
    var isValid: Bool { get }
}

@MainActor
final class AddRecipeViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var ingredientsList = [String]()
    @Published var userRecipes: [RecipeData] = []
    private let storage: Storage? = nil
    
    //MARK: - Functions
    
    func removeIngredient(item: String) {
        if let index = ingredientsList.firstIndex(of: item) {
            ingredientsList.remove(at: index)
        }
    }
    
    //MARK: - Add Recipe To Firebase
    
    func updateRecipeData(recipeData: RecipeData, image: UIImage?) async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            if let image = image {
                addImageToFirebase(image: image, recipeId: recipeData.id)
            }
            let encodedRecipe = try Firestore.Encoder().encode(recipeData)
            try await Firestore.firestore().collection("users").document(user.uid).updateData([
                "recipes": FieldValue.arrayUnion([encodedRecipe])
            ])
            
            await fetchUserRecipes()
            
        } catch {
            throw error
        }
    }
    
    private func addImageToFirebase(image: UIImage?, recipeId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: "\(uid)/recipes/recipe_\(recipeId)")
        
        guard let imageData = image?.jpegData(compressionQuality: 0.2) else { return }
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
                    let userReference = Firestore.firestore().collection("users").document(uid)
                    
                    userReference.getDocument { document, error in
                        if let error = error {
                            print("Error fetching user document: \(error)")
                            return
                        }
                        
                        guard let document = document, document.exists else {
                            print("User document does not exist.")
                            return
                        }
                        
                        do {
                            let userData = try document.data(as: User.self)
                            var updatedRecipes: [RecipeData] = userData.recipes ?? []
                            if let index = updatedRecipes.firstIndex(where: { $0.id == recipeId }) {
                                updatedRecipes[index].image = downloadURL.absoluteString
                                userReference.updateData(["recipes": updatedRecipes.map { try? Firestore.Encoder().encode($0) }])
                                
                                self.objectWillChange.send()
                            } else {
                                print("Recipe with ID \(recipeId) not found in the user's recipes array.")
                            }
                        } catch {
                            print("Error decoding user data: \(error)")
                        }
                    }
                }
                self.objectWillChange.send()
            }
        }
    }
    
    //MARK: - Get User's Recipes
    
    func fetchUserRecipes() async {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            
            if let data = snapshot.data() {
                if let recipes = data["recipes"] as? [Any] {
                    self.userRecipes = recipes.compactMap { try? Firestore.Decoder().decode(RecipeData.self, from: $0) }
                }
            }
        } catch {
            print("Error fetching user recipes: \(error)")
        }
    }
    
}


