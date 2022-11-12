//
//  AuthorizationCoordinator.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

protocol ViewAuthorisationProtocol: AnyObject {

    var presenter: AuthorisationPresenterProtocol? { get set }
}


protocol CoordinatorProtocol {

    var navigationController: UINavigationController? { get set }

    func start()
    func regView()
    func confirmView(phone: String)
    func logInView()
    func registationData()

}


final class AuthorizationCoordinator: CoordinatorProtocol {

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }



    func start() {
        let vc = FirstEnterViewController()
        vc.coordinator = self
        navigationController?.viewControllers = [vc]
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











}
