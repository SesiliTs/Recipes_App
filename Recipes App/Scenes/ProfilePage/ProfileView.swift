//
//  ProfileView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct ProfileView: View {
    
    //MARK: - Properties
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showDeleteConfirmation = false
    
    @State private var isEditingEmail = false
    @State private var isEditingPassword = false
    
    @State private var newEmail = ""
    
    @State private var oldPassword = ""
    @State private var newPassword = ""
        
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            
            if let user = viewModel.currentUser {
                VStack(alignment: .leading, spacing: 30) {
                    AsyncImage(url: URL(string: user.photoURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .foregroundStyle(.gray)
                            .clipShape(Circle())
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding(.top, 80)
                    
                    Text(user.fullname.uppercased())
                        .font(Font(FontManager.shared.headlineFont ?? .systemFont(ofSize: 16)))
                    
                    if isEditingEmail {
                        emailEditingView
                    } else {
                        HStack(alignment: .center, spacing: 20) {
                            
                            Image(systemName: "person")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                            
                            Text(user.email)
                                .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 14)))
                                .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingEmail.toggle()
                            }, label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                            })
                        }
                    }
                    
                    if isEditingPassword {
                        passwordEditingView
                    } else {
                        HStack(alignment: .center, spacing: 20) {
                            Image(systemName: "lock.square")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                            
                            Text("* * * * * * * *")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                                .onTapGesture {
                                    isEditingEmail.toggle()
                                }
                            
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingPassword.toggle()
                            }, label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                            })
                            .alert(isPresented: $viewModel.showSuccessAlert) {
                                Alert(
                                    title: Text(""),
                                    message: Text("პაროლი წარმატებით შეიცვალა"),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    ButtonComponentView(text: "გამოსვლა") {
                        viewModel.signOut()
                    }
                    
                    deactivateButtonView
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
                
            }
            
        }
    }
    
    //MARK: - Separate Views
    
    private var emailEditingView: some View {
        HStack {
            TextField("შეიყვანე ახალი მეილი", text: $newEmail)
                .padding(.horizontal)
                .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 14)))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.changeEmail(newEmail: newEmail)
                        isEditingEmail.toggle()
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .padding(.trailing, 10)
            })
            
            Button(action: {
                isEditingEmail.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .padding(.trailing, 10)
            })
        }
    }
    
    private var passwordEditingView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                SecureField("შეიყვანე ძველი პაროლი", text: $oldPassword)
                    .padding(.horizontal)
                    .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 14)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                SecureField("შეიყვანე ახალი პაროლი", text: $newPassword)
                    .padding(.horizontal)
                    .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 14)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.changePassword(currentPassword: oldPassword, newPassword: newPassword)
                        print("Password changed successfully after reauthentication.")
                        isEditingPassword.toggle()
                        oldPassword = ""
                        newPassword = ""
                    } catch {
                        viewModel.showAlert = true
                        viewModel.alertMessage = "პაროლის შეცვლა ვერ მოხერხდა, გთხოვთ სცადოთ თავიდან"
                        oldPassword = ""
                        newPassword = ""
                    }
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .padding(.trailing, 10)
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("შეცდომა"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("გასაგებია"))
                )
            }
            
            Button(action: {
                isEditingPassword.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .padding(.trailing, 10)
            })
        }
    }
    
    private var deactivateButtonView: some View {
        Button(action: {
            showDeleteConfirmation = true
        }, label: {
            Text("ანგარიშის გაუქმება")
                .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                .foregroundStyle(Color(ColorManager.shared.primaryColor))
        })
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("ნამდვილად გსურთ გაუქმება?"),
                message: Text("დადასტურების შემდეგ ვეღარ მოხდება ანგარიშის აღდგენა და დაიკარგება შენახული ინფორმაცია"),
                primaryButton: .default(Text("უკან დაბრუნება")),
                secondaryButton: .destructive(Text("დადასტურება"), action: {
                    Task {
                        do {
                            try await viewModel.deleteUser()
                        } catch {
                            print(error)
                        }
                    }
                })
            )
        }
    }
}



#Preview {
    ProfileView()
}
