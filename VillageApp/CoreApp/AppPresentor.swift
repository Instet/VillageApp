//
//  AppPresentor.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 14.11.2022.
//

import Foundation
import UIKit

protocol AppPresentorDelegate: AnyObject {

    func didUpdatePost()
}


protocol AppPresenterProtocol: AnyObject {

    var coordinator: AppCoordinatorProtocol? { get set }
    var delegate: AppPresentorDelegate? { get set }

    func addPost(userPost: [String : Any])
    func getPostForUser(userData: [String : Any], completion: @escaping ([[String : Any]]) -> Void)
    func getAllPost(completion: @escaping ([[String : Any]]) -> Void)
}

// Добавить метод удаление
// Сортировка постов по дате
// добавить возможность сохранения фото

final class AppPresentor: AppPresenterProtocol {

    var delegate: AppPresentorDelegate?
    var coordinator: AppCoordinatorProtocol?
    private var backendService = FirebaseService.shared

    // MARK: - Functions

    func addPost(userPost: [String : Any]) {
        backendService.saveUserPost(dataPost: userPost)
        delegate?.didUpdatePost()
        coordinator?.dismis()
    }

    func getPostForUser(userData: [String : Any], completion: @escaping ([[String : Any]]) -> Void) {
        let failure: (String) -> Void = { [weak self] error in
            guard let self = self else { return }
            self.failureAlert(title: error,
                              message: nil,
                              preferredStyle: .alert,
                              actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }

        let handler: ([[String : Any]]) -> Void = { posts in
            completion(posts)

        }
        let userPhone = userData["phone"] as? String ?? "+7(999)987-65-45"
        backendService.getPostsForUser(userPhone: userPhone, handler: handler, failure: failure)
    }


    func getAllPost(completion: @escaping ([[String : Any]]) -> Void) {
        let failure: (String) -> Void = { [weak self] error in
            guard let self = self else { return }
            self.failureAlert(title: error,
                              message: nil,
                              preferredStyle: .alert,
                              actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }

        let handler: ([[String : Any]]) -> Void = { posts in
            completion(posts)
        }
        backendService.getAllPosts(handler: handler, failure: failure)
    }


}



extension AppPresentor {

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
