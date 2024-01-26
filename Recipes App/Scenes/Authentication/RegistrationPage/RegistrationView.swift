//
//  RegistrationView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 25.01.24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPasword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            
            VStack {
            
                VStack(spacing: 25) {
                    
                    Text("რეგისტრაცია".uppercased())
                        .font(Font(FontManager.shared.headlineFont ?? .systemFont(ofSize: 12)))
                        .padding(.vertical, 80)
                    TextFieldComponentView(text: $name,
                                           imageSystemName: "person",
                                           placeholder: "სახელი და გვარი")
                    TextFieldComponentView(text: $email,
                                           imageSystemName: "envelope",
                                           placeholder: "შეიყვანე მეილი")
                    .textInputAutocapitalization(.never)
                    TextFieldComponentView(text: $password,
                                           imageSystemName: "lock",
                                           placeholder: "შეიყვანე პაროლი",
                                           isSecure: true)
                    TextFieldComponentView(text: $repeatPasword,
                                           imageSystemName: "lock",
                                           placeholder: "გაიმეორე პაროლი",
                                           isSecure: true)
                    .padding(.bottom, 40)
                    
                    ButtonComponentView(text: "რეგისტრაცია") {
                        Task {
                            try await viewModel.signUp(email: email,
                                                       password: password,
                                                       fullname: name,
                                                       photoURL: "")
                        }
                    }
                    
                    Spacer()
                    
                }
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("ავტორიზაცია")
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                        .foregroundStyle(Color(ColorManager.shared.primaryColor))
                })
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 35)

        }
    }
}

#Preview {
    RegistrationView()
}
