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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        showPhoto()

    }

    private func setupLayout() {
        view.addSubviews(photo)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            photo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photo.heightAnchor.constraint(equalToConstant: 300),
            photo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func showPhoto() {
        photo.image = images[index]
        }


}
