//
//  RegistrationView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 25.01.24.
//

import SwiftUI

struct RegistrationView: View {
    
    //MARK: - Properties
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPasword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    //MARK: - Body

    var body: some View {
        ZStack {
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            
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
                addValidation()
                    .padding(.top, -15)
                TextFieldComponentView(text: $repeatPasword,
                                       imageSystemName: "lock",
                                       placeholder: "გაიმეორე პაროლი",
                                       isSecure: true)
                .padding(.top, -15)
                .padding(.bottom, 40)
                
                ButtonComponentView(text: "რეგისტრაცია") {
                    Task {
                        try await viewModel.signUp(email: email,
                                                   password: password,
                                                   fullname: name,
                                                   photoURL: "")
                    }
                }
                .disabled(!isValid)
                .opacity(isValid ? 1.0 : 0.6)
                
                Spacer()
                
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
    
    func addValidation() -> some View {
        let containsNumeric = password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        let numericColor = containsNumeric ? Color.green : Color.red
        let lengthColor = password.count > 5 ? Color.green : Color.red

        return VStack(alignment: .leading, spacing: 5) {
            Text("* პაროლი უნდა შეიცავდეს მინიმუმ ერთ ციფრს")
                .font(Font(FontManager.shared.bodyFont?.withSize(9) ?? .systemFont(ofSize: 9)))
                .foregroundStyle(numericColor)

            Text("* პაროლი უნდა შეიცავდეს მინიმუმ 5 სიმბოლოს")
                .font(Font(FontManager.shared.bodyFont?.withSize(9) ?? .systemFont(ofSize: 9)))
                .foregroundStyle(lengthColor)
        }
    }
}

//MARK: - Validation Protocol

extension RegistrationView: AuthenticationValidationProtocol {
    var isValid: Bool {
        
        let digitCharacterSet = CharacterSet.decimalDigits
        
        return !email.isEmpty
        && !password.isEmpty
        && email.contains("@")
        && !name.isEmpty
        && password.count > 5
        && password == repeatPasword
        && password.rangeOfCharacter(from: digitCharacterSet) != nil
    }
}

#Preview {
    RegistrationView()
}
