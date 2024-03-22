//
//  CommunityTableViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.03.24.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    private let userNameLabel = {
        let label = UILabel()
        label.text = "სესილი წიქარიძე"
        label.font = FontManager.shared.bodyFont
        label.textColor = ColorManager.shared.textGrayColor
        return label
    }()
    
    private let questionLabel = {
        let label = UILabel()
        label.text = "რა შეიძლება გამოვიყენოთ გამაფხვიერებლის ნაცვლად? რა შეიძლება გამოვიყენოთ გამაფხვიერებლის ნაცვლად?".uppercased()
        label.numberOfLines = 3
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView (arrangedSubviews: [questionLabel, userNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()

    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare For Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 130),
            
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Configure
    
    
    func configure(userName: String) {
        userNameLabel.text = userName.uppercased()
    }

}
