//
//  PhotosTableViewCell.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 13.11.2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell, ViewAppProtocol {

    var presentor: AppPresenterProtocol?
    var coordinator: AppCoordinatorProtocol?
    
    private let viewElements: ViewElements = ViewElements.shared

    private lazy var photosLabel = viewElements.getLabel(text: .photos,
                                                         size: 16,
                                                         textColor: UIColor(.mainColor)!,
                                                         weight: .medium,
                                                         textAlignment: .left)

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.next)?.withTintColor(UIColor(.mainColor)!,
                                                      renderingMode: .alwaysOriginal),
                        for: .normal)
        button.addTarget(self, action: #selector(pushTap), for: .touchUpInside)
        return button
    }()

    private lazy var countStatePhotosLabel = viewElements.getLabel(text: .photosIsEmty,
                                                                   size: 18,
                                                                   textColor: .systemGray2,
                                                                   weight: .medium,
                                                                   textAlignment: .center)


    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: imageViewArray)
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private lazy var imageViewArray: [UIImageView] = {
        var array = [UIImageView]()
        for _ in 1...4 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            array.append(imageView)
        }

        return array
    }()


    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        if imageViewArray[0].image == nil {
            stackView.isHidden = true
        } else {
            countStatePhotosLabel.isHidden = true
            stackView.isHidden = false
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Functions

    private func setupLayout() {
        contentView.addSubviews(photosLabel, nextButton, countStatePhotosLabel, stackView)

        NSLayoutConstraint.activate([
            photosLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topIndentOne),
            photosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingIndent),

            nextButton.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingIndent),

            stackView.leadingAnchor.constraint(equalTo: photosLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: Constants.topIndentOne),
            stackView.heightAnchor.constraint(equalToConstant: Constants.topIndentSeven),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomIndentOne),

            countStatePhotosLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countStatePhotosLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func pushTap() {
        print(#function)
    }

  
}
