//
//  FavouriteRecipesPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

final class FavouriteRecipesPageViewController: UIViewController {
    
    //MARK: - Properties
        
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = "შენახული რეცეპტები".uppercased()
        return label
    }()
    
    private let recipeSearchBar: RecipeSearchBar = {
        let searchBar = RecipeSearchBar()
        return searchBar
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, recipeSearchBar, listComponent])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 35
        return stackView
    }()
    
    private let listComponent = {
        let list = RecipesListComponentView(recipes: mockRecipes)
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        addDelegate()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        view.backgroundColor = ColorManager.shared.backgroundColor
        view.addSubview(mainStackView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
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
    
}

//MARK: - Extensions

extension FavouriteRecipesPageViewController: RecipeSearchBarDelegate {
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
