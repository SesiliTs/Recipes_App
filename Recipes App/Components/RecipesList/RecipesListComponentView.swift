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
    
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let tableView = UITableView()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 35
        return stackView
    }()
    
    private var recipesData: [RecipeData] = []
    
    //MARK: - init
    
    init(headline: String, recipes: [RecipeData]) {
        super.init(frame: .zero)
        setupUI()
        configure(headline: headline, recipes: recipes)
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
        addSubview(mainStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
    
    func configure(headline: String, recipes: [RecipeData]) {
        headlineLabel.text = headline.uppercased()
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
