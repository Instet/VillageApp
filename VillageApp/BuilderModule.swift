//
//  BuilderModule.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 26.11.2022.
//

import Foundation
import UIKit

final class BuilderModule {

    enum State {
        case home
        case profile
        case favorites
    }

    var state: State

    init(state: State) {
        self.state = state
    }

    func builerModule(coordinator: CoordinatorViewController?,
                      presenter: AppPresenterProtocol?,
                      user: User?) -> UINavigationController? {

        switch state {
        case .home:
            let homeVC = HomeViewController(presenter: presenter)
            let homeNC = UINavigationController(rootViewController: homeVC )
            homeNC.tabBarItem = UITabBarItem(title: StringKey.titleHome.localizedString(),
                                                 image: UIImage(.houseOrange),
                                                 selectedImage: UIImage(.houseOrange))
            return homeNC
        case .profile:
            guard let user = user else { return nil}
            let profileVC = ProfileViewController(presenter: presenter,
                                                  coordinator: coordinator as? ProfileCoordinator,
                                                  user: user)
            let profileNC = UINavigationController(rootViewController: profileVC)
            profileNC.tabBarItem = UITabBarItem(title: StringKey.titleProfile.localizedString(),
                                                 image: UIImage(.user),
                                                 selectedImage: UIImage(.user))
            return profileNC
        case .favorites:
            let favoritesVC = FavoritesViewController(presenter: presenter,
                                                      coordinator: coordinator as? FavoritesCoordinator)
            let favoritesNC = UINavigationController(rootViewController: favoritesVC)
            favoritesNC.tabBarItem = UITabBarItem(title: StringKey.titleFavorites.localizedString(),
                                                 image: UIImage(.like),
                                                 selectedImage: UIImage(.like))
            return favoritesNC
        }


    }
}
