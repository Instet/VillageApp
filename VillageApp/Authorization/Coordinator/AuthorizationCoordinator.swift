//
//  AuthorizationCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

protocol AuthorizationCoordinatirProtocol {

    var navigationController: UINavigationController? { get set }
    var callback: (User?) -> () { get set }


    func start(coordinator: AuthorizationCoordinatirProtocol) -> UINavigationController?
    func regView()
    func confirmView(phone: String)
    func logInView()
    func registationData()
    func startApp(user: User)

}


final class AuthorizationCoordinator: AuthorizationCoordinatirProtocol {


    var navigationController: UINavigationController?
    var callback: (User?) -> ()

    // MARK: - Init

    init(navigationController: UINavigationController?,
         callback: @escaping (User?) -> Void) {
        self.callback = callback
        self.navigationController = navigationController
    }

    // MARK: - Functions

    func start(coordinator: AuthorizationCoordinatirProtocol) -> UINavigationController? {
        let firstVC = FirstEnterViewController()
        firstVC.coordinator = coordinator
        navigationController = UINavigationController(rootViewController: firstVC)
        return navigationController
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
        navigationController?.pushViewController(vc, animated: true)
    }

    func startApp(user: User) {
        callback(user)


    }











}
