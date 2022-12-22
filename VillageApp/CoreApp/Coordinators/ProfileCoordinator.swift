//
//  ProfileCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 26.11.2022.
//

import Foundation
import UIKit

final class ProfileCoordinator: CoordinatorViewController  {
    
    var navigationController: UINavigationController?
    var user: User?
    var callback: (() -> ())

    init(user: User?, callback: @escaping () -> Void) {
        self.user = user
        self.callback = callback
    }

    
    func start() -> UINavigationController? {
        let builder = BuilderModule(state: .profile)
        let presenter = AppPresenter()
        presenter.coordinator = self
        navigationController = builder.builerModule(coordinator: self,
                                                    presenter: presenter,
                                                    user: user)
        return navigationController
    }

    func addPostPresent(presenter: AppPresenterProtocol?, user: User) {
        let vc = AddPostViewController(coordinator: self)
        vc.presenter = presenter
        vc.user = user
        vc.modalPresentationStyle = .automatic
        navigationController?.present(vc, animated: true)
    }

    func pushPhotoView(presenter: AppPresenterProtocol) {
        let vc = PhotosViewController()
        vc.addBackButton()
        vc.coordinator = self
        vc.presenter = presenter
        navigationController?.pushViewController(vc, animated: true)
    }

    func showPhoto(photos: [Photo], index: Int) {
        let vc = PhotoPreview()
        vc.index = index
        vc.photos = photos
        vc.addBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }



    func dismiss() {
        navigationController?.dismiss(animated: true)
    }

    func exitProfile() {
        callback()
    }

    
}
