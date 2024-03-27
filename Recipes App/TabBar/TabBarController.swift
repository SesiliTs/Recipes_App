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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupOnboarding()
    }
    
    // MARK: - Setup Onboarding
    private func setupOnboarding() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if !hasCompletedOnboarding {
            presentOnboardingView()
        }
    }

    private func presentOnboardingView() {
        let onboardingView = OnboardingView(dismissTabView: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        })
        
        let hostingController = UIHostingController(rootView: onboardingView)
        hostingController.modalPresentationStyle = .fullScreen
        
        present(hostingController, animated: true, completion: nil)
    }
    
    //MARK: - Setup TabBar
    
    private func setupTabs() {
        let landing = createNavigation(image: UIImage.house, selectedImage: UIImage.houseFilled, viewController: LandingPageViewController())
        let save = createNavigation(image: UIImage.cook, selectedImage: UIImage.cookFilled, viewController: YourRecipesPageViewController())
        let favourites = createNavigation(image: UIImage.heart, selectedImage: UIImage.heartFilled, viewController: FavouriteRecipesPageViewController())
        let community = createNavigation(image: UIImage.chat, selectedImage: UIImage.chatFilled, viewController: CommunityViewController())
        
        let profileHostingController = UIHostingController(rootView: ProfilePage().environmentObject(AuthViewModel()))
        let profile = createNavigation(image: UIImage.person, selectedImage: UIImage.personFilled, viewController: profileHostingController)
        
        setViewControllers([landing, save, favourites, community, profile], animated: true)
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
