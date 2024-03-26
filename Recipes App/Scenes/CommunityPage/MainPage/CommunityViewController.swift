//
//  CommunityViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.03.24.
//

import UIKit

final class CommunityViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        setupTableView()
        addConstraints()
    }
    
    private func addViews() {
        view.addSubview(mainStack)
    }
    
    private func setupTableView() {
        registerCell()
        addDelegate()
        setupTableViewUI()
        fetchData()
    }
    
    private func fetchData() {
        viewModel.fetchPosts { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
}

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
