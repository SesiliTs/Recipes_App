//
//  FireStoreManager.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 05.02.24.
//

import Foundation
import FirebaseFirestore

final class FireStoreManager {
    static let shared = FireStoreManager()
    @Published var allRecipes = [RecipeData]()

    private init() {
        fetchAllRecipes { recipes in
            self.allRecipes = recipes
            print(self.allRecipes.count)
        }
    }

    func fetchAllRecipes(completion: @escaping ([RecipeData]) -> Void) {
        let db = Firestore.firestore()

        db.collection("recipes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var recipes = [RecipeData]()
                for document in querySnapshot!.documents {
                    do {
                        if let recipeData = try document.data(as: RecipeData?.self) {
                            recipes.append(recipeData)
                        } else {
                            print("Error decoding recipe data for document: \(document.documentID)")
                        }
                    } catch {
                        print("Error decoding recipe data for document: \(document.documentID), error: \(error)")
                    }
                }
                completion(recipes)
            }
        }
    }
}
