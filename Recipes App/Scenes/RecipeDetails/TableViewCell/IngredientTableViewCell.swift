//
//  IngredientTableViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 21.01.24.
//

import UIKit

final class IngredientTableViewCell: UITableViewCell {
    
    //MARK: - Properties
        
    private let checkboxButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = ColorManager.shared.textGrayColor
        return button
    }()
    
    private let ingredientLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFont?.withSize(14)
        label.textColor = ColorManager.shared.textGrayColor
        return label
    }()
    
    private let horizontalStack = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()
    
    var isCompleted: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    //MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - functions

    private func addViews() {
                
        contentView.addSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(checkboxButton)
        horizontalStack.addArrangedSubview(ingredientLabel)

    }
    
    private func setupActions() {
        
        checkboxButton.addAction((UIAction(handler: { [self] _ in
            isCompleted.toggle()
        })), for: .touchUpInside)
    }
    
    private func updateUI() {
        let imageName = isCompleted ? "checkmark.square" : "square"
        checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        let attributedString: NSAttributedString
        if isCompleted {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: ColorManager.shared.textGrayColor
            ]
            attributedString = NSAttributedString(string: ingredientLabel.text ?? "", attributes: attributes)
        } else {
            attributedString = NSAttributedString(string: ingredientLabel.text ?? "")
        }
        ingredientLabel.attributedText = attributedString
    }
    
    func configureTableViewCell(ingredient: String) {
        ingredientLabel.text = ingredient
    }
}
