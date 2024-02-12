//
//  RecipesListTableViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.01.24.
//

import UIKit

final class RecipesListTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorManager.shared.borderColor.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
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
        label.font = FontManager.shared.bodyFont?.withSize(9)
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
        label.font = FontManager.shared.bodyFont?.withSize(9)
        return label
    }()
    
    private lazy var portionHorizontalStack = {
        let stackView = UIStackView(arrangedSubviews: [peopleSymbol, portionLabel])
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var labelsVerticalStack = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, timeHorizontalStack,
                                                       difficultyHorizontalStack, portionHorizontalStack])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [recipeImage, labelsVerticalStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        stackView.spacing = 35
        return stackView
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addColorObserver()
        addFontObserver()
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
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        labelsVerticalStack.setCustomSpacing(15, after: nameLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10),
            mainStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    //MARK: - Accessibility
    
    @objc func updateFonts() {
        nameLabel.font = FontManager.shared.bodyFontMedium
        timeLabel.font = FontManager.shared.bodyFont?.withSize(10)
        difficultyLabel.font = FontManager.shared.bodyFont?.withSize(10)
        portionLabel.font = FontManager.shared.bodyFont?.withSize(10)
    }

    @objc func updateColors() {
        containerView.layer.borderColor = ColorManager.shared.borderColor.cgColor
        timeLabel.textColor = ColorManager.shared.textLightGray
        portionLabel.textColor = ColorManager.shared.textLightGray
        difficultyLabel.textColor = ColorManager.shared.textLightGray
        clockSymbol.tintColor = ColorManager.shared.textLightGray
        gearSymbol.tintColor = ColorManager.shared.textLightGray
        peopleSymbol.tintColor = ColorManager.shared.textLightGray
    }

    private func addFontObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: .fontSettingsDidChange, object: nil)
        updateFonts()
    }

    private func addColorObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .colorSettingsDidChange, object: nil)
        updateColors()
    }
    
    //MARK: - Configure
    
    
    func configure(recipe: RecipeData?) {
        recipeImage.load(urlString: recipe?.image ?? "")
        nameLabel.text = recipe?.name.uppercased()
        portionLabel.text = "\(recipe?.portion ?? 0) პორცია"
        
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
                difficultyLabel.text = "სირთულე: მარტივი"
            case .normal:
                difficultyLabel.text = "სირთულე: საშუალო"
            case .hard:
                difficultyLabel.text = "სირთულე: რთული"
            }
        } else {
            difficultyLabel.text = "სირთულე: უცნობი"
        }
    }
    
}

