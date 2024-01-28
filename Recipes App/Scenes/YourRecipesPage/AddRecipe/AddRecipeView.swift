//
//  AddRecipeView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.01.24.
//

import SwiftUI

struct AddRecipeView: View {
    
    @State private var image: UIImage?
    @State private var shouldShowImagePicker = false
    @State private var recipeName = ""
    @State private var time = ""
    @State private var portion = ""
    
    @State private var selection = "საუზმე"
    private let categoriesArray = ["საუზმე", "სადილი", "დესერტი", "წასახემსებელი", "სასმელი", "სხვა"]
    @State private var showDropdown = false
    
    @State private var selectedButton: Int?
    @State private var difficulty: DifficultyLevel?
    
    var body: some View {
        
        ZStack {
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 35) {
                imagePickerView
                    .padding(.top, 50)
                recipeNameView
                detailsView
                
                difficultyButtons
            }
            .padding(.horizontal, 35)
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }

        }
    }
    
    //MARK: - Separate Views
    
    private var imagePickerView: some View {
        Button {
            shouldShowImagePicker.toggle()
        } label: {
            
            VStack(spacing: 15) {
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Image(systemName: "plus")
                        .font(.system(size: 40))
                        .padding()
                        .foregroundStyle(Color(ColorManager.shared.primaryColor))
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor(hexString: "#F3F2F2")))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
        }
    }
    
    private var recipeNameView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("სახელი".uppercased())
                .font(Font(FontManager.shared.bodyFontMedium?.withSize(18) ?? .systemFont(ofSize: 18)))
            TextFieldComponentView(text: $recipeName, imageSystemName: "tag", placeholder: "რეცეპტის სახელი")
        }
    }
    
    private var detailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("დეტალები".uppercased())
                .font(Font(FontManager.shared.bodyFontMedium?.withSize(18) ?? .systemFont(ofSize: 18)))
            
            HStack(spacing: 10) {
                TextFieldComponentView(text: $time, imageSystemName: "alarm", placeholder: "დრო (წუთი)")
                    .keyboardType(.numberPad)
                TextFieldComponentView(text: $portion, imageSystemName: "person.2", placeholder: "პორცია")
                    .keyboardType(.numberPad)
            }
            
            ZStack {
                AnyShape(RoundedRectangle(cornerRadius: 18))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .foregroundStyle(.white)
                HStack {
                    Text("კატეგორია:".uppercased())
                        .font(Font(FontManager.shared.bodyFontMedium?.withSize(16) ?? .systemFont(ofSize: 16)))
                        .padding(.leading, 10)
                    Spacer()
                    Picker("Picker Name",
                           selection: $selection) {
                        ForEach(categoriesArray,
                                id: \.self) {
                            Text($0)
                        }
                    }
                           .pickerStyle(.menu)
                           .tint(Color(ColorManager.shared.primaryColor))
                }
            }
        }
    }
    
    private var difficultyButtons: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("სირთულე".uppercased())
                .font(Font(FontManager.shared.bodyFontMedium?.withSize(18) ?? .systemFont(ofSize: 18)))
            
            HStack(spacing: 10) {
                DifficultyButton(title: "მარტივი", difficultyLevel: .easy, selectedDifficulty: $difficulty)
                DifficultyButton(title: "საშუალო", difficultyLevel: .normal, selectedDifficulty: $difficulty)
                DifficultyButton(title: "რთული", difficultyLevel: .hard, selectedDifficulty: $difficulty)
            }
        }
    }
    
}

#Preview {
    AddRecipeView()
}
