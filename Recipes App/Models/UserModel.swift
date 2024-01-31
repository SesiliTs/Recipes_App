//
//  UserModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    var photoURL: String
    let recipes: [RecipeData]?
}

let mockUser = User(id: UUID().uuidString, fullname: "სესილი წიქარიძე", email: "sesili@gmail.com", photoURL: "", recipes: [])
