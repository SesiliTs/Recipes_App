//
//  RecommendedCollectionViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

final class RecommendedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let shapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 145).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorManager.shared.borderColor.cgColor
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
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
        addFontObserver()
        addColorObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Prepare For Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
    }
    
    //MARK: - Private Functions
    
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
            horizontalStack.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 11),
            
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: topAnchor)
            
        ])
    }
    
    //MARK: - Accessibility
    
    @objc func updateFonts() {
        nameLabel.font = FontManager.shared.bodyFont
        timeLabel.font = FontManager.shared.bodyFont?.withSize(10)
    }

    @objc func updateColors() {
        shapeView.layer.borderColor = ColorManager.shared.borderColor.cgColor
        nameLabel.textColor = ColorManager.shared.textGrayColor
        timeLabel.textColor = ColorManager.shared.textGrayColor
        clockSymbol.tintColor = ColorManager.shared.textGrayColor
        arrowSymbol.tintColor = ColorManager.shared.textGrayColor
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
    
    func configure(with image: String, label: String, time: Int) {
        imageView.load(urlString: image)
        nameLabel.text = label
        
        let hours = time / 60
        let minutes = time % 60
        
        if hours > 0 {
            if minutes > 0 {
                timeLabel.text = "\(hours)სთ \(minutes)წთ"
            } else {
                timeLabel.text = "\(hours)სთ"
            }
        } else {
            timeLabel.text = "\(minutes)წთ"
        }
    }
}

