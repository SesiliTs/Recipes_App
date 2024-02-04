//
//  LoginRequiredView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 01.02.24.
//

import UIKit
import SwiftUI

final class LoginRequiredView: UIView {
    
    //MARK: - Properties
    
    private let label = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFontMedium
        label.textColor = ColorManager.shared.textGrayColor
        label.text = "ამ გვერდის სანახავად გაიარე ავტორიზაცია"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let button = {
        let button = UIButton()
        button.setTitle("ავტორიზაცია".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontManager.shared.bodyFontMedium
        button.backgroundColor = ColorManager.shared.primaryColor
        button.layer.cornerRadius = 18
        return button
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private var navigationController: UINavigationController?
    
    //MARK: - init
    
    init(navigationController: UINavigationController?) {
        super.init(frame: .zero)
        self.navigationController = navigationController
        setupUI()
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        addSubview(mainStack)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 45),
            button.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
    }
    
    //MARK: - Add Action
    
    private func addAction() {
        button.addAction((UIAction(handler: { [self] _ in
            let profileHostingController = UIHostingController(rootView: ProfilePage().environmentObject(AuthViewModel()))
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(profileHostingController, animated: true)
        })), for: .touchUpInside)
    }
    
    
}
