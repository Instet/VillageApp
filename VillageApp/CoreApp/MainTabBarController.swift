//
//  MainTabBarController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

class MainTabBarController: UITabBarController, ViewAppProtocol {

    var presentor: AppPresenterProtocol?
    var coordinator: AppCoordinatorProtocol?

    var userData: [String : Any]

    private lazy var homeNC: UINavigationController = {
        
        let navigation = UINavigationController(rootViewController: HomeViewController())
        navigation.tabBarItem = UITabBarItem(title: "Главная",
                                             image: UIImage(.houseOrange),
                                             selectedImage: UIImage(.houseOrange))
        return navigation
    }()

    private lazy var profileNC: UINavigationController = {
        let profileVC = ProfileViewController(presentor: presentor ,userData: userData)
        profileVC.coordinator = coordinator
        presentor?.coordinator = coordinator
        let navigation = UINavigationController(rootViewController: profileVC)
        navigation.tabBarItem = UITabBarItem(title: "Профиль",
                                             image: UIImage(.user),
                                             selectedImage: UIImage(.user))

        coordinator?.navigationController = navigation

        return navigation
    }()

    private lazy var favoritesNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: FavoritesViewController())
        navigation.tabBarItem = UITabBarItem(title: "Cохраненные",
                                             image: UIImage(.like),
                                             selectedImage: UIImage(.like))
        return navigation
    }()

    init(presenter: AppPresenterProtocol?, coordinator: AppCoordinatorProtocol) {
        self.userData = AuthorisationPresenter.userData
        self.presentor = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



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
