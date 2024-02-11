//
//  UserModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    var email: String
    var photoURL: String
    let recipes: [RecipeData]?
    let likedRecipes: [String]?
}
