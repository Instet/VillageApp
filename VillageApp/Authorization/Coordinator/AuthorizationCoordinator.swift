//
//  AuthorizationCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

protocol CoordinatorProtocol {

    var navigationController: UINavigationController? { get set }

    func start()
    func regView()
    func confirmView(phone: String)
    func logInView()
    func registationData()
    func startApp(userData: [String : Any])

}


final class AuthorizationCoordinator: CoordinatorProtocol {


    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }



    func start() {
        if UserDefaults.standard.bool(forKey: "isRegistred") == true {
            let presenter = AuthorisationPresenter(coordinator: self)
            let vc = LogInViewController()
            vc.presenter = presenter
            navigationController?.viewControllers = [vc]
        } else {
            let vc = FirstEnterViewController()
            vc.coordinator = self
            navigationController?.viewControllers = [vc]
        }
    }

    func regView() {
        let presenter = AuthorisationPresenter(coordinator: self)
        let vc = RegistrationViewController()
        vc.presenter = presenter
        vc.addBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }

    func confirmView(phone: String) {
        let presenter = AuthorisationPresenter(coordinator: self)
        let vc = ConfirmRegistViewController()
        vc.presenter = presenter
        vc.phone = phone
        vc.addBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }

    func logInView() {
        let presenter = AuthorisationPresenter(coordinator: self)
        let vc = LogInViewController()
        vc.presenter = presenter
        vc.addBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }

    func registationData() {
        let presenter = AuthorisationPresenter(coordinator: self)
        let vc = UserDataViewController()
        vc.presenter = presenter
        navigationController?.viewControllers = [vc]
    }

    func startApp(userData: [String : Any]) {
        let presenter = AppPresentor()
        let coordinator = AppCoordinator()
        let mainTabBar = MainTabBarController(presenter: presenter, coordinator: coordinator, userData: userData)
        navigationController?.viewControllers = [mainTabBar]
    }











}
