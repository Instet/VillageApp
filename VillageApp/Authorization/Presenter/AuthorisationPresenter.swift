//
//  AuthorisationPresenter.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 08.11.2022.
//

import Foundation
import UIKit

protocol AuthorisationPresenterProtocol {
    
    var view: ViewAuthorisationProtocol? { get set }
    var coordinator: AuthorizationCoordinator? { get set }
    var user: User? { get set }
    var phone: String { get set }

    func registrationUser(phone: String)
    func checkVerificationID(verificationCode: String)
    func checkUserData(userData: [String : Any])
}


final class AuthorisationPresenter: AuthorisationPresenterProtocol {

    var view: ViewAuthorisationProtocol?
    var coordinator: AuthorizationCoordinator?
    var user: User?
    var phone: String = ""

    init(coordinator: AuthorizationCoordinator) {
        self.coordinator = coordinator
    }

    func registrationUser(phone: String) {
        if phone.count < 16 {
            failureAlert(title: "Неправильно набран номер",
                         message: nil,
                         preferredStyle: .alert,
                         actions: [("Ok", UIAlertAction.Style.cancel, nil)])

            return
        }
        FirebaseService.sharad.regUserByPhone(phoneNumber: phone) { verificationID in
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.coordinator?.confirmView(phone: phone)
        }
    }

    func checkVerificationID(verificationCode: String) {
        if verificationCode.count < 6 {
            failureAlert(title: "Неверный код",
                         message: "Код верификации должен состоять из 6 цифр",
                         preferredStyle: .alert,
                         actions: [("Ok", UIAlertAction.Style.cancel, nil)])
            return
        }
        let failure: (String) -> Void = { [weak self] error in
            self?.failureAlert(title: error,
                               message: nil,
                               preferredStyle: .alert,
                               actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }


        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        FirebaseService.sharad.verificationCheck(verificationID: verificationID!, verificationCode: verificationCode, failure: failure) {
            self.coordinator?.registationData()
        }
    }

    func checkUserData(userData: [String : Any]) {
        var isEmptyData = false
        if (userData["name"] as? String ?? "").isEmpty ||
            (userData["lastName"] as? String ?? "").isEmpty ||
            (userData["city"] as? String ?? "").isEmpty ||
            (userData["birthday"] as? String ?? "").isEmpty ||
            (userData["birthday"] as? String ?? "").count < 10 {
            isEmptyData = true
        }
        if isEmptyData {
            failureAlert(title: "Ошибка",
                         message: "Заполните все поля",
                         preferredStyle: .alert,
                         actions: [("Ок", UIAlertAction.Style.default, nil)])
            return
        }
        self.user = User(data: userData)
        FirebaseService.sharad.saveUser(dataUser: userData) { [weak self] id in
            guard let self = self else { return }
            print(id)
            self.user?.id = id
        }

    }


    
}



extension AuthorisationPresenter {

    func failureAlert(title: String,
                      message: String?,
                      preferredStyle: UIAlertController.Style,
                      actions: [(title: String,
                                 style: UIAlertAction.Style,
                                 handler: ((UIAlertAction) -> Void)?)]) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alertAction in
            let action = UIAlertAction(title: alertAction.title,
                                       style: alertAction.style) { action in
                if let handler = alertAction.handler {
                    handler(action)
                }
            }
            alertController.addAction(action)
        }
        coordinator?.navigationController?.present(alertController, animated: true)

    }
}
