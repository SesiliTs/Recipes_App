//
//  RegistrationView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 25.01.24.
//

import SwiftUI

struct RegistrationView: View {
    @State var name = ""
    
    var body: some View {
        ZStack {
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            VStack {
                Text("რეგისტრაცია".uppercased())
                    .font(Font(FontManager.shared.headlineFont ?? .systemFont(ofSize: 12)))
                
            }
            .padding(35)
        }
    }
}

#Preview {
    RegistrationView()
}
