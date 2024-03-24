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
    let commentsQuantity: Int
    let userName: String
    let date: String
    let imageURL: String
}

private func dateFormatter(from Date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
    let dateString = dateFormatter.string(from: Date)
    return dateString
}

let firstPost = Post(id: "001", question: "როგორ გავზომო 250გრ. ფქვილი სასწორის გარეშე, ჭიქით?", body: "მაინტერესებს სასწორის გარეშე, საზომი ჭიქით ან კოვზებით როგორ გავზომო 250გრ. ფქვილი", commentsQuantity: 8, userName: "სალომე წიქარიძე", date: dateFormatter(from: Date()), imageURL: "https://firebasestorage.googleapis.com/v0/b/recipes-app-a9213.appspot.com/o/Kd95PUmow1Y6uYfgPX4DA9eWjsA2%2Fprofile%2Fprofile_image?alt=media&token=376d6f5d-79d5-406f-aae2-f95abe94d058")
let secondPost = Post(id: "002", question: "რა გამოვიყენო გამაფხვიერებლის ნაცვლად?", body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", commentsQuantity: 3, userName: "დიმიტრი კორიფაძე", date: dateFormatter(from: Date()), imageURL: "https://i.pinimg.com/originals/97/05/7c/97057c70bc6dfcd8706a6dc4b2f811d2.png")
let thirdPost = Post(id: "003", question: "კერძს ვამზადებდი და აღარ მქონია ძირა, რით შეიძლება ჩავანაცვლო ხომ არ იცით?", body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", commentsQuantity: 3, userName: "ანა კაკაბაძე", date: dateFormatter(from: Date()), imageURL: "https://ih0.redbubble.net/image.1765102240.0417/raf,360x360,075,t,fafafa:ca443f4786.jpg")

let samplePosts = [firstPost, secondPost, thirdPost, firstPost, thirdPost, secondPost]

