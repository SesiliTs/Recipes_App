//
//  CommunityViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.03.24.
//

import UIKit
import FirebaseAuth

final class CommunityViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = CommunityPageViewModel()
    private lazy var posts = [Post]()
    private let headline = HeadlineTextComponentView(text: "კითხვები")
    
    private lazy var tableView = PostsComponentView(posts: posts)
    
    private lazy var mainStack = {
        let stackView = UIStackView(arrangedSubviews: [headline, tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()
    
    private let plusButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = ColorManager.shared.primaryColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    private lazy var loginRequiredView = LoginRequiredView(navigationController: self.navigationController)

    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPlusButton()
        checkLoggedUser()
    }
    
    //MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        addConstraints()
        setupNavigation()
    }
    
    private func addViews() {
        view.addSubview(mainStack)
        view.addSubview(plusButton)
        view.addSubview(loginRequiredView)
    }
    
    //MARK: - Check Login State
    
    private func checkLoggedUser() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let _ = user {
                self?.userIsLoggedIn()
            } else {
                self?.userIsLoggedOut()
            }
        }
    }
    
    private func userIsLoggedIn() {
        loginRequiredView.isHidden = true
        mainStack.isHidden = false
        plusButton.isHidden = false
        fetchData()
    }
    
    private func userIsLoggedOut() {
        loginRequiredView.isHidden = false
        mainStack.isHidden = true
        plusButton.isHidden = true
        
        loginRequiredView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginRequiredView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginRequiredView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginRequiredView.topAnchor.constraint(equalTo: view.topAnchor),
            loginRequiredView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Navigation
    
    private func setupNavigation() {
        tableView.didSelectPost = { [weak self] selectedPost in
            let detailsViewController = PostDetailsViewController()
            detailsViewController.selectedPost = selectedPost
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    private func fetchData() {
        viewModel.fetchPosts { posts in
            self.tableView.posts = posts.sorted(by: { $0.date > $1.date })
        }
    }
    
    //MARK: - button action
    
    private func setupPlusButton() {
        plusButton.addAction((UIAction(handler: { [self] _ in
            addButtonTapped()
        })), for: .touchUpInside)
    }
    
    private func addButtonTapped() {
        let viewController = AddPostViewController(dismissAction: {
            self.dismiss(animated: true)
            self.fetchData()
        })
        present(viewController, animated: true)
    }
    
    //MARK: - Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
        ])
    }
}

