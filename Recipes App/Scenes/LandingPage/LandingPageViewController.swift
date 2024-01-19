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
        addConstraints()
    }
    
    //MARK: - Add Views
    
    private func addViews() {
        labelStack.addArrangedSubview(greetingLabel)
        labelStack.addArrangedSubview(whatAreYouCookingLabel)
        
        mainStack.addArrangedSubview(labelStack)
        mainStack.addArrangedSubview(categoriesLabel)
        mainStack.addArrangedSubview(recommendationsLabel)
        
        view.addSubview(mainStack)

    }
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 35)
        ])
    }

}

