//
//  ProfilePage.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.01.24.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ProfileView()
                    .environmentObject(AuthViewModel())
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ProfilePage()
}
