//
//  RecipeCollectionViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 10.02.24.
//

import UIKit

protocol RecipeCollectionViewCellDelegate: AnyObject {
    func didDeleteRecipe(cell: RecipeCollectionViewCell)
}

final class RecipeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel = YourRecipesViewModel()
    weak var delegate: RecipeCollectionViewCellDelegate?
    var recipe: RecipeData?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    private let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFontMedium
        return label
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
        label.font = FontManager.shared.bodyFont?.withSize(9)
        return label
    }()
    
    private lazy var timeHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [clockSymbol, timeLabel])
        stackView.spacing = 5
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
        label.font = FontManager.shared.bodyFont?.withSize(9)
        return label
    }()
    
    private lazy var difficultyHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [gearSymbol, difficultyLabel])
        stackView.spacing = 5
        return stackView
    }()
    
    private let peopleSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person.2")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let portionLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textLightGray
        label.font = FontManager.shared.bodyFont?.withSize(9)
        return label
    }()
    
    private lazy var portionHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [peopleSymbol, portionLabel])
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var labelsHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [difficultyHorizontalStack, portionHorizontalStack])
        return stackView
    }()
    
    private lazy var labelsVerticalStack = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, labelsHorizontalStack, timeHorizontalStack])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [recipeImage, labelsVerticalStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 15
        return stackView
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = ColorManager.shared.primaryColor
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare For Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        portionLabel.text = nil
        difficultyLabel.text = nil
        trashButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        addViews()
        addConstraints()
        trashButtonAction()
    }
    
    private func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        labelsVerticalStack.setCustomSpacing(15, after: nameLabel)
        contentView.addSubview(trashButton)    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            recipeImage.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            recipeImage.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            
            trashButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            trashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            labelsHorizontalStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
    }
    
    func trashButtonAction() {
        trashButton.addAction(UIAction { [self] _ in
            if let recipe = self.recipe {
                self.viewModel.deleteRecipe(recipeId: recipe.id)
                self.delegate?.didDeleteRecipe(cell: self)
            }
        }, for: .touchUpInside)
    }
    
    //MARK: - Configure
    
    
    func configure(recipe: RecipeData?) {
        recipeImage.load(urlString: recipe?.image ?? "")
        nameLabel.text = recipe?.name.uppercased()
        portionLabel.text = "\(recipe?.portion ?? 0)"
        
        let hours = (recipe?.time ?? 0) / 60
        let minutes = (recipe?.time ?? 0) % 60
        
        if hours > 0 {
            if minutes > 0 {
                timeLabel.text = "\(hours)სთ \(minutes)წთ"
            } else {
                timeLabel.text = "\(hours)სთ"
            }
        } else {
            timeLabel.text = "\(minutes)წთ"
        }
        
        if let difficulty = recipe?.difficulty {
            switch difficulty {
            case .easy:
                difficultyLabel.text = "მარტივი"
            case .normal:
                difficultyLabel.text = "საშუალო"
            case .hard:
                difficultyLabel.text = "რთული"
            }
        } else {
            difficultyLabel.text = "უცნობი"
        }
    }
    
}
