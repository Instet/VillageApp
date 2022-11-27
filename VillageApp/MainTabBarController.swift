//
//  MainTabBarController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 26.11.2022.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {


    var coordinator: MainCoordinator?

    var stateApp: StateApp {
        didSet {
            switchStateApp()
        }
    }

    var user: User?


    // MARK: - Init

    init(user: User?,
         coordinator: MainCoordinator?,
         stateApp: StateApp) {
        self.user = user
        self.coordinator = coordinator
        self.stateApp = stateApp
        super.init(nibName: nil, bundle: nil)
        switchStateApp()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Func
    func switchStateApp() {
        switch stateApp {
        case .coreApp:
            guard let user = user else { return }

            let profileCoordinator = ProfileCoordinator(user: user) {
                self.stateApp = .coreAuth
                self.user = nil
            }
            let profileNC = profileCoordinator.start()

            let homeCoordinator = HomeCoordinator()
            let homeNC = homeCoordinator.start()

            let favoritesCoordinator = FavoritesCoordinator()
            let favoritesNC = favoritesCoordinator.start()

            guard let profileNC = profileNC,
                  let homeNC = homeNC,
                  let favoritesNC = favoritesNC else { return }

            self.viewControllers = [
                homeNC, profileNC, favoritesNC
            ]
            self.tabBar.tintColor = UIColor(.orange)
        case .coreAuth:
            let navigationController = UINavigationController()
            let authCoordinator = AuthorizationCoordinator(navigationController: navigationController) { user in
                if user == nil {
                    self.stateApp = .coreAuth
                } else {
                    self.user = user
                    self.stateApp = .coreApp
                }
            }
            let firstNC = authCoordinator.start(coordinator: authCoordinator)

            guard let firstNC = firstNC else { return }
            
            self.viewControllers = [firstNC]
        }
    }

}
