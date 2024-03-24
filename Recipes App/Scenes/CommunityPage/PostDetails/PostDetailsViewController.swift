//
//  PostDetailsViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 24.03.24.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    var selectedPost: Post?

    //MARK: Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()

    let profileImage = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFont
        label.textColor = ColorManager.shared.textGrayColor
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
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
        let stackView = UIStackView (arrangedSubviews: [profileImage, nameStack])
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
        label.numberOfLines = 0
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    private let bodyLabel = {
        let label = UILabel()
        label.numberOfLines = 9
        label.font = FontManager.shared.bodyFont
        return label
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView (arrangedSubviews: [detailsStack, questionLabel, bodyLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        addConstraints()
        configure()
    }
    
    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(mainStack)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
    
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
    }
        
    func configure() {
        guard let selectedPost else { return }
        userNameLabel.text = selectedPost.userName
        profileImage.load(urlString: selectedPost.imageURL)
        dateLabel.text = selectedPost.date
        commentsLabel.text = "\(selectedPost.commentsQuantity)"
        questionLabel.text = selectedPost.question.uppercased()
        bodyLabel.text = selectedPost.body
    }

}
