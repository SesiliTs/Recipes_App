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
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            
            if let user = viewModel.currentUser {
                VStack(spacing: 30) {
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
                    Text(user.email)
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                        .foregroundStyle(Color(ColorManager.shared.textLightGray))
                        .padding(.top, -10)
                    
                    Spacer()
                    
                    ButtonComponentView(text: "გამოსვლა") {
                        viewModel.signOut()
                    }
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

                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 35)

            }

        }
    }
}

#Preview {
    ProfileView()
}
