//
//  PhotoPreview.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 20.11.2022.
//

import UIKit


final class PhotoPreview: UIViewController {

    var photos: [Photo?] = []
    var index: Int = 0
    private let manager = FileManagerService()

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
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(deleteImage))
        trashButton.tintColor = UIColor(.mainColor)
        navigationItem.rightBarButtonItem = trashButton

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
        photo.image = photos[index]?.image
        }

    @objc private func onLeftPhoto() {
        if index > 0 {
            index -= 1
            photo.image = photos[index]?.image
        } else {
            index = photos.count - 1
            photo.image = photos[index]?.image
        }
    }

    @objc private func onRightPhoto() {
        if index != photos.count - 1 {
            index += 1
            photo.image = photos[index]?.image
        } else {
            index = 0
            photo.image = photos[index]?.image
        }

    }

    @objc private func deleteImage() {
        let alert = UIAlertController(title: StringKey.deletePhoto.localizedString(),
                                      message: StringKey.deletePhotoDescript.localizedString(),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: StringKey.cancelSave.localizedString(),
                                         style: .cancel)
        let deleteAction = UIAlertAction(title: StringKey.deletePhoto.localizedString(),
                                         style: .destructive) { [weak self] alert in
            guard let self = self else { return }
            guard let path = self.photos[self.index]?.path else { return }
            self.manager.remove(path) {
                self.photos.remove(at: self.index)
                self.navigationController?.popViewController(animated: false)
                // доработать

            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)

    }


}
