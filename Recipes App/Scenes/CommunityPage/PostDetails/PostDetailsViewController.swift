//
//  PostDetailsViewController.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 24.03.24.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    private let viewModel = CommunityPageViewModel()
    private var comments = [Comment]()
    var selectedPost: Post?

    //MARK: Properties
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = ColorManager.shared.primaryColor
        return button
    }()
    
    let buttonBackgroundView = {
        let buttonBackgroundView = UIView()
        buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        buttonBackgroundView.backgroundColor = ColorManager.shared.backgroundColor
        return buttonBackgroundView
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
    
    private lazy var postStack = {
        let stackView = UIStackView (arrangedSubviews: [detailsStack, questionLabel, bodyLabel])
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let addCommentField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        textField.placeholder = "დაწერე კომენტარი..."
        textField.font = FontManager.shared.bodyFont
        textField.layer.cornerRadius = 18
        textField.autocapitalizationType = .none
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var commentStack = {
        let stackView = UIStackView (arrangedSubviews: [addCommentField])
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let tableView = UITableView()
    
    private lazy var mainStack = {
        let stackView = UIStackView (arrangedSubviews: [postStack, commentStack, tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()

    
    //MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        navigationController?.isNavigationBarHidden = true
        addViews()
        addConstraints()
        setupTableView()
        setupBackButton()
        configure()
    }
    
    private func addViews() {
        view.addSubview(mainStack)
        view.addSubview(buttonBackgroundView)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            buttonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10)

        ])
    }
    
    //MARK: Setup TableView
    
    private func setupTableView() {
        registerCell()
        addDelegate()
        setupTableViewUI()
    }
    
    private func registerCell() {
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func setupTableViewUI() {
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 18
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func addDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Setup Back Button
    
    private func setupBackButton() {
        backButton.addAction((UIAction(handler: { [self] _ in
            navigationController?.popViewController(animated: true)
        })), for: .touchUpInside)
    }
    
    //MARK: - Fetch Comments
    
    private func fetchData() {
        guard let selectedPost else { return }
        viewModel.fetchComments(for: selectedPost.id) { comments in
            self.comments = comments
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
     
    //MARK: - Configure
    
    func configure() {
        guard let selectedPost else { return }
        userNameLabel.text = selectedPost.userName
        profileImage.load(urlString: selectedPost.imageURL)
        dateLabel.text = selectedPost.date
//        commentsLabel.text = "\(selectedPost.comments.count)"
        questionLabel.text = selectedPost.question.uppercased()
        bodyLabel.text = selectedPost.body
    }

}

extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentsTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        let currentComment = comments[indexPath.row]
        cell.configure(comment: currentComment)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

}
