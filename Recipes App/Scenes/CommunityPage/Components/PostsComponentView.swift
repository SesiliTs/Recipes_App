//
//  PostsComponentView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.03.24.
//

import UIKit

class PostsComponentView: UIView {
    
    var didSelectPost: ((Post) -> Void)?

    private let tableView = UITableView()
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(posts: [Post]) {
        super.init(frame: .zero)
        setupTableView()
        configure(posts: posts)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        addSubview(tableView)
        addConstraints()
        registerCell()
        addDelegates()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func registerCell() {
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: "PostCell")
    }
    
    private func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Configuration
    
    func configure(posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
}


extension PostsComponentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? CommunityTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let currentPost = posts[indexPath.row]
        cell.configure(post: currentPost)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentPost = posts[indexPath.row]
        didSelectPost?(currentPost)
    }
}
