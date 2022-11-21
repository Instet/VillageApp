//
//  AuthorisationPresenter.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 08.11.2022.
//

import Foundation
import UIKit

protocol ViewAuthorisationProtocol: AnyObject {

    var presenter: AuthorisationPresenterProtocol? { get set }
}


protocol AuthorisationPresenterProtocol {
    
    var view: ViewAuthorisationProtocol? { get set }
    var coordinator: AuthorizationCoordinator? { get set }

    func registrationUser(phone: String)
    func checkVerificationID(verificationCode: String)
    func checkUserData(userData: [String : Any])
}


final class AuthorisationPresenter: AuthorisationPresenterProtocol {

    var view: ViewAuthorisationProtocol?
    var coordinator: AuthorizationCoordinator?

    private let backendService = FirebaseService.shared

    static var phoneNumber: String = ""

    // MARK: - Init
    init(coordinator: AuthorizationCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Functions
    func registrationUser(phone: String) {

        if phone.count < 16 {
            failureAlert(title: "Неправильно набран номер",
                         message: nil,
                         preferredStyle: .alert,
                         actions: [("Ok", UIAlertAction.Style.cancel, nil)])

            return
        }
        AuthorisationPresenter.phoneNumber = phone
        backendService.regUserByPhone(phoneNumber: phone) { verificationID in
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
            guard let self = self else { return }
            self.failureAlert(title: error,
                               message: nil,
                               preferredStyle: .alert,
                               actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }

        let handler: (User?) -> Void = { [weak self] user in
            guard let self = self else { return }
            if user == nil {
                self.coordinator?.registationData()
            } else {
                self.coordinator?.startApp(user: user!)
            }
        }

        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        backendService.verificationCheck(verificationID: verificationID!, verificationCode: verificationCode, failure: failure) {
            FirebaseService.shared.getUserByPhone(phone: AuthorisationPresenter.phoneNumber,
                                                  handler: handler,
                                                  failure: failure)
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
        var userDataForFirebase = userData
        userDataForFirebase.updateValue(AuthorisationPresenter.phoneNumber, forKey: "phone")


        backendService.saveUser(dataUser: userDataForFirebase) {
            UserDefaults.standard.set(true, forKey: "isRegistred")
        }
        getUserData { user in
            self.coordinator?.startApp(user: user)
        }
    }



    private func getUserData(completion: @escaping (User) -> Void) {

        let failure: (String) -> Void = { [weak self] error in
            guard let self = self else { return }
            self.failureAlert(title: error,
                               message: nil,
                               preferredStyle: .alert,
                               actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }
        let handler: (User?) -> Void = {  user in
            completion(user!)
        }
        backendService.getUserByPhone(phone: AuthorisationPresenter.phoneNumber, handler: handler, failure: failure)
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
