//
//  HomeHeaderView.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 18.11.2022.
//

import UIKit

class HomeHeaderView: UITableViewHeaderFooterView {

    private let viewElements: ViewElements = ViewElements.shared

    private lazy var labelTitlePost = viewElements.getLabel(text: .allPosts,
                                                            size: 16,
                                                            textColor: UIColor(.mainColor)!,
                                                            weight: .regular,
                                                            textAlignment: .left)
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
        addSubviews(labelTitlePost)

        NSLayoutConstraint.activate([
            labelTitlePost.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.normalLeadingIndent),
            labelTitlePost.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
