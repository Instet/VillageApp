//
//  AppCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 14.11.2022.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: AnyObject {

    var navigationController: UINavigationController? { get set }

    func addPostPresent(presentor: AppPresenterProtocol?,
                        coordinator: AppCoordinatorProtocol?,
                        user: User)
    func pushPhotoView(presentor: AppPresenterProtocol?,
                       coordinator: AppCoordinatorProtocol?)

    func showPhoto(images: [UIImage]?, index: Int)
    func dismis()


}

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController?

    // MARK: - Functions

    func addPostPresent(presentor: AppPresenterProtocol?,
                        coordinator: AppCoordinatorProtocol?,
                        user: User) {
        let vc = AddPostViewController()
        vc.presentor = presentor
        vc.coordinator = coordinator
        vc.user = user
        vc.modalPresentationStyle = .automatic
        navigationController?.present(vc, animated: true)
    }

    func pushPhotoView(presentor: AppPresenterProtocol?,
                       coordinator: AppCoordinatorProtocol?) {
        let vc = PhotosViewController()
        vc.addBackButton()
        vc.coordinator = coordinator
        vc.presentor = presentor
        navigationController?.pushViewController(vc, animated: true)
    }

    func showPhoto(images: [UIImage]?, index: Int) {
        guard let images = images else { return }
        let vc = PhotoPreview()
        vc.index = index
        vc.images = images
        vc.addBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }



    func dismis() {
        navigationController?.dismiss(animated: true)
    }
    
}
