//
//  CommunityViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.03.24.
//

import UIKit

final class CommunityViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = CommunityPageViewModel()
    private lazy var posts = [Post]()
    private let headline = HeadlineTextComponentView(text: "კითხვები")
    
    private let tableView = UITableView()
    
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
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPlusButton()
    }
    
    //MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        setupTableView()
        addConstraints()
    }
    
    private func addViews() {
        view.addSubview(mainStack)
        view.addSubview(plusButton)
    }
    
    private func fetchData() {
        viewModel.fetchPosts { posts in
            self.posts = posts.sorted(by: { $0.date > $1.date })
            self.tableView.reloadData()
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
    
    //MARK: - TableView Setup
    
    private func setupTableView() {
        registerCell()
        addDelegate()
        setupTableViewUI()
        fetchData()
    }
    
    private func registerCell() {
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: "PostCell")
    }
    
    private func setupTableViewUI() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func addDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
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

//MARK: - Extensions

extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? CommunityTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        let currentPost = posts[indexPath.row]
        cell.configure(post: currentPost)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentPost = posts[indexPath.row]
        let postDetailsViewController = PostDetailsViewController()
        postDetailsViewController.selectedPost = currentPost
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
}
