//
//  PostModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 24.03.24.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let question: String
    let body: String
    let userName: String
    var userID: String
    let date: String
    let imageURL: String
    let commentQuantity: Int
}


struct Comment: Codable {
    let userName: String
    let date: String
    let comment: String
    let imageURL: String
}

