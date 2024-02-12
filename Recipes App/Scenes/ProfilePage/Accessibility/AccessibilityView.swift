//
//  AccessibilityView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 11.02.24.
//

import SwiftUI

struct AccessibilityView: View {
    
    //MARK: - Properties
    
    @StateObject private var viewModel = AccessibilityViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var reloadProfileView: Bool
    
    @State private var background = ColorManager.shared.backgroundColor
    @State private var textColor = ColorManager.shared.textGrayColor
    
    @State private var bodyFont: UIFont? = FontManager.shared.bodyFont
    @State private var headlineFont: UIFont? = FontManager.shared.headlineFont
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color(background)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 50) {
                
                Text("Accessibility".uppercased())
                    .font(Font(FontManager.shared.headlineFont?.withSize(viewModel.fontSize + 6) ?? .systemFont(ofSize: viewModel.fontSize + 6)))
                    .padding(.top, 30)
                
                Spacer()
                
                Toggle("მაღალი კონტრასტი", isOn: $viewModel.isHighContrastEnabled)
                    .font(Font(bodyFont?.withSize(viewModel.fontSize) ?? .systemFont(ofSize: 12)))
                    .foregroundStyle(Color(textColor))
                    .onChange(of: viewModel.isHighContrastEnabled, perform: { value in
                        background = value ? .white : ColorManager.shared.backgroundColor
                        textColor = value ? .black : ColorManager.shared.textGrayColor
                    })
                
                Toggle("მუქი ტექსტი", isOn: $viewModel.isBoldTextEnabled)
                    .font(Font(bodyFont?.withSize(viewModel.fontSize) ?? .systemFont(ofSize: 12)))
                    .foregroundStyle(Color(textColor))
                    .onChange(of: viewModel.isBoldTextEnabled, perform: { value in
                        if value {
                            bodyFont = FontManager.shared.headlineFont
                        } else {
                            bodyFont = FontManager.shared.bodyFont
                        }
                    })
                
                Spacer()
                
                sliderView
                
                Spacer()
                
                ButtonComponentView(text: "შენახვა") {
                    Task {
                        await saveAccessibilitySettings()
                        reloadProfileView.toggle()
                        dismiss()
                    }
                }
                .padding(.bottom, 30)
                
            }
            .padding(20)
        }
        .onAppear {
            fetchAccessibilitySettings()
        }
    }
    
    //MARK: - Button Action
    
    private func saveAccessibilitySettings() async {
        do {
            try await viewModel.updateAccessibilitySettings(highContrast: viewModel.isHighContrastEnabled, boldText: viewModel.isBoldTextEnabled, fontSize: viewModel.fontSize)
        } catch {
            print("Failed to save accessibility settings: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Fetch Settings
    
    private func fetchAccessibilitySettings() {
        viewModel.fetchAccessibilitySettings { [self] settings, error in
            guard let settings = settings else {
                print("Error fetching accessibility settings: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                self.viewModel.isHighContrastEnabled = settings.highContrast
                self.viewModel.isBoldTextEnabled = settings.boldText
                self.viewModel.fontSize = settings.fontSize
            }
        }
    }
    
    //MARK: - Separate Views
    
    private var sliderView: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            Text("ტექსტის ზომა")
                .font(Font(bodyFont?.withSize(viewModel.fontSize) ?? .systemFont(ofSize: 12)))
                .foregroundStyle(Color(textColor))
            
            
            HStack(spacing: 10) {
                Text("A")
                    .font(.system(size: 12))
                Slider(value: $viewModel.fontSize, in: 12...16, step: 1)
                    .tint(Color(ColorManager.shared.primaryColor))
                
                Text("A")
                    .font(.system(size: 16))
            }
        }
    }
}

//#Preview {
//    AccessibilityView()
//}
