//
//  AddRecipeView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.01.24.
//

import SwiftUI

struct AddRecipeView: View {
    
    //MARK: - Properties
    
    @StateObject private var viewModel = AddRecipeViewModel()
    
    var dismissAction: (() -> Void)?
    
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
    
    @State private var ingredient = ""
    @State private var recipeDetails = ""
    
    @State private var isLoading = false
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            Color(ColorManager.shared.backgroundColor)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 35) {
                    imagePickerView
                    recipeNameView
                    detailsView
                    difficultyButtons
                    ingredientsView
                    recipeView
                    ButtonComponentView(text: "დამატება") {
                        Task {
                            await addRecipe()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dismissAction?()
                        }
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1.0 : 0.6)
                    
                }
                .padding(.all, 16)
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                        .ignoresSafeArea()
                }
                
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(ColorManager.shared.primaryColor)))
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
    
    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("ინგრედიენტები".uppercased())
                .font(Font(FontManager.shared.bodyFontMedium?.withSize(18) ?? .systemFont(ofSize: 18)))
            
            HStack {
                TextField("დაამატე ინგრედიენტი", text: $ingredient)
                    .frame(height: 45)
                    .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                    .padding(.horizontal, 10)
                
                Button(action: {
                    addIngredient()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .padding()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 25)
                        .background(Color(ColorManager.shared.primaryColor))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 10)
                }
            }
            .textFieldStyle(DefaultTextFieldStyle())
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            listView
            
        }
        
    }
    
    private var listView: some View {
        
        ForEach(viewModel.ingredientsList, id: \.self) { item in
            VStack {
                HStack {
                    Text(item)
                        .font(Font(FontManager.shared.bodyFont?.withSize(14) ?? .systemFont(ofSize: 12)))
                        .foregroundStyle(Color(ColorManager.shared.textGrayColor))
                    Spacer()
                    Button(action: {
                        viewModel.removeIngredient(item: item)
                    }) {
                        Image(systemName: "xmark.bin")
                            .font(.system(size: 15))
                            .foregroundColor(Color(ColorManager.shared.textGrayColor))
                    }
                }
                Rectangle()
                    .fill(Color(ColorManager.shared.primaryColor))
                    .frame(height: 0.3)
                
            }
        }
    }
    
    private var recipeView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("მომზადების წესი".uppercased())
                .font(Font(FontManager.shared.bodyFontMedium?.withSize(18) ?? .systemFont(ofSize: 18)))
            
            TextEditor(text: $recipeDetails)
                .multilineTextAlignment(.leading)
                .frame(minHeight: 100)
                .font(Font(FontManager.shared.bodyFont ?? .systemFont(ofSize: 12)))
                .padding(.horizontal, 10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    
    //MARK: - Private Functions
    
    private func addIngredient() {
        guard !ingredient.isEmpty else { return }
        viewModel.ingredientsList.append(ingredient)
        ingredient = ""
    }
    
    private func addRecipe() async {
        
        isLoading = true
        
        let selectedCategory = categoryCases[selection] ?? .other
        
        let timeInt = Int(time) ?? 0
        let portionInt = Int(portion) ?? 0
    
        let recipeData = RecipeData(name: recipeName, image: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png", time: timeInt, portion: portionInt, difficulty: difficulty ?? .easy, ingredients: viewModel.ingredientsList, recipe: recipeDetails, isLiked: false, category: selectedCategory)
        
        do {
            try await viewModel.updateRecipeData(recipeData: recipeData, image: image)
        } catch {
            print("Failed to add recipe: \(error)")
        }
    }
}

//MARK: - Fields Validation

extension AddRecipeView: ValidationProtocol {
    var isValid: Bool {
        return !recipeName.isEmpty
        && !time.isEmpty
        && !portion.isEmpty
        && !viewModel.ingredientsList.isEmpty
        && !recipeDetails.isEmpty
    }
}

#Preview {
    AddRecipeView()
}
