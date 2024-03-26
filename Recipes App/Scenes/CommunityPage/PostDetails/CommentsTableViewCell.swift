//
//  CommentsTableViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 24.03.24.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    //MARK: - Properties

    let profileImage = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
        label.textColor = ColorManager.shared.textLightGray
        return label

    }()
    
    private lazy var nameStack = {
        let stackView = UIStackView (arrangedSubviews: [userNameLabel, dateLabel])
        return stackView
    }()
    
    private lazy var imageStack = {
        let stackView = UIStackView (arrangedSubviews: [profileImage, nameStack])
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let commentLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontManager.shared.bodyFont
        return label
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView (arrangedSubviews: [imageStack, commentLabel])
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
        profileImage.image = nil
        dateLabel.text = nil
        commentLabel.text = nil
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(mainStack)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    //MARK: - Configure
    
    func configure(comment: Comment) {
        userNameLabel.text = comment.userName
        profileImage.load(urlString: comment.imageURL)
        
        if let date = DateFormatter.postDateFormatter().date(from: comment.date) {
            let currentDate = Date()
            if currentDate.timeIntervalSince(date) <= (24 * 60 * 60) {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                dateLabel.text = timeFormatter.string(from: date)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                dateLabel.text = dateFormatter.string(from: date)
            }
        }
        
        commentLabel.text = comment.comment
    }

}
