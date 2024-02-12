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
    @State private var reloadProfileView = false

    @State private var showDeleteConfirmation = false
    @State private var confirmPassword = false
    @State private var wrongPasswordAlert = false
    
    @State private var isEditingName = false
    @State private var isEditingEmail = false
    @State private var isEditingPassword = false
    
    @State private var newName = ""
    @State var shouldShowImagePicker = false
    @State private var image: UIImage?
    
    @State private var newEmail = ""
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    
    @State private var background = ColorManager.shared.backgroundColor
    @State private var textColor = ColorManager.shared.textGrayColor
    
    @State private var bodyFont: UIFont? = FontManager.shared.bodyFont
    @State private var headlineFont: UIFont? = FontManager.shared.headlineFont

    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color(background)
                .ignoresSafeArea()
            
            if let user = viewModel.currentUser {
                VStack(spacing: 40) {
                    AsyncImage(url: URL(string: user.photoURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(.gray)
                            .opacity(0.5)
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding(.top, 80)
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: {
                            shouldShowImagePicker.toggle()
                        }, label: {
                            Image(systemName: "camera")
                                .font(.system(size: 16))
                                .scaledToFill()
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(ColorManager.shared.primaryColor))
                                .clipShape(Circle())
                        })
                    }
                    
                    if isEditingName {
                        nameEditingView
                    } else {
                        nameView(user: user)
                    }
                    
                    if isEditingEmail {
                        emailEditingView
                    } else {
                        HStack(alignment: .center, spacing: 20) {
                            
                            Image(systemName: "envelope")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(textColor))
                            
                            Text(user.email)
                                .font(Font(bodyFont ?? .systemFont(ofSize: 14)))
                                .foregroundStyle(Color(textColor))
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingEmail.toggle()
                            }, label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(textColor))
                            })
                        }
                    }
                    
                    if isEditingPassword {
                        passwordEditingView
                    } else {
                        HStack(alignment: .center, spacing: 20) {
                            Image(systemName: "lock.rectangle")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(textColor))
                            
                            Text("* * * * * * * *")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(textColor))
                                .onTapGesture {
                                    isEditingEmail.toggle()
                                }
                            
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingPassword.toggle()
                            }, label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(textColor))
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
                    
                    NavigationLink {
                        AccessibilityView(reloadProfileView: $reloadProfileView)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        
                        HStack(alignment: .center, spacing: 20) {
                            Image(systemName: "accessibility")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(textColor))
                            
                            Text("accessibility")
                                .font(Font(bodyFont ?? .systemFont(ofSize: 14)))
                                .foregroundStyle(Color(textColor))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(textColor))
                            
                        }
                    }
                    
                    Spacer()
                    
                    ButtonComponentView(text: "გამოსვლა") {
                        viewModel.signOut()
                    }
                    
                    deactivateButtonView
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 50)
                
            }
            
        }
        .onChange(of: reloadProfileView) { _ in
            background = ColorManager.shared.backgroundColor
            textColor = ColorManager.shared.textGrayColor
            bodyFont = FontManager.shared.bodyFont
            headlineFont = FontManager.shared.headlineFont
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
                .onDisappear {
                    if let image {
                        viewModel.changeImage(image: image)
                    }
                }
        }
        
    }
    
    //MARK: - Separate Views
    
    private func nameView(user: User) -> some View {
        HStack {
            Text(user.fullname.uppercased())
                .font(Font(headlineFont ?? .systemFont(ofSize: 16)))
            
            Button(action: {
                isEditingName.toggle()
            }, label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(textColor))
            })
        }
    }
    
    private var nameEditingView: some View {
        HStack {
            TextField("შეიყვანე სახელი და გვარი", text: $newName)
                .padding(.horizontal)
                .font(Font(bodyFont ?? .systemFont(ofSize: 16)))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.changeFullname(newFullname: newName)
                        isEditingName.toggle()
                        newName = ""
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .font(.system(size: 16))
            })
            
            Button(action: {
                isEditingName.toggle()
                newName = ""
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .font(.system(size: 16))
            })
        }
    }
    
    private var emailEditingView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                TextField("შეიყვანე ახალი მეილი", text: $newEmail)
                    .padding(.horizontal)
                    .font(Font(bodyFont ?? .systemFont(ofSize: 14)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                SecureField("შეიყვანე პაროლი", text: $currentPassword)
                    .padding(.horizontal)
                    .font(Font(bodyFont ?? .systemFont(ofSize: 14)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.changeEmail(newEmail: newEmail, currentPassword: currentPassword)
                        isEditingEmail.toggle()
                        currentPassword = ""
                        newEmail = ""
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .font(.system(size: 14))
            })
            
            Button(action: {
                isEditingEmail.toggle()
                currentPassword = ""
                newEmail = ""
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .font(.system(size: 14))
            })
        }
    }
    
    private var passwordEditingView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                SecureField("შეიყვანე ძველი პაროლი", text: $currentPassword)
                    .padding(.horizontal)
                    .font(Font(bodyFont ?? .systemFont(ofSize: 14)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                SecureField("შეიყვანე ახალი პაროლი", text: $newPassword)
                    .padding(.horizontal)
                    .font(Font(bodyFont ?? .systemFont(ofSize: 14)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword)
                        print("Password changed successfully after reauthentication.")
                        isEditingPassword.toggle()
                        currentPassword = ""
                        newPassword = ""
                    } catch {
                        viewModel.showAlert = true
                        viewModel.alertMessage = "პაროლის შეცვლა ვერ მოხერხდა, გთხოვთ სცადოთ თავიდან"
                        currentPassword = ""
                        newPassword = ""
                    }
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .font(.system(size: 14))
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
                currentPassword = ""
                newPassword = ""
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(ColorManager.shared.primaryColor))
                    .font(.system(size: 14))
            })
        }
    }
    
    private var deactivateButtonView: some View {
        Button(action: {
            showDeleteConfirmation = true
        }, label: {
            Text("ანგარიშის გაუქმება")
                .font(Font(bodyFont ?? .systemFont(ofSize: 12)))
                .foregroundStyle(Color(ColorManager.shared.primaryColor))
        })
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("ნამდვილად გსურთ გაუქმება?"),
                message: Text("დადასტურების შემდეგ ვეღარ მოხდება ანგარიშის აღდგენა და დაიკარგება შენახული ინფორმაცია"),
                primaryButton: .default(Text("უკან დაბრუნება")),
                secondaryButton: .destructive(Text("დადასტურება"), action: {
                    confirmPassword.toggle()
                })
            )
        }
        .alert("შეიყვანე პაროლი", isPresented: $confirmPassword) {
            SecureField("შეიყვანე პაროლი", text: $currentPassword)
            Button("უკან") {}
            Button("დადასტურება") {
                Task {
                    do {
                        try await viewModel.deleteUser(password: currentPassword)
                    } catch {
                        wrongPasswordAlert.toggle()
                        currentPassword = ""
                    }
                }
            }
            .foregroundStyle(.red)
        } message: {
            Text("ანგარიშის გასაუქმებლად შეიყვანე პაროლი")
        }
        
        .alert("შეცდომა", isPresented: $wrongPasswordAlert) {
            Button("კარგი") {}
        } message: {
            Text("პაროლი არასწორია, სცადეთ თავიდან")
        }
        
    }
}



//#Preview {
//    ProfileView()
//}
