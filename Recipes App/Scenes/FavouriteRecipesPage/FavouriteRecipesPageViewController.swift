//
//  FavouriteRecipesPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

final class FavouriteRecipesPageViewController: UIViewController {
    
    private let mainView = RecipesListComponentView(headline: "შენახული რეცეპტები", recipes: mockRecipes)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.shared.backgroundColor
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        mainView.didSelectRecipe = { [weak self] selectedRecipe in
            let detailsViewController = RecipeDetailsPageViewController()
            detailsViewController.selectedRecipe = selectedRecipe
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
            
        }
    }
    
}
