//
//  RecipeDetailsPageViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 21.01.24.
//

import UIKit
import FirebaseAuth

final class RecipeDetailsPageViewController: UIViewController {
    
    var selectedRecipe: RecipeData?
    var viewModel: RecipeDetailsViewModel?
    
    //MARK: - Properties
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollContainer = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = ColorManager.shared.primaryColor
        return button
    }()
    
    let buttonBackgroundView = {
        let buttonBackgroundView = UIView()
        buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        buttonBackgroundView.backgroundColor = ColorManager.shared.backgroundColor
        return buttonBackgroundView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let heartButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var labelButtonStack = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, heartButton])
        stackView.spacing = 15
        return stackView
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
        label.font = FontManager.shared.bodyFontMedium?.withSize(12)
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
        label.font = FontManager.shared.bodyFontMedium?.withSize(12)
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
        label.font = FontManager.shared.bodyFontMedium?.withSize(12)
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
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelButtonStack, imageView,
                                                       detailsMainStack, ingredientsLabel,
                                                       tableView, rulesLabel, recipeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 35
        return stackView
    }()
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        addViews()
        setupViews()
        addConstraints()
        
    }
    
    //MARK: - init viewModel
    
    private func initViewModel() {
        viewModel = RecipeDetailsViewModel(recipe: selectedRecipe ?? mockRecipes[0])
    }
    
    
    //MARK: - Add Views
    
    private func addViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addSubview(mainStackView)
        view.addSubview(buttonBackgroundView)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
        
    }
    
    //MARK: - Setup Views
    
    private func setupViews() {
        setupUI()
        setupTableView()
        setupBackButton()
        setupHeartButton()
        setUpScrollView()
        setCustomSpacing()
    }
    
    private func setCustomSpacing() {
        mainStackView.setCustomSpacing(20, after: labelButtonStack)
        mainStackView.setCustomSpacing(16, after: imageView)
        mainStackView.setCustomSpacing(20, after: ingredientsLabel)
        mainStackView.setCustomSpacing(20, after: rulesLabel)
    }
    
    
    //MARK: - Setup ScrollView
    
    private func setUpScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    //MARK: - Setup Back Button
    
    private func setupBackButton() {
        backButton.addAction((UIAction(handler: { [self] _ in
            navigationController?.popViewController(animated: true)
        })), for: .touchUpInside)
    }
    
    //MARK: - Setup Heart Button
    
    private func setupHeartButton() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let _ = user {
                self?.heartButton.setImage(self?.viewModel?.heartButtonImage, for: .normal)
                self?.heartButton.addAction((UIAction(handler: { [self] _ in
                    self?.viewModel?.handleHeartButtonClick()
                    self?.heartButton.setImage(self?.viewModel?.heartButtonImage, for: .normal)
                })), for: .touchUpInside)
            } else {
                self?.heartButton.isHidden = true
            }
        }
    }

    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 100),
            mainStackView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -80),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            buttonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10)
            
        ])
    }
    
    //MARK: - Setup TableView
    
    private func setupTableView() {
        setupTableViewUI()
        setupDelegate()
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: "IngredientCell")
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTableViewUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        let totalHeight = CGFloat(selectedRecipe?.ingredients.count ?? 0) * 30
        tableView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = ColorManager.shared.backgroundColor
        
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
        selectedRecipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell,
              let ingredient = selectedRecipe?.ingredients[indexPath.row] else { return UITableViewCell() }
        
        cell.configureTableViewCell(ingredient: ingredient)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
    
}

