//
//  PhotoItemCell.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 20.11.2022.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {

    private lazy var imageCell: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    private func setupLayout() {
        contentView.addSubviews(imageCell)

        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }

    func configCell(photo: Photo?) {
        guard let photo = photo else { return }
        imageCell.image = photo.image
    }


}
