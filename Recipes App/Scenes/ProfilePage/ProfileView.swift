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
        
        if let user = viewModel.currentUser {
            Text(user.fullname)
            
            Button(action: {
                viewModel.signOut()
            }, label: {
                Text("Log out")
            })
            Text(user.photoURL)
            
            Spacer()

        }
    }
}

#Preview {
    ProfileView()
}
