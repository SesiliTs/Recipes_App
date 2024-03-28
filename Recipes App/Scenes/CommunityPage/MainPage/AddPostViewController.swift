//
//  AddPostViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.03.24.
//

import UIKit

final class AddPostViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = CommunityPageViewModel()
    var dismissAction: (() -> Void)
    
    private let headlineLabel = HeadlineTextComponentView(text: "დაამატე კითხვა")
    
    private let questionLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFontMedium
        label.text = "სათაური".uppercased()
        return label
    }()
    
    private let questionTextView = {
        let textView = UITextView()
        textView.font = FontManager.shared.bodyFontMedium
        textView.layer.cornerRadius = 18
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        textView.textContainer.maximumNumberOfLines = 5
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = ColorManager.shared.borderColor.cgColor
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let bodyLabel = {
        let label = UILabel()
        label.font = FontManager.shared.bodyFontMedium
        label.text = "აღწერა".uppercased()
        return label
    }()
    
    private let bodyTextView = {
        let textView = UITextView()
        textView.font = FontManager.shared.bodyFont
        textView.layer.cornerRadius = 18
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = ColorManager.shared.borderColor.cgColor
        return textView
    }()
    
    private let saveButton = {
        let button = UIButton()
        button.backgroundColor = ColorManager.shared.primaryColor
        button.setTitle("შენახვა".uppercased(), for: .normal)
        button.titleLabel?.font = FontManager.shared.bodyFontMedium
        button.titleLabel?.textColor = .white
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.cornerRadius = 18
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private lazy var mainStack = {
        let stackView = UIStackView (arrangedSubviews: [headlineLabel, questionLabel, questionTextView, bodyLabel, bodyTextView, saveButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSaveButton()
    }
    
    init(dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        view.addSubview(mainStack)
        mainStack.setCustomSpacing(30, after: headlineLabel)
        mainStack.setCustomSpacing(30, after: questionTextView)
        mainStack.setCustomSpacing(30, after: bodyTextView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
        ])
    }
    
    //MARK: - button action
    
    private func setupSaveButton() {
        saveButton.addAction((UIAction(handler: { [self] _ in
            saveButtonTapped()
        })), for: .touchUpInside)
        
        updateSaveButtonState()
        questionTextView.delegate = self
    }
    
    private func saveButtonTapped() {
        viewModel.addPost(question: questionTextView.text, body: bodyTextView.text) { error in
            if error != nil {
                print("error saving data")
            } else {
                self.dismissAction()
            }
        }
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = !questionTextView.text.isEmpty
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
    }
}

//MARK: - Extensions

extension AddPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
}
