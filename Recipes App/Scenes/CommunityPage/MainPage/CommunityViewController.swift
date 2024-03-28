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
    private let searchBar = RecipeSearchBar(placeholder: "მოძებნე კითხვა...")
    private lazy var tableView = PostsComponentView(posts: posts)
    
    private let dotsButton = {
        let button = UIButton()
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = ColorManager.shared.primaryColor
        return button
    }()
    
    private lazy var headlineStack = {
        let stackView = UIStackView(arrangedSubviews: [headline, dotsButton])
        return stackView
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView(arrangedSubviews: [headlineStack, searchBar, tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
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
        addDelegate()
        setupDotsButton()
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
    
    //MARK: - dots button action
    
    private func setupDotsButton() {
        dotsButton.addAction(UIAction(handler: { [self] _ in
            showDropdownMenu()
        }), for: .touchUpInside)
    }
    
    private func showDropdownMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "ყველა", style: .default) { [weak self] _ in
            self?.fetchData()
        }
        alertController.addAction(allAction)
        
        let myPostsAction = UIAlertAction(title: "ჩემი კითხვები", style: .default) { [weak self] _ in
            self?.fetchMyPosts()
        }
        alertController.addAction(myPostsAction)
        
        let cancelAction = UIAlertAction(title: "გაუქმება", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func fetchMyPosts() {
        viewModel.fetchPosts { [weak self] posts in
            guard Auth.auth().currentUser != nil else { return }
            let currentUserID = Auth.auth().currentUser?.uid
            let myPosts = posts.filter { $0.userID == currentUserID }
            let sortedPosts = myPosts.sorted(by: { $0.date > $1.date })
            self?.tableView.posts = sortedPosts
        }
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
    
    //MARK: - Delegate
    
    private func addDelegate() {
        searchBar.delegate = self
    }
}


//MARK: - Extensions

extension CommunityViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        if let query = query, !query.isEmpty {
            viewModel.fetchPosts { [weak self] posts in
                let filteredPosts = posts.filter { $0.question.contains(query) }
                self?.tableView.posts = filteredPosts
            }
        } else {
            fetchData()
        }
    }
}
