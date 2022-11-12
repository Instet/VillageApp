//
//  MainTabBarController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    private lazy var homeNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: HomeViewController())
        navigation.tabBarItem = UITabBarItem(title: "Главная",
                                             image: UIImage(.houseOrange),
                                             selectedImage: UIImage(.houseOrange))
        return navigation
    }()

    private lazy var profileNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: ProfileViewController())
        navigation.tabBarItem = UITabBarItem(title: "Профиль",
                                             image: UIImage(.user),
                                             selectedImage: UIImage(.user))

        return navigation
    }()

    private lazy var favoritesNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: FavoritesViewController())
        navigation.tabBarItem = UITabBarItem(title: "Cохраненные",
                                             image: UIImage(.like),
                                             selectedImage: UIImage(.like))
        return navigation
    }()



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(.orange)
        viewControllers = [homeNC, profileNC, favoritesNC]

    }
    

 

}
