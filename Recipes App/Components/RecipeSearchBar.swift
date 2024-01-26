//
//  RecipeSearchBar.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 24.01.24.
//

import UIKit

protocol RecipeSearchBarDelegate: AnyObject {
    func didChangeSearchQuery(_ query: String?)
}

final class RecipeSearchBar: UIView, UITextFieldDelegate {
    
    //MARK: - Properties
    
    weak var delegate: RecipeSearchBarDelegate?
    
    private let textField: UITextField = {
        let textField = PaddedSearchIcon()
        textField.placeholder = "მოძებნე რეცეპტი..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup UI
    
    private func setupUI() {
        addSubview(textField)
        
        addConstraints()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 18
        textField.font = FontManager.shared.bodyFont
        textField.layer.borderWidth = 0
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    //MARK: add Delegate
    
    private func addDelegate() {
        textField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        delegate?.didChangeSearchQuery(currentText)
        return true
    }
}

//MARK: - Search icon setup

final class PaddedSearchIcon: UITextField {

    private let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPadding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupPadding() {
        leftView = paddingView
        leftViewMode = .always

        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        leftView?.addSubview(spaceView)
        searchIconImageView.frame = CGRect(x: 14, y: 0, width: 17, height: 17)
        leftView?.addSubview(searchIconImageView)
        leftView?.frame = CGRect(x: 0, y: 0, width: 40, height: 20)

    }
}