//
//  PhotosViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 20.11.2022.
//

import UIKit
import Photos
import PhotosUI


class PhotosViewController: UIViewController, ViewAppProtocol {

    var presenter: AppPresenterProtocol?
    var coordinator: ProfileCoordinator?
    private let fileManager = FileManagerService()


    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()

    private lazy var photosCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.register(PhotoItemCell.self, forCellWithReuseIdentifier: String(describing: PhotoItemCell.self))
        return collection
    }()


    // MARK: - Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getImage()
        photosCollection.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        photosCollection.delegate = self
        photosCollection.dataSource = self
    }

    private func setupLayout() {
        self.title = StringKey.myPhotos.localizedString()
        view.backgroundColor = .systemBackground

        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(UIColor(.mainColor)!, renderingMode: .alwaysOriginal),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addPhoto))
        navigationItem.rightBarButtonItem = addButton

        view.addSubviews(photosCollection)

        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])

    }

    
    @objc private func addPhoto() {
        presenter?.requestAuthorisation(completion: { [weak self ] in
                self?.showImagePicker()
        })
    }


}

// MARK: - UICollectionViewDelegateFlowLayout {

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: - UICollectionViewDataSource {

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoItemCell.self), for: indexPath) as? PhotoItemCell else { return UICollectionViewCell() }
        photoCell.configCell(photo: presenter?.photos[indexPath.row])
        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.presentationSectionIndex(forDataSourceSectionIndex: indexPath.row)
        guard let photos = presenter?.photos else { return }
            coordinator?.showPhoto(photos: photos, index: indexPath.row)
    }

}

// MARK: - UIImagePickerControllerDelegate {

extension PhotosViewController: PHPickerViewControllerDelegate {


    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self ) { image, error in

                print(image.debugDescription)
                if let image = image as? UIImage {
                    self.fileManager.createFile(image) { [weak self] in
                        guard let self = self else { return }
                        self.presenter?.getImage()
                    }
                    DispatchQueue.main.async {
                        self.photosCollection.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: StringKey.error.localizedString(),
                                                      message: StringKey.formatWrong.localizedString(),
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }


    private func showImagePicker() {
        var configuration = PHPickerConfiguration()
        let filter = PHPickerFilter.images
        configuration.filter = filter
        configuration.selectionLimit = 1

        DispatchQueue.main.async {
            let imagePicker = PHPickerViewController(configuration: configuration)
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
    }

}
