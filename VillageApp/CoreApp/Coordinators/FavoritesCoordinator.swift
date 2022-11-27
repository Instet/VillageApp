//
//  FavoritesCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 26.11.2022.
//

import Foundation
import UIKit

final class FavoritesCoordinator: CoordinatorViewController {

    var navigationController: UINavigationController?

    func start() -> UINavigationController? {
        let builder = BuilderModule(state: .favorites)
        let presentor = AppPresentor()
        navigationController = builder.builerModule(coordinator: self,
                                                    presentor: presentor,
                                                    user: nil)
        return navigationController
    }


}
