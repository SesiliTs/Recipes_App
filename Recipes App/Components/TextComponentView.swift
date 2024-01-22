//
//  HeadlineTextComponentView.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 22.01.24.
//

import UIKit

final class HeadlineTextComponentView: UILabel {
    
    //MARK: - Properties
    
    private let headlineLabel = {
        let label = UILabel()
        label.font = FontManager.shared.headlineFont
        return label
    }()
    
    //MARK: - init
    
    init(text: String) {
        super.init(frame: .zero)
        setupLabel(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(text: String) {
        addSubview(headlineLabel)
        headlineLabel.text = text.uppercased()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headlineLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

final class BodyTextComponentView: UILabel {
    
    //MARK: - Properties
    
    private let bodyLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFont
        label.textColor = ColorManager.shared.textGrayColor
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - init
    
    init(text: String) {
        super.init(frame: .zero)
        setupLabel(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(text: String) {
        addSubview(bodyLabel)
        bodyLabel.text = text
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: topAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

