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
                        userData: [String : Any])
    func dismis()


}

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController?

    // MARK: - Functions

    func addPostPresent(presentor: AppPresenterProtocol?,
                        coordinator: AppCoordinatorProtocol?,
                        userData: [String : Any]) {
        let vc = AddPostViewController()
        vc.presentor = presentor
        vc.coordinator = coordinator
        vc.userData = userData
        vc.modalPresentationStyle = .automatic
        navigationController?.present(vc, animated: true)
    }

    func dismis() {
        navigationController?.dismiss(animated: true)
    }
}
