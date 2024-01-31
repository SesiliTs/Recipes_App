//
//  SeeAllViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 31.01.24.
//

import UIKit

final class SeeAllViewController: UIViewController {
    
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
    
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = "რეკომენდაციები".uppercased()
        return label
    }()
    
    private let recipeSearchBar: RecipeSearchBar = {
        let searchBar = RecipeSearchBar()
        return searchBar
    }()
    
    private let listComponent = RecipesListComponentView(recipes: mockRecipes)
    
    
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
        setupUI()
        setupNavigation()
        addDelegate()
        setupBackButton()
    }
    
    private func setupUI() {
        
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        view.addSubview(mainStackView)
        view.addSubview(buttonBackgroundView)
        view.addSubview(backButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            
            buttonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
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

extension SeeAllViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        if let query = query, !query.isEmpty {
            let filteredRecipes = mockRecipes.filter { $0.name.lowercased().contains(query.lowercased()) }
            listComponent.configure(recipes: filteredRecipes)
            headlineLabel.text = "ძიების შედეგები: ".uppercased()
        } else {
            listComponent.configure(recipes: mockRecipes)
            headlineLabel.text = "შენახული რეცეპტები".uppercased()
        }
    }
}
