//
//  OnboardingView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.03.24.
//

import SwiftUI

struct OnboardingView: View {
    
    var dismissTabView: (() -> Void)
    @State private var currentPage = 0
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    currentPage = onboardingPages.count - 1
                }, label: {
                    Text("გამოტოვე >")
                        .padding(16)
                        .foregroundStyle(.gray)
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                })
            }
        }
        
        TabView(selection: $currentPage) {
            ForEach(0..<onboardingPages.count, id: \.self) { page in
                VStack {
                    Image(onboardingPages[page].image)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .padding(.bottom, 20)
                    Text(onboardingPages[page].title)
                        .font(Font(FontManager.shared.headlineFont ?? .boldSystemFont(ofSize: 18)))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 32)
                    Text(onboardingPages[page].description)
                        .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 14)))
                        .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        if currentPage == onboardingPages.count - 1 {
            ButtonComponentView(text: "დაწყება") {
                dismissTabView()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        
        HStack {
            ForEach(0..<onboardingPages.count, id: \.self) { page in
                if page == currentPage {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 20, height: 10)
                        .foregroundStyle(Color(ColorManager.shared.primaryColor))
                } else {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                }
            }
        }
        .padding(.bottom, 50)
    }
    
    func markOnboardingAsCompleted() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "HasLaunchedBefore")
    }
}
