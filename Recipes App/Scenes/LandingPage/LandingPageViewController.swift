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
        let label = UILabel()
        label.text = "დილა მშვიდობისა,\nსესილი"
        label.font = FontManager.shared.bodyFont
        label.numberOfLines = 0
        label.textColor = ColorManager.shared.textGrayColor
        return label
    }()
    
    private let whatAreYouCookingLabel = {
        let label = UILabel()
        label.text = "დღეს რას მოამზადებ?" .uppercased()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let labelStack = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.alignment = .leading
        return stackView
    }()
    
    private let categoriesLabel = {
        let label = UILabel()
        label.text = "კატეგორიები" .uppercased()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 5
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let recommendationsLabel = {
        let label = UILabel()
        label.text = "რეკომენდაციები" .uppercased()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let recommendationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 5
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let mainStack = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 58
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
        
    }
    
    //MARK: - Add Views
    
    private func addViews() {
        labelStack.addArrangedSubview(greetingLabel)
        labelStack.addArrangedSubview(whatAreYouCookingLabel)
        
        mainStack.addArrangedSubview(labelStack)
        mainStack.addArrangedSubview(categoriesLabel)
        mainStack.setCustomSpacing(30, after: categoriesLabel)
        mainStack.addArrangedSubview(categoriesCollectionView)
        mainStack.addArrangedSubview(recommendationsLabel)
        mainStack.setCustomSpacing(30, after: recommendationsLabel)
        mainStack.addArrangedSubview(recommendationsCollectionView)
        
        view.addSubview(mainStack)
        
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
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 120),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            recommendationsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            recommendationsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
        ])
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

