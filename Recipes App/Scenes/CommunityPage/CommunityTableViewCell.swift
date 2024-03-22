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
    
    let circleContainer = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 20
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.layer.masksToBounds = true
        return view
    }()

    let contentImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLabel = {
        let label = UILabel()
        label.text = "სესილი წიქარიძე"
        label.font = FontManager.shared.bodyFont
        label.textColor = ColorManager.shared.textGrayColor
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        label.text = dateFormatter.string(from: Date())
        label.font = FontManager.shared.bodyFont
        label.textColor = ColorManager.shared.textGrayColor
        return label

    }()
    
    private lazy var nameStack = {
        let stackView = UIStackView (arrangedSubviews: [userNameLabel, dateLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var imageStack = {
        circleContainer.addSubview(contentImageView)
        let stackView = UIStackView (arrangedSubviews: [circleContainer, nameStack])
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let commentsIcon = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "bubble.right")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let commentsLabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = ColorManager.shared.textLightGray
        label.font = FontManager.shared.bodyFont
        return label
    }()
    
    private lazy var commentsStack = {
        let stackView = UIStackView (arrangedSubviews: [commentsIcon, commentsLabel])
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var detailsStack = {
        let stackView = UIStackView (arrangedSubviews: [imageStack, commentsStack])
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let questionLabel = {
        let label = UILabel()
        label.text = "რა შეიძლება გამოვიყენოთ გამაფხვიერებლის ნაცვლად? რა შეიძლება გამოვიყენოთ გამაფხვიერებლის ნაცვლად?".uppercased()
        label.numberOfLines = 3
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView (arrangedSubviews: [detailsStack, questionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
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
