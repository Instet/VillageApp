//
//  PhotoPreview.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 20.11.2022.
//

import UIKit


final class PhotoPreview: UIViewController {

    var images: [UIImage] = []
    var index: Int = 0

    lazy var photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 25)), for: .normal)
        button.tintColor = UIColor(.orange)
        button.addTarget(self, action: #selector(onLeftPhoto), for: .touchUpInside)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 25)), for: .normal)
        button.tintColor = UIColor(.orange)
        button.addTarget(self, action: #selector(onRightPhoto), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        showPhoto()

    }

    private func setupLayout() {
        view.addSubviews(photo, leftButton, rightButton)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            photo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photo.heightAnchor.constraint(equalToConstant: 300),
            photo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingIndent),
            leftButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 100),

            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.trailingIndent),
            rightButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: Constants.heightStandart)
        ])

    }

    func showPhoto() {
        photo.image = images[index]
        }

    @objc private func onLeftPhoto() {
        if index > 0 {
            index -= 1
            photo.image = images[index]
        } else {
            index = images.count - 1
            photo.image = images[index]
        }
    }

    @objc private func onRightPhoto() {
        if index != images.count - 1 {
            index += 1
            photo.image = images[index]
        } else {
            index = 0
            photo.image = images[index]
        }

    }


}
