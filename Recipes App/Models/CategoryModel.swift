//
//  CategoryModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

struct Category {
    let image: UIImage?
    let categoryName: String
}

let categoriesViews = [
    Category(image: "🥞".image(), categoryName: "საუზმე"),
    Category(image: "🍜".image(), categoryName: "სადილი"),
    Category(image: "🍰".image(), categoryName: "დესერტი"),
    Category(image: "🍿".image(), categoryName: "ხემსი"),
    Category(image: "🍹".image(), categoryName: "სასმელი")
]
