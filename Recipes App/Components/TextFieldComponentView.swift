//
//  TextFieldComponentView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct TextFieldComponentView: View {
    
    @Binding var text: String
    let imageSystemName: String
    let placeholder: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageSystemName)
                    .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                    .padding(.horizontal, 10)
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .frame(height: 45)
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                } else {
                    TextField(placeholder, text: $text)
                        .frame(height: 45)
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                }
            }
            .textFieldStyle(DefaultTextFieldStyle())
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

#Preview {
    TextFieldComponentView(text: .constant(""), imageSystemName: "person", placeholder: "სახელი და გვარი")
}
