//
//  ButtonComponentView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct ButtonComponentView: View {
    var text: String
    var action: (() -> Void)
    
    var body: some View {
        
        Button(action: action, label: {
            Text(text.uppercased())
                .font(Font(FontManager.shared.bodyFontMedium ?? .systemFont(ofSize: 14)))
                .foregroundStyle(.white)
        })
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(Color(ColorManager.shared.primaryColor))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
