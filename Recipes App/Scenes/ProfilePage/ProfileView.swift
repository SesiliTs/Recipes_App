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
                        ProgressView()
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
