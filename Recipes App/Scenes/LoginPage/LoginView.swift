//
//  LoginView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(ColorManager.shared.backgroundColor)
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    Text("ავტორიზაცია".uppercased())
                        .font(Font(FontManager.shared.headlineFont ?? .systemFont(ofSize: 12)))
                        .padding(.vertical, 80)
                    TextFieldComponentView(text: $email,
                                           imageSystemName: "envelope",
                                           placeholder: "შეიყვანე მეილი")
                    TextFieldComponentView(text: $password,
                                           imageSystemName: "lock",
                                           placeholder: "შეიყვანე პაროლი",
                                           isSecure: true)
                    .padding(.bottom, 40)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("შესვლა".uppercased())
                            .font(Font(FontManager.shared.bodyFontMedium ?? .systemFont(ofSize: 14)))
                            .foregroundStyle(.white)
                    })
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background(Color(ColorManager.shared.primaryColor))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    Spacer()
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("რეგისტრაცია")
                            .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                            .foregroundStyle(Color(ColorManager.shared.primaryColor))
                    }
                    .padding(.bottom, 20)

                }
                .padding(.horizontal, 35)
            }
        }
    }
}

#Preview {
    LoginView()
}
