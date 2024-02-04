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
    var isLiked: Bool
    let category: Category
}

enum DifficultyLevel: Codable {
    case easy
    case normal
    case hard
}

enum Category: Codable {
    case breakfast
    case dinner
    case dessert
    case snack
    case drink
    case other
}

let mockRecipes = [
    RecipeData(id: "id1", name: "ბრაუნი", image: "https://joyfoodsunshine.com/wp-content/uploads/2018/01/best-black-bean-brownies-recipe-4.jpg", time: 40, portion: 8, difficulty: .normal, ingredients: ["200 გრ. შაქარი", "3ც. კვერცხი", "150გრ. ფქვილი", "185გრ. კარაქი", "185გრ. შავი შოკოლადი"], recipe: "ორთქლზე გაადნეთ კარაქი და შავი შოკოლადი. შაქარი, კვერცხი და მწიკვი მარილი ათქვიფეთ, სანამ არ გათეთრდება მასა. დაამატეთ ფქვილი, შოკოლადის მასა, ვანილი.", isLiked: false, category: .dessert),
    RecipeData(id: "id2", name: "ფენქეიქები", image: "https://www.wholesomeyum.com/wp-content/uploads/2017/03/wholesomeyum-Low-Carb-Keto-Pancakes-Recipe-21-500x500.jpg", time: 20, portion: 4, difficulty: .easy, ingredients: ["200 გრ. შაქარი", "3ც. კვერცხი", "150გრ. ფქვილი", "185გრ. კარაქი", "185გრ. შავი შოკოლადი"], recipe: "ორთქლზე გაადნეთ კარაქი და შავი შოკოლადი. შაქარი, კვერცხი და მწიკვი მარილი ათქვიფეთ, სანამ არ გათეთრდება მასა. დაამატეთ ფქვილი, შოკოლადის მასა, ვანილი.", isLiked: false, category: .breakfast),
    RecipeData(id: "id3", name: "ტორტი", image: "https://preppykitchen.com/wp-content/uploads/2022/05/Naked-Cake-Recipe-Card.jpg", time: 60, portion: 16, difficulty: .hard, ingredients: ["200 გრ. შაქარი", "3ც. კვერცხი", "150გრ. ფქვილი", "185გრ. კარაქი", "185გრ. შავი შოკოლადი"], recipe: "ორთქლზე გაადნეთ კარაქი და შავი შოკოლადი. შაქარი, კვერცხი და მწიკვი მარილი ათქვიფეთ, სანამ არ გათეთრდება მასა. დაამატეთ ფქვილი, შოკოლადის მასა, ვანილი.", isLiked: false, category: .dessert),
    RecipeData(id: "id4", name: "ბრაუნი", image: "https://joyfoodsunshine.com/wp-content/uploads/2018/01/best-black-bean-brownies-recipe-4.jpg", time: 40, portion: 8, difficulty: .normal, ingredients: ["200 გრ. შაქარი", "3ც. კვერცხი", "150გრ. ფქვილი", "185გრ. კარაქი", "185გრ. შავი შოკოლადი"], recipe: "ორთქლზე გაადნეთ კარაქი და შავი შოკოლადი. შაქარი, კვერცხი და მწიკვი მარილი ათქვიფეთ, სანამ არ გათეთრდება მასა. დაამატეთ ფქვილი, შოკოლადის მასა, ვანილი.", isLiked: false, category: .dessert),
    RecipeData(id: "id5", name: "ფენქეიქები", image: "https://www.wholesomeyum.com/wp-content/uploads/2017/03/wholesomeyum-Low-Carb-Keto-Pancakes-Recipe-21-500x500.jpg", time: 20, portion: 4, difficulty: .easy, ingredients: ["200 გრ. შაქარი", "3ც. კვერცხი", "150გრ. ფქვილი", "185გრ. კარაქი", "185გრ. შავი შოკოლადი"], recipe: "ორთქლზე გაადნეთ კარაქი და შავი შოკოლადი. შაქარი, კვერცხი და მწიკვი მარილი ათქვიფეთ, სანამ არ გათეთრდება მასა. დაამატეთ ფქვილი, შოკოლადის მასა, ვანილი.", isLiked: false, category: .breakfast),
    RecipeData(id: "id6", name: "ტორტი", image: "https://preppykitchen.com/wp-content/uploads/2022/05/Naked-Cake-Recipe-Card.jpg", time: 60, portion: 16, difficulty: .hard, ingredients: ["200 გრ. შაქარი", "3ც. კვერცხი", "150გრ. ფქვილი", "185გრ. კარაქი", "185გრ. შავი შოკოლადი"], recipe: "ორთქლზე გაადნეთ კარაქი და შავი შოკოლადი. შაქარი, კვერცხი და მწიკვი მარილი ათქვიფეთ, სანამ არ გათეთრდება მასა. დაამატეთ ფქვილი, შოკოლადის მასა, ვანილი.", isLiked: false, category: .dessert)
]
