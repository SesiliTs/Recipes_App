//
//  TextFieldComponentView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct TextFieldComponentView: View {
    
    @Binding var name: String
    let imageSystemName: String
    let placeholder: String
    let isSecure: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageSystemName)
                    .foregroundStyle(Color(ColorManager.shared.textLightGray))
                    .padding(.horizontal, 10)
                
                if isSecure {
                    
                    TextField(placeholder, text: $name)
                        .frame(height: 45)
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                } else {
                    TextField(placeholder, text: $name)
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
    TextFieldComponentView(name: .constant(""), imageSystemName: "person", placeholder: "სახელი და გვარი")
}
