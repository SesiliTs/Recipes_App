//
//  FavouriteRecipesPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import Firebase

final class FavouriteRecipesPageViewController: UIViewController {
    
    var currentUser = Auth.auth().currentUser
    
    //MARK: - Properties
    
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = "შენახული რეცეპტები".uppercased()
        return label
    }()
    
    private let recipeSearchBar = RecipeSearchBar()
    
    private let listComponent = RecipesListComponentView(recipes: mockRecipes)
    
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, recipeSearchBar, listComponent])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var loginRequiredView = LoginRequiredView(navigationController: self.navigationController)
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedUser()
    }
    
    //MARK: - Change view according to user's login state
    
    private func checkLoggedUser() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let _ = user {
                self?.userIsLoggedIn()
            } else {
                self?.userIsLoggedOut()
            }
        }
    }
    
    private func userIsLoggedIn() {
        loginRequiredView.isHidden = true
        mainStackView.isHidden = false
        setupUI()
        setupNavigation()
        addDelegate()
    }
    
    private func userIsLoggedOut() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        view.addSubview(loginRequiredView)

        mainStackView.isHidden = true
        loginRequiredView.isHidden = false
        
        loginRequiredView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginRequiredView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            loginRequiredView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            loginRequiredView.topAnchor.constraint(equalTo: view.topAnchor),
            loginRequiredView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
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
