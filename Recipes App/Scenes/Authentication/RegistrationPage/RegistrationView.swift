//
//  RegistrationView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 25.01.24.
//

import SwiftUI

struct RegistrationView: View {
    
    //MARK: - Properties
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
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
                    .padding(.top, 30)
                imagePickerView
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
                addValidation
                    .padding(.top, -15)
                TextFieldComponentView(text: $repeatPassword,
                                       imageSystemName: "lock",
                                       placeholder: "გაიმეორე პაროლი",
                                       isSecure: true)
                .padding(.top, -15)
                
                ButtonComponentView(text: "რეგისტრაცია") {
                    Task {
                        do {
                            try await viewModel.signUp(email: email, password: password, repeatPassword: repeatPassword, fullname: name, image: image)
                        } catch {
                            print("Failed to sign up. Error: \(error.localizedDescription)")
                        }
                    }
                }
                .disabled(!isValid)
                .opacity(isValid ? 1.0 : 0.6)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("შეცდომა"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("ავტორიზაცია")
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                        .foregroundStyle(Color(ColorManager.shared.primaryColor))
                })
                Spacer()
            }
            .padding(.horizontal, 35)
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }
            
        }
    }
    
    //MARK: - Validation Labels
    
    private var addValidation: some View {
        let containsNumeric = password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        let numericColor = containsNumeric ? Color.green : Color.red
        let lengthColor = password.count > 5 ? Color.green : Color.red
        
        return VStack(alignment: .leading, spacing: 5) {
            Text("* პაროლი უნდა შეიცავდეს მინიმუმ ერთ ციფრს")
                .font(Font(FontManager.shared.bodyFont?.withSize(9) ?? .systemFont(ofSize: 9)))
                .foregroundStyle(numericColor)
            
            Text("* პაროლი უნდა შეიცავდეს მინიმუმ 6 სიმბოლოს")
                .font(Font(FontManager.shared.bodyFont?.withSize(9) ?? .systemFont(ofSize: 9)))
                .foregroundStyle(lengthColor)
        }
    }
    
    private var imagePickerView: some View {
        Button {
            shouldShowImagePicker.toggle()
        } label: {
            
            VStack(spacing: 15) {
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "plus")
                        .font(.system(size: 40))
                        .padding()
                        .foregroundStyle(Color(ColorManager.shared.primaryColor))
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .background(Color(UIColor(hexString: "#F3F2F2")))
                        .clipShape(Circle())
                }
                
                VStack(spacing: 5) {
                    Image(systemName: "chevron.up")
                        .foregroundStyle(Color(ColorManager.shared.primaryColor))
                        .font(.system(size: 12))
                    Text("ატვირთე სურათი")
                        .font(Font(FontManager.shared.bodyFont?.withSize(10) ?? .systemFont(ofSize: 10)))
                        .foregroundStyle(Color(ColorManager.shared.textLightGray))
                }
            }
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
        && password.rangeOfCharacter(from: digitCharacterSet) != nil
    }
}

#Preview {
    RegistrationView()
}
