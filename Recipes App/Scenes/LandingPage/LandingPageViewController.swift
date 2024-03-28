//
//  ViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import UIKit
import FirebaseAuth

final class LandingPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = AuthViewModel()
    
    private var recipes = FireStoreManager.shared.allRecipes
    
    private let greetingLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFont
        label.textColor = ColorManager.shared.textGrayColor
        label.numberOfLines = 0
        return label
    }()
    
    private let whatAreYouCookingLabel = HeadlineTextComponentView(text: "დღეს რას მოამზადებ?")
    
    private lazy var labelStack = {
        let stackView = UIStackView(arrangedSubviews: [greetingLabel, whatAreYouCookingLabel])
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.alignment = .leading
        return stackView
    }()
    
    private let recipeSearchBar = RecipeSearchBar(placeholder: "მოძებნე რეცეპტი...")
    
    private lazy var listComponent = RecipesListComponentView(recipes: recipes)
    
    private let categoriesLabel = HeadlineTextComponentView(text: "კატეგორიები")
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 5
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let recommendationsLabel = HeadlineTextComponentView(text: "რეკომენდაციები")
    
    private let seeAllButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("სრულად >", for: .normal)
        button.setTitleColor(ColorManager.shared.primaryColor, for: .normal)
        button.titleLabel?.font = FontManager.shared.bodyFont
        return button
    }()
    
    private lazy var recommendationsHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews:[recommendationsLabel, seeAllButton])
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let recommendationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 5
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView(arrangedSubviews: [labelStack, recipeSearchBar, categoriesLabel,
                                                       categoriesCollectionView, recommendationsHorizontalStack,
                                                       recommendationsCollectionView, listComponent])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        return stackView
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFontObserver()
        addColorObserver()
        
        setupUI()
        updateGreetingText()
        observeAuthenticationState()
        
        seeAllAction()
        addDelegate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        navigationController?.isNavigationBarHidden = true
        
        addViews()
        setupCategories()
        setupRecommendations()
        addConstraints()
        listComponent.isHidden = true
    }
    
    //MARK: - Accessibility
    
    @objc func updateFonts() {
        greetingLabel.font = FontManager.shared.bodyFont
        seeAllButton.titleLabel?.font = FontManager.shared.bodyFont
    }
    
    private func addFontObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: .fontSettingsDidChange, object: nil)
        updateFonts()
    }
    
    @objc func updateColors() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        greetingLabel.textColor = ColorManager.shared.textGrayColor
    }

    private func addColorObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .colorSettingsDidChange, object: nil)
        updateColors()
    }
    
    //MARK: - Add Views
    
    
    private func addViews() {
        view.addSubview(mainStack)
        mainStack.setCustomSpacing(50, after: categoriesCollectionView)
    }
    
    //MARK: - Update Greeting Label
    
    private func observeAuthenticationState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            self?.updateGreetingText()
        }
    }

    private func updateGreetingText() {
        
        let greeting: String
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            greeting = "დილა მშვიდობისა"
        case 12..<16:
            greeting = "შუადღე მშვიდობისა"
        case 16..<20:
            greeting = "საღამო მშვიდობისა"
        default:
            greeting = "ღამე მშვიდობისა"
        }
        
        Task {
             await viewModel.fetchUser()
             DispatchQueue.main.async { [weak self] in
                 if self?.viewModel.userSession != nil {
                     let firstName = self?.viewModel.currentUser?.fullname.components(separatedBy: " ").first ?? ""
                     self?.greetingLabel.text = "\(greeting),\n\(firstName)"
                 } else {
                     self?.greetingLabel.text = "\(greeting)"
                 }
             }
         }
    }
    
    //MARK: - Categories Setup
    
    private func setupCategories() {
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.backgroundColor = .clear
        registerCategoriesCell()
    }
    
    private func registerCategoriesCell() {
        categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
    }
    
    //MARK: - Recommendations Setup
    
    private func setupRecommendations() {
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        recommendationsCollectionView.backgroundColor = .clear
        registerRecommendationsCell()
        setupNavigation()
        
        FireStoreManager.shared.fetchAllRecipes { recipes in
            let sortedRecipes = self.sortRecipesByTime(recipes)
            self.recipes = sortedRecipes
            DispatchQueue.main.async {
                self.recommendationsCollectionView.reloadData()
            }
        }
    }
    
    private func registerRecommendationsCell() {
        recommendationsCollectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "recommendCell")
    }
    
    private func sortRecipesByTime(_ recipes: [RecipeData]) -> [RecipeData] {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        let sortedRecipes = recipes.sorted { recipe1, recipe2 in
            switch hour {
            case 6..<12:
                return recipe1.category == .breakfast
            case 12..<16:
                return recipe1.category == .snack
            case 16..<20:
                return recipe1.category == .dinner
            default:
                return recipe1.category == .dessert
            }
        }
        
        return sortedRecipes
    }
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            recipeSearchBar.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 120),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 16),
            
            recommendationsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            recommendationsCollectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 16),
            
            listComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listComponent.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            listComponent.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Add Action
    
    private func seeAllAction() {
        seeAllButton.addAction((UIAction(handler: { [self] _ in
            let viewController = SeeListViewController(recipes: recipes, headlineText: "რეკომენდაციები")
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(viewController, animated: true)
        })), for: .touchUpInside)
    }
    
    //MARK: - Add Delegate
    
    private func addDelegate() {
        recipeSearchBar.delegate = self
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

extension LandingPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categoriesViews.count
        } else if collectionView == recommendationsCollectionView {
            return recipes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoriesCollectionViewCell
            let currentCategory = categoriesViews[indexPath.row]
            cell.configure(with: currentCategory.image, label: currentCategory.categoryName)
            return cell
        } else if collectionView == recommendationsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! RecommendedCollectionViewCell
            let currentRecipe = recipes[indexPath.row]
            cell.configure(with: currentRecipe.image, label: currentRecipe.name, time: currentRecipe.time)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendationsCollectionView {
            let currentRecipe = recipes[indexPath.row]
            let detailsViewController = RecipeDetailsPageViewController()
            detailsViewController.selectedRecipe = currentRecipe
            navigationController?.pushViewController(detailsViewController, animated: true)
        } else if collectionView == categoriesCollectionView {
            let selectedCategory = categoriesViews[indexPath.row].categoryName
            let filteredRecipes = recipes.filter { $0.category == categoryCases[selectedCategory] }
            let viewController = SeeListViewController(recipes: filteredRecipes, headlineText: selectedCategory)
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension LandingPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            return CGSize(width: 120, height: 120)
        } else if collectionView == recommendationsCollectionView {
            return CGSize(width: 120, height: 200)
        }
        return CGSize.zero
    }
}

//MARK: - Search Bar Delegate

extension LandingPageViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        if let query = query, !query.isEmpty {
            let filteredRecipes = recipes.filter { $0.name.contains(query) }
            listComponent.configure(recipes: filteredRecipes)
            toggleUIElements(isHidden: true)
            listComponent.isHidden = false
        } else {
            toggleUIElements(isHidden: false)
            listComponent.isHidden = true
        }
    }

    private func toggleUIElements(isHidden: Bool) {
        categoriesLabel.isHidden = isHidden
        categoriesCollectionView.isHidden = isHidden
        recommendationsHorizontalStack.isHidden = isHidden
        recommendationsCollectionView.isHidden = isHidden
    }
}
