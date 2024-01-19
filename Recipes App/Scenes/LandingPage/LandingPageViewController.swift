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
    
    private let categoriesViews = [
        Category(image: "🥞".image(), categoryName: "საუზმე"),
        Category(image: "🍜".image(), categoryName: "სადილი"),
        Category(image: "🍰".image(), categoryName: "დესერტი"),
        Category(image: "🍿".image(), categoryName: "ხემსი"),
        Category(image: "🍹".image(), categoryName: "სასმელი")
    ]
    
    var categoriesCollectionView: UICollectionView = {
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
        addConstraints()

    }
    
    //MARK: - Add Views
    
    private func addViews() {
        labelStack.addArrangedSubview(greetingLabel)
        labelStack.addArrangedSubview(whatAreYouCookingLabel)
                
        mainStack.addArrangedSubview(labelStack)
        mainStack.addArrangedSubview(categoriesLabel)
        mainStack.addArrangedSubview(categoriesCollectionView)
        mainStack.addArrangedSubview(recommendationsLabel)
        
        view.addSubview(mainStack)

    }
    
    //MARK: - Categories Setup
    
    private func setupCategories() {
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.backgroundColor = .clear
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 120),
            categoriesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),

            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 35),
        ])
    }

}

//MARK: - Extensions

extension LandingPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
        let currentCategory = categoriesViews[indexPath.row]
        cell.configure(with: currentCategory.image, label: currentCategory.categoryName)
        return cell
    }
    
}

extension LandingPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 120)
    }
}

