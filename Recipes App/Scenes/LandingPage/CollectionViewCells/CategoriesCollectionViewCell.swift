//
//  CategoriesCollectionViewCell.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    
    private let shapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()

    private let imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.textGrayColor
        label.textAlignment = .left
        label.font = FontManager.shared.bodyFont
        return label
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
        addSubview(shapeView)
        shapeView.addSubview(label)
        shapeView.addSubview(imageView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: shapeView.topAnchor, constant: 55),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            label.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: shapeView.topAnchor, constant: 16)
        ])
    }
    
    func configure(with image: UIImage?, label: String) {
        imageView.image = image
        self.label.text = label
    }
    
}
