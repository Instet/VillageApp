//
//  PostHeaderView.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 13.11.2022.
//

import UIKit

class PostHeaderView: UITableViewHeaderFooterView, ViewAppProtocol {

    var presentor: AppPresenterProtocol?
    var coordinator: ProfileCoordinator?
    var user: User?

    private let viewElements: ViewElements = ViewElements.shared

    private lazy var labelTitlePost = viewElements.getLabel(text: .myPosts,
                                                            size: 16,
                                                            textColor: UIColor(.orange)!,
                                                            weight: .medium,
                                                            textAlignment: .left)

    private lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withTintColor(UIColor(.orange)!,
                                           renderingMode: .alwaysOriginal),
                        for: .normal)
        button.addTarget(self, action: #selector(addPost), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupLayout() {
        addSubviews(labelTitlePost, addPostButton)

        NSLayoutConstraint.activate([
            labelTitlePost.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelTitlePost.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingIndent),

            addPostButton.centerYAnchor.constraint(equalTo: labelTitlePost.centerYAnchor),
            addPostButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingIndent)

        ])
    }


    @objc func addPost() {
        guard let user = user else { return }
        coordinator?.addPostPresent(presentor: presentor,
                                    user: user)
    }
//
//    func assemblyHeader(presentor: AppPresenterProtocol?,
//                        //coordinator: ProfileCoordinator?,
//                        user: User) {
//        self.presentor = presentor
//        self.user = user
//        //self.coordinator = coordinator
//    }

}
