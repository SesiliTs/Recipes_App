//
//  LandingPageViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import Foundation
import Firebase
import FirebaseFirestore

final class LandingPageViewModel: ObservableObject {

    private let db = Firestore.firestore()
    @Published var recipes: [RecipeData] = []

    func fetchRecipes() async {
        do {
            let querySnapshot = try await db.collection("recipes").getDocuments()
            
            recipes = querySnapshot.documents.compactMap { document in
                do {
                    return try document.data(as: RecipeData.self)
                } catch {
                    print("Error decoding recipe data: \(error)")
                    return nil
                }
            }
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
}

