//
//  RecommendedCollectionViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

final class RecommendedCollectionViewCell: UICollectionViewCell {
    
    private let shapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 145).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textGrayColor
        label.font = FontManager.shared.bodyFont
        return label
    }()
    
    private let clockSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "alarm")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 11).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let timeLabel = {
        let label = UILabel()
        label.textColor = ColorManager.shared.textLightGray
        label.font = FontManager.shared.bodyFont?.withSize(9)
        return label
    }()
    
    private let arrowSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "chevron.forward")
        imageView.tintColor = ColorManager.shared.textLightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 7).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 11).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let horizontalStack = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private let mainStack = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        addSubview(mainStack)
        
        horizontalStack.addArrangedSubview(clockSymbol)
        horizontalStack.addArrangedSubview(timeLabel)
        horizontalStack.addArrangedSubview(arrowSymbol)
        
        shapeView.addSubview(imageView)
        shapeView.addSubview(horizontalStack)
        
        mainStack.addArrangedSubview(shapeView)
        mainStack.addArrangedSubview(nameLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: shapeView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            
            arrowSymbol.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -10),
            
            horizontalStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            horizontalStack.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 11)
            
        ])
    }
    
    func configure(with image: String, label: String, time: Int) {
        imageView.load(urlString: image)
        nameLabel.text = label
        timeLabel.text = "\(time) წთ."
    }
    
}

