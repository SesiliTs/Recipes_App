//
//  TabBarController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupTabUI()
    }
    
    //MARK: - Setup TabBar
    
    private func setupTabs() {
        let landing = createNavigation(image: UIImage(named: "House"), selectedImage: UIImage(named: "HouseFilled"), viewController: LandingPageViewController())
        let save = createNavigation(image: UIImage(named: "Bookmark"), selectedImage: UIImage(named: "BookmarkFilled"), viewController: YourRecipesPageViewController())
        let favourites = createNavigation(image: UIImage(named: "Heart"), selectedImage: UIImage(named: "HeartFilled"), viewController: FavouriteRecipesPageViewController())
        
        let profileHostingController = UIHostingController(rootView: ProfilePage().environmentObject(AuthViewModel()))
        let profile = createNavigation(image: UIImage(named: "Person"), selectedImage: UIImage(named: "PersonFilled"), viewController: profileHostingController)

        setViewControllers([landing, save, favourites, profile], animated: true)
    }

    private func createNavigation(image: UIImage?, selectedImage: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        
        navigation.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        navigation.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        
        return navigation
    }

    
    private func setupTabUI() {
        tabBar.backgroundColor = .white
    }
    
    private func createNavigation(image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem.image = image
        
        return navigation
    }
    
}
