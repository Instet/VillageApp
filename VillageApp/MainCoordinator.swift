//
//  MainCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 25.11.2022.
//

import Foundation
import UIKit


enum StateApp {
    case coreAuth
    case coreApp
}


protocol CoordinatorViewController: AnyObject {
    var navigationController: UINavigationController? { get set }
    func start() -> UINavigationController?
}

final class MainCoordinator {

    func startApp(user: User?, stateApp: StateApp) -> UIViewController {
        let mainTabBarController = MainTabBarController(user: user, coordinator: self, stateApp: stateApp)
        return mainTabBarController
    }


}
