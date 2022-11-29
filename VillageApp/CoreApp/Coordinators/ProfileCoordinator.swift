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
        let presentor = AppPresentor()
        presentor.coordinator = self
        navigationController = builder.builerModule(coordinator: self,
                                                    presentor: presentor,
                                                    user: user)
        return navigationController
    }

    func addPostPresent(presentor: AppPresenterProtocol?, user: User) {
        let vc = AddPostViewController(coordinator: self)
        vc.presentor = presentor
        vc.user = user
        vc.modalPresentationStyle = .automatic
        navigationController?.present(vc, animated: true)
    }

    func pushPhotoView(presentor: AppPresenterProtocol) {
        let vc = PhotosViewController()
        vc.addBackButton()
        vc.coordinator = self
        vc.presentor = presentor
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
