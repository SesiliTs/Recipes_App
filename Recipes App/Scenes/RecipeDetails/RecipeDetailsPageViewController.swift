//
//  RecipeDetailsPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 21.01.24.
//

import UIKit

final class RecipeDetailsPageViewController: UIViewController {
    
    var selectedRecipe: RecipeData?
    
    //MARK: - Properties
    
    private let nameLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let clockSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "alarm")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let timeLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textLightGray
        label.font = FontManager.shared.bodyFontMedium
        return label
    }()
    
    private lazy var timeHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [clockSymbol, timeLabel])
        stackView.spacing = 15
        return stackView
    }()
    
    private let gearSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "gearshape")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let difficultyLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textLightGray
        label.font = FontManager.shared.bodyFontMedium
        return label
    }()
    
    private lazy var difficultyHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [gearSymbol, difficultyLabel])
        stackView.spacing = 15
        return stackView
    }()
    
    private let peopleSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person.2")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let portionLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textLightGray
        label.font = FontManager.shared.bodyFontMedium
        return label
    }()
    
    private lazy var portionHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [peopleSymbol, portionLabel])
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var detailsHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [difficultyHorizontalStack, portionHorizontalStack])
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var detailsMainStack = {
        let stackView = UIStackView(arrangedSubviews: [timeHorizontalStack, detailsHorizontalStack])
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let ingredientsLabel = {
        let label = UILabel()
        label.text = "ინგრედიენტები".uppercased()
        label.font = FontManager.shared.bodyFontMedium?.withSize(18)
        return label
    }()
    
    private let tableView = UITableView()
    
    private let rulesLabel = {
        let label = UILabel()
        label.text = "მომზადების წესი".uppercased()
        label.font = FontManager.shared.bodyFontMedium?.withSize(18)
        return label
    }()
    
    private let recipeLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textGrayColor
        label.font = FontManager.shared.bodyFont?.withSize(14)
        label.numberOfLines = 0
        return label
    }()
    
    private let mainStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.shared.backgroundColor

        addViews()
        setupUI()
        setupTableView()
        addConstraints()

    }
    

    //MARK: - Add Views
    
    private func addViews() {
        
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(detailsMainStack)
        mainStackView.addArrangedSubview(ingredientsLabel)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(rulesLabel)
        mainStackView.addArrangedSubview(recipeLabel)
        
    }
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
        ])
    }
    
    //MARK: - Setup TableView
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        let totalHeight = CGFloat(selectedRecipe?.ingredients.count ?? 0) * 40
        tableView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: "IngredientCell")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        nameLabel.text = selectedRecipe?.name.uppercased()
        imageView.load(urlString: selectedRecipe?.image ?? "")
        timeLabel.text = "მომზადების დრო: \(selectedRecipe?.time ?? 0) წთ"
        portionLabel.text = "პორცია: \(selectedRecipe?.portion ?? 0)"
        
        if let difficulty = selectedRecipe?.difficulty {
            switch difficulty {
            case .easy:
                difficultyLabel.text = "სირთულე: მარტივი"
            case .normal:
                difficultyLabel.text = "სირთულე: საშუალო"
            case .hard:
                difficultyLabel.text = "სირთულე: რთული"
            }
        } else {
            difficultyLabel.text = "სირთულე: უცნობი"
        }
        
        recipeLabel.text = selectedRecipe?.recipe
        
    }
}

//MARK: - Extensions

extension RecipeDetailsPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedRecipe?.ingredients.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell,
              let ingredient = selectedRecipe?.ingredients[indexPath.row] else { return UITableViewCell() }
        
        cell.configureTableViewCell(ingredient: ingredient)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
}

