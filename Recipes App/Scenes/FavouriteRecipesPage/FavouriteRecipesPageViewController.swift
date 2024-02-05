//
//  FavouriteRecipesPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import Firebase

final class FavouriteRecipesPageViewController: UIViewController {
    
    private let viewModel = FavouriteRecipesViewModel()
    
    var currentUser = Auth.auth().currentUser
    
    //MARK: - Properties
    
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = "შენახული რეცეპტები".uppercased()
        return label
    }()
    
    private let recipeSearchBar = RecipeSearchBar()
    
    private lazy var listComponent = RecipesListComponentView(recipes: viewModel.recipes)
    
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
        loadLikedRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningLikedRecipesChanges()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopListeningLikedRecipesChanges()
    }

    //MARK: - Listen to changes in liked recipes
    
    private func startListeningLikedRecipesChanges() {
        viewModel.startListeningLikedRecipesChanges { [weak self] recipes in
            if let recipes = recipes {
                self?.listComponent.configure(recipes: recipes)
            }
        }
    }

    private func stopListeningLikedRecipesChanges() {
        viewModel.stopListeningLikedRecipesChanges()
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
    
    private func loadLikedRecipes() {
        viewModel.fetchLikedRecipes { [weak self] recipes in
            if let recipes = recipes {
                self?.listComponent.configure(recipes: recipes)
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
            loginRequiredView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginRequiredView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
    
    private func reloadLikedRecipes() {
        viewModel.fetchLikedRecipes { [weak self] recipes in
            if let recipes = recipes {
                self?.listComponent.configure(recipes: recipes)
            }
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
            viewModel.fetchLikedRecipes { [weak self] recipes in
                let filteredRecipes = recipes?.filter { $0.name.contains(query) } ?? []
                self?.listComponent.configure(recipes: filteredRecipes)
                self?.headlineLabel.text = "ძიების შედეგები: ".uppercased()
            }
        } else {
            reloadLikedRecipes()
        }
    }
}
