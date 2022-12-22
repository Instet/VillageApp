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
        let presenter = AppPresenter()
        navigationController = builder.builerModule(coordinator: self,
                                                    presenter: presenter,
                                                    user: nil)
        return navigationController
    }


}
