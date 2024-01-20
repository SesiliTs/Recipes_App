//
//  TabBarController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupTabUI()
    }
    
    //MARK: - Setup TabBar
    
    private func setupTabs() {
        let landing = createNavigation(image: .init(systemName: "house"), viewController: LandingPageViewController())
        let save = createNavigation(image: .init(systemName: "bookmark"), viewController: YourRecipesPageViewController())
        let favourites = createNavigation(image: .init(systemName: "heart"), viewController: FavouriteRecipesPageViewController())
        let profile = createNavigation(image: .init(systemName: "person"), viewController: ProfilePageViewController())
        
        setViewControllers([landing, save, favourites, profile], animated: true)
    }
    
    private func setupTabUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = ColorManager.shared.primaryColor
        self.tabBar.unselectedItemTintColor = ColorManager.shared.textLightGray
    }
    
    private func createNavigation(image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem.image = image
        
        return navigation
    }
    
}
