//
//  RecipesListComponentView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.01.24.
//

import UIKit

final class RecipesListComponentView: UIView {
    
    var didSelectRecipe: ((RecipeData) -> Void)?
    
    //MARK: - Properties
    
    private let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private var recipesData: [RecipeData] = []
    
    //MARK: - init
    
    init(recipes: [RecipeData]) {
        super.init(frame: .zero)
        setupUI()
        configure(recipes: recipes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        addViews()
        setupTableView()
        addConstraints()
    }
    
    //MARK: - AddViews
    
    private func addViews() {
        addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: - Setup TableView
    
    private func setupTableView() {
        setupDelegate()
        registerCell()
        setupTableViewUI()
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCell() {
        tableView.register(RecipesListTableViewCell.self, forCellReuseIdentifier: "RecipesListCell")
    }
    
    private func setupTableViewUI() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }
    
    //MARK: - Configuration
    
    func configure(recipes: [RecipeData]) {
        recipesData = recipes
        tableView.reloadData()
    }
    
}

//MARK: - Extensions

extension RecipesListComponentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesListCell", for: indexPath) as? RecipesListTableViewCell else { return UITableViewCell()}
        let currentRecipe = recipesData[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(recipe: currentRecipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        137
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRecipe = recipesData[indexPath.row]
        didSelectRecipe?(currentRecipe)
    }
}
