//
//  PostTableViewCell.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 13.11.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell, ViewAppProtocol {

    var presentor: AppPresenterProtocol?
    var coordinator: ProfileCoordinator?

    private let coreData: CoreDataManager = CoreDataManager.shared


    var arrayPosts = [Post]()
    var cellIndex: Int = 0


    private let viewElements: ViewElements = ViewElements.shared


    private lazy var postText: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 16, weight: .regular)
        text.isEditable = false
        text.textAlignment = .left
        text.backgroundColor = UIColor(.backgraundCell)
        return text
    }()

    private lazy var avatar: UIImageView = {
        let image = viewElements.getSystemImage(image: "person.circle")
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var postAuthor: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    lazy var addInNoteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark")?.withTintColor(UIColor(.mainColor)!, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill")?.withTintColor(UIColor(.orange)!, renderingMode: .alwaysOriginal), for: .selected)
        button.addTarget(self, action: #selector(addInNote), for: .touchUpInside)
        return button
    }()

    private lazy var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(.mainColor)!
        return view
    }()

    private lazy var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        return view
    }()

    private lazy var coreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(.backgraundCell)!
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    // MARK: - Functions

    private func setupLayout() {

        contentView.addSubviews(avatar, postAuthor, coreView)

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.normalLeadingIndent),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.genderTop),
            avatar.heightAnchor.constraint(equalToConstant: Constants.topIndentFour),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),

            postAuthor.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Constants.smallLeadingIndent),
            postAuthor.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),

            coreView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coreView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coreView.topAnchor.constraint(equalTo: postAuthor.bottomAnchor, constant: Constants.topIndentTwo),
            coreView.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            coreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),


        ])

        coreView.addSubviews(verticalLine, horizontalLine, postText, addInNoteButton)

        NSLayoutConstraint.activate([

            horizontalLine.leadingAnchor.constraint(equalTo: coreView.leadingAnchor),
            horizontalLine.trailingAnchor.constraint(equalTo: coreView.trailingAnchor),
            horizontalLine.bottomAnchor.constraint(equalTo: coreView.bottomAnchor, constant: Constants.bottomIndentTwo),
            horizontalLine.heightAnchor.constraint(equalToConstant: Constants.horizontalLine),

            verticalLine.leadingAnchor.constraint(equalTo: coreView.leadingAnchor, constant: Constants.normalLeadingIndent),
            verticalLine.topAnchor.constraint(equalTo: coreView.topAnchor, constant: Constants.topIndentThree),
            verticalLine.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor, constant: Constants.bottomIndentThree),
            verticalLine.widthAnchor.constraint(equalToConstant: Constants.verticalLine),

            postText.topAnchor.constraint(equalTo: verticalLine.topAnchor),
            postText.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: Constants.normalLeadingIndent),
            postText.trailingAnchor.constraint(equalTo: coreView.trailingAnchor, constant: Constants.trailingIndent),
            postText.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor, constant: Constants.bottomIndent),

            addInNoteButton.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: Constants.genderTop),
            addInNoteButton.trailingAnchor.constraint(equalTo: coreView.trailingAnchor, constant: Constants.trailingIndent),
            addInNoteButton.heightAnchor.constraint(equalToConstant: Constants.heightButtonSize)
        ])
    }

    @objc private func addInNote() {
        // реализовать сохранение состояния кнопки
        coreData.savePost(index: cellIndex, postData: arrayPosts)

    }


    /// get post 
    func configCell(userPost: Post) {
        postAuthor.text = userPost.author
        postText.text = userPost.post
    }

    

}
