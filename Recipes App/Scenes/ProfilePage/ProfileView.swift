//
//  ProfileView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        
        if let user = viewModel.currentUser {
            Text(user.fullname)
            
            Button(action: {
                viewModel.signOut()
            }, label: {
                Text("Log out")
            })
        }
    }
}

#Preview {
    ProfileView()
}
