//
//  DifficultyButton.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.01.24.
//

import SwiftUI

struct DifficultyButton: View {
    let title: String
    let difficultyLevel: DifficultyLevel
    @Binding var selectedDifficulty: DifficultyLevel?

    var body: some View {
        Button(action: {
            selectedDifficulty = difficultyLevel
        }) {
            Text(title)
                .font(Font(FontManager.shared.bodyFont?.withSize(14) ?? .systemFont(ofSize: 14)))
                .foregroundColor(selectedDifficulty == difficultyLevel ? .white : Color(ColorManager.shared.textGrayColor))
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(selectedDifficulty == difficultyLevel ? Color(ColorManager.shared.primaryColor) : Color.white)
                .cornerRadius(18)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(ColorManager.shared.primaryColor), lineWidth: 1)
                .opacity(0.3)
        )
    }

}
