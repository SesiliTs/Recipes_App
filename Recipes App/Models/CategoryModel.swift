//
//  CategoryModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

struct CategoryData {
    let image: UIImage?
    let categoryName: String
}

let categoriesViews = [
    CategoryData(image: "🥞".image(), categoryName: "საუზმე"),
    CategoryData(image: "🍜".image(), categoryName: "სადილი"),
    CategoryData(image: "🍰".image(), categoryName: "დესერტი"),
    CategoryData(image: "🍿".image(), categoryName: "ხემსი"),
    CategoryData(image: "🍹".image(), categoryName: "სასმელი"),
    CategoryData(image: "🍱".image(), categoryName: "სხვა")
]

let categoryCases: [String: Category] = [
    "საუზმე": .breakfast,
    "სადილი": .dinner,
    "დესერტი": .dessert,
    "წასახემსებელი": .snack,
    "სასმელი": .drink,
    "სხვა": .other
]

