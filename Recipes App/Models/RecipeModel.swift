//
//  RecipeModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import Foundation


struct RecipeData: Codable {
    let id: String
    let name: String
    var image: String
    let time: Int
    let portion: Int
    let difficulty: DifficultyLevel
    let ingredients: [String]
    let recipe: String
    let category: Category
}

enum DifficultyLevel: String, Codable {
    case easy = "მარტივი"
    case normal = "საშუალო"
    case hard = "რთული"
}

enum Category: String, Codable {
    case breakfast = "საუზმე"
    case dinner = "სადილი"
    case dessert = "დესერტი"
    case snack = "წასახემსებელი"
    case drink = "სასმელი"
    case other = "სხვა"
}
