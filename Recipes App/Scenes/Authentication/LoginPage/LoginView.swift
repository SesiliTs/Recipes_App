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
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(ColorManager.shared.backgroundColor)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    Text("ავტორიზაცია".uppercased())
                        .font(Font(FontManager.shared.headlineFont ?? .systemFont(ofSize: 12)))
                        .padding(.top, 80)
                    
                    VStack(spacing: 25) {
                        
                        TextFieldComponentView(text: $email,
                                               imageSystemName: "envelope",
                                               placeholder: "შეიყვანე მეილი")
                        .textInputAutocapitalization(.never)
                        TextFieldComponentView(text: $password,
                                               imageSystemName: "lock",
                                               placeholder: "შეიყვანე პაროლი",
                                               isSecure: true)
                    }
                    
                    ButtonComponentView(text: "შესვლა") {
                        Task {
                            try await viewModel.signIn(email: email, password: password)
                        }
                    }
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("რეგისტრაცია")
                            .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                            .foregroundStyle(Color(ColorManager.shared.primaryColor))
                    }
                }
                .padding(35)
            }
        }
    }
}

#Preview {
    LoginView()
}
