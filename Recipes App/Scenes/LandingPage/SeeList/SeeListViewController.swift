//
//  SeeAllViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 31.01.24.
//

import UIKit

final class SeeListViewController: UIViewController {
    
    //MARK: - Properties
    
    let recipes: [RecipeData]
    let headlineText: String
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = ColorManager.shared.primaryColor
        return button
    }()
    
    let buttonBackgroundView = {
        let buttonBackgroundView = UIView()
        buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        buttonBackgroundView.backgroundColor = ColorManager.shared.backgroundColor
        return buttonBackgroundView
    }()
    
    private lazy var headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = headlineText.uppercased()
        return label
    }()
    
    private let recipeSearchBar = RecipeSearchBar(placeholder: "მოძებნე რეცეპტი...")
    
    private lazy var listComponent = RecipesListComponentView(recipes: recipes)
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, recipeSearchBar, listComponent])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFontObserver()
        addColorObserver()
        
        setupUI()
        setupNavigation()
        addDelegate()
        setupBackButton()
    }
    
    //MARK: - init

    init(recipes: [RecipeData], headlineText: String) {
        self.recipes = recipes
        self.headlineText = headlineText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        addConstraints()
    }
    
    //MARK: - Add Views
    
    private func addViews() {
        view.addSubview(mainStackView)
        view.addSubview(buttonBackgroundView)
        view.addSubview(backButton)
    }
    
    //MARK: - Accessibility
    
    @objc func updateFonts() {
        headlineLabel.font = FontManager.shared.headlineFont
    }

    @objc func updateColors() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        buttonBackgroundView.backgroundColor = ColorManager.shared.backgroundColor
    }

    private func addFontObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: .fontSettingsDidChange, object: nil)
        updateFonts()
    }

    private func addColorObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .colorSettingsDidChange, object: nil)
        updateColors()
    }
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            buttonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: buttonBackgroundView.bottomAnchor, constant: 15),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: - Navigation
    
    private func setupNavigation() {
        listComponent.didSelectRecipe = { [weak self] selectedRecipe in
            let detailsViewController = RecipeDetailsPageViewController()
            detailsViewController.selectedRecipe = selectedRecipe
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    //MARK: - Delegate
    
    private func addDelegate() {
        recipeSearchBar.delegate = self
    }
    
    //MARK: - Setup Back Button
    
    private func setupBackButton() {
        backButton.addAction((UIAction(handler: { [self] _ in
            navigationController?.popViewController(animated: true)
        })), for: .touchUpInside)
    }
}

//MARK: - Extensions

extension SeeListViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        if let query = query, !query.isEmpty {
            let filteredRecipes = recipes.filter { $0.name.contains(query) }
            listComponent.configure(recipes: filteredRecipes)
            headlineLabel.text = "ძიების შედეგები: ".uppercased()
        } else {
            listComponent.configure(recipes: recipes)
            headlineLabel.text = headlineText.uppercased()
        }
    }
}
