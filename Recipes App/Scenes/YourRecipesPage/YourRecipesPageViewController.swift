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
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, recipeSearchBar, collectionView, listComponent])
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
    
    private lazy var listComponent = RecipesListComponentView(recipes: viewModel.userRecipes)
    
    private lazy var loginRequiredView = LoginRequiredView(navigationController: self.navigationController)
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedUser()
        listComponent.isHidden = true
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
        
        setupCollectionView()
        addConstraints()
        setupPlusButton()
        setupNavigation()
        
        addFontObserver()
        addColorObserver()
    }
    
    //MARK: - Accessibility
    
    @objc func updateFonts() {
        headlineLabel.font = FontManager.shared.headlineFont
    }

    @objc func updateColors() {
        view.backgroundColor = ColorManager.shared.backgroundColor
    }

    private func addFontObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: .fontSettingsDidChange, object: nil)
        updateFonts()
    }

    private func addColorObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .colorSettingsDidChange, object: nil)
        updateColors()
    }
    
    //MARK: - Setup Collection View
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
    }
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            plusButton.heightAnchor.constraint(equalToConstant: 50),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            listComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listComponent.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            listComponent.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
            
        ])
    }
    
    //MARK: - button action
    
    private func setupPlusButton() {
        plusButton.addAction((UIAction(handler: { [self] _ in
            addButtonTapped()
        })), for: .touchUpInside)
    }
    
    //MARK: - Fetch Recipes
    
    private func fetchRecipes() async {
        await viewModel.fetchUserRecipes()
        collectionView.reloadData()
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
    
    //MARK: - Navigation
    
    private func setupNavigation() {
        listComponent.didSelectRecipe = { [weak self] selectedRecipe in
            let detailsViewController = RecipeDetailsPageViewController()
            detailsViewController.selectedRecipe = selectedRecipe
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
}

//MARK: - Extensions

extension YourRecipesPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = viewModel.userRecipes[indexPath.item]
        cell.recipe = recipe
        cell.delegate = self
        cell.configure(recipe: recipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 15
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = (collectionViewWidth - spacing) / 2
        return CGSize(width: itemWidth, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentRecipe = viewModel.userRecipes[indexPath.row]
        let detailsViewController = RecipeDetailsPageViewController()
        detailsViewController.selectedRecipe = currentRecipe
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

//MARK: - Search Bar

extension YourRecipesPageViewController: RecipeCollectionViewCellDelegate {
    func didDeleteRecipe(cell: RecipeCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.userRecipes.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension YourRecipesPageViewController: RecipeSearchBarDelegate {
    
    func didChangeSearchQuery(_ query: String?) {
        if let query = query, !query.isEmpty {
            let filteredRecipes = viewModel.userRecipes.filter { $0.name.contains(query) }
            listComponent.configure(recipes: filteredRecipes)
            toggleUIElements(isHidden: true)
            listComponent.isHidden = false
        } else {
            toggleUIElements(isHidden: false)
            listComponent.isHidden = true
        }
    }

    private func toggleUIElements(isHidden: Bool) {
        collectionView.isHidden = isHidden
    }
}
