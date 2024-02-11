//
//  AccessibilityView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 11.02.24.
//

import SwiftUI

struct AccessibilityView: View {
    
    @State private var fontSize: CGFloat = 12
    @State private var isHighContrastEnabled = false
    @State private var isBoldTextEnabled = false
    
    @State private var background = ColorManager.shared.backgroundColor
    @State private var textColor = ColorManager.shared.textGrayColor
    
    @State private var bodyFont: UIFont? = FontManager.shared.bodyFont
    @State private var headlineFont: UIFont? = FontManager.shared.headlineFont
    
    var body: some View {
        ZStack {
            Color(background)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 50) {
                
                Text("Accessibility".uppercased())
                    .font(Font(FontManager.shared.headlineFont?.withSize(fontSize + 6) ?? .systemFont(ofSize: fontSize + 6)))
                    .padding(.top, 30)
                
                Spacer()
                
                Toggle("მაღალი კონტრასტი", isOn: $isHighContrastEnabled)
                    .font(Font(bodyFont?.withSize(fontSize) ?? .systemFont(ofSize: 12)))
                    .foregroundStyle(Color(textColor))
                    .onChange(of: isHighContrastEnabled, perform: { value in
                        background = value ? .white : ColorManager.shared.backgroundColor
                        textColor = value ? .black : ColorManager.shared.textGrayColor
                    })
                
                Toggle("მუქი ტექსტი", isOn: $isBoldTextEnabled)
                    .font(Font(bodyFont?.withSize(fontSize) ?? .systemFont(ofSize: 12)))
                    .foregroundStyle(Color(textColor))
                    .onChange(of: isBoldTextEnabled, perform: { value in
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
                    print("save button clicked")
                }
                .padding(.bottom, 30)
                
            }
            .padding(20)
        }
    }
    
    private var sliderView: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            Text("ტექსტის ზომა")
                .font(Font(bodyFont?.withSize(fontSize) ?? .systemFont(ofSize: 12)))
                .foregroundStyle(Color(textColor))
            
            
            HStack(spacing: 10) {
                Text("A")
                    .font(.system(size: 12))
                Slider(value: $fontSize, in: 12...16, step: 1)
                    .tint(Color(ColorManager.shared.primaryColor))
                
                Text("A")
                    .font(.system(size: 16))
            }
        }
    }
}

#Preview {
    AccessibilityView()
}
