//
//  YourRecipesPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import SwiftUI

final class YourRecipesPageViewController: UIViewController {

    //MARK: - Properties
        
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = "შენი რეცეპტები".uppercased()
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
        stackView.spacing = 35
        return stackView
    }()
    
    private let plusButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = ColorManager.shared.primaryColor
        button.layer.cornerRadius = 25
        return button
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
        view.addSubview(plusButton)
        addConstraints()
        setupPlusButton()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            plusButton.heightAnchor.constraint(equalToConstant: 50),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)

        ])
    }
    
    private func setupPlusButton() {
        plusButton.addAction((UIAction(handler: { [self] _ in
            addButtonTapped()
        })), for: .touchUpInside)
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
    
    private func addButtonTapped() {
        let viewController = UIHostingController(
            rootView: AddRecipeView(dismissAction: {
                self.dismiss(animated: true)
            })
        )
        present(viewController, animated: true)
    }
    
}

//MARK: - Extensions

extension YourRecipesPageViewController: RecipeSearchBarDelegate {
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
