//
//  YourRecipesPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class YourRecipesPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = AddRecipeViewModel()
    
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        label.text = "შენი რეცეპტები".uppercased()
        return label
    }()
    
    private let recipeSearchBar = RecipeSearchBar()
    
    private lazy var listComponent = RecipesListComponentView(recipes: viewModel.userRecipes)
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, recipeSearchBar, listComponent])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
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
        plusButton.isHidden = false
        setupUI()
        setupNavigation()
        addDelegate()
        Task {
            await fetchRecipes()
        }
    }
    
    private func userIsLoggedOut() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        view.addSubview(loginRequiredView)

        mainStackView.isHidden = true
        plusButton.isHidden = true
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
        view.addSubview(plusButton)
        addConstraints()
        setupPlusButton()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            plusButton.heightAnchor.constraint(equalToConstant: 50),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            
        ])
    }
    
    private func setupPlusButton() {
        plusButton.addAction((UIAction(handler: { [self] _ in
            addButtonTapped()
        })), for: .touchUpInside)
    }
    
    private func fetchRecipes() async {
        await viewModel.fetchUserRecipes()
        listComponent.configure(recipes: viewModel.userRecipes)
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
                Task {
                    await self.fetchRecipes()
                    self.dismiss(animated: true)
                }
            })
        )
        present(viewController, animated: true)
    }
    
}

//MARK: - Extensions

extension YourRecipesPageViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        if let query = query, !query.isEmpty {
            let filteredRecipes = viewModel.userRecipes.filter { $0.name.lowercased().contains(query.lowercased()) }
            listComponent.configure(recipes: filteredRecipes)
            headlineLabel.text = "ძიების შედეგები: ".uppercased()
        } else {
            listComponent.configure(recipes: viewModel.userRecipes)
            headlineLabel.text = "შენი რეცეპტები".uppercased()
        }
    }
}
