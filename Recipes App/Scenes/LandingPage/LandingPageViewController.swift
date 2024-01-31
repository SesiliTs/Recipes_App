//
//  ViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 19.01.24.
//

import UIKit

final class LandingPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let greetingLabel = {
        let label = BodyTextComponentView(text: "დილა მშვიდობისა,\nსესილი")
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
    
    private let recipeSearchBar = RecipeSearchBar()
    
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
                                                       recommendationsCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        return stackView
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.shared.backgroundColor
        
        addViews()
        setupCategories()
        setupRecommendations()
        addConstraints()
        seeAllAction()
        
    }
    
    //MARK: - Add Views
    
    private func addViews() {
        view.addSubview(mainStack)

        mainStack.setCustomSpacing(50, after: recipeSearchBar)
        mainStack.setCustomSpacing(50, after: categoriesCollectionView)
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
    }
    
    private func registerRecommendationsCell() {
        recommendationsCollectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "recommendCell")
    }
    
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            recipeSearchBar.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 120),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            recommendationsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            recommendationsCollectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            seeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])
    }
    
    //MARK: - Add Action
    
    private func seeAllAction() {
        seeAllButton.addAction((UIAction(handler: { [self] _ in
            let viewController = SeeListViewController(recipes: mockRecipes, headlineText: "რეკომენდაციები")
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(viewController, animated: true)
        })), for: .touchUpInside)
    }
    
}

//MARK: - Extensions

extension LandingPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categoriesViews.count
        } else if collectionView == recommendationsCollectionView {
            return mockRecipes.count
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
            let currentRecipe = mockRecipes[indexPath.row]
            cell.configure(with: currentRecipe.image, label: currentRecipe.name, time: currentRecipe.time)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendationsCollectionView {
            let currentRecipe = mockRecipes[indexPath.row]
            let detailsViewController = RecipeDetailsPageViewController()
            detailsViewController.selectedRecipe = currentRecipe
            navigationController?.pushViewController(detailsViewController, animated: true)
        } else if collectionView == categoriesCollectionView {
            let selectedCategory = categoriesViews[indexPath.row].categoryName
            let filteredRecipes = mockRecipes.filter { $0.category == categoryCases[selectedCategory] }
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

