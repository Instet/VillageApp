//
//  AppPresentor.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 14.11.2022.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import Firebase
import FirebaseAuth

protocol AppPresentorDelegate: AnyObject {

    func didUpdatePost()
}


protocol AppPresenterProtocol: AnyObject {

    var coordinator: ProfileCoordinator? { get set }
    var delegate: AppPresentorDelegate? { get set }
    var photos: [Photo] { get set }

    func addPost(userPost: [String : Any])
    func getPostForUser(user: User, completion: @escaping ([Post]) -> Void)
    func getAllPost(completion: @escaping ([Post]) -> Void)
    func getImage()
    func exitProfile()

    /// checking access to the photo library
    func requestAuthorisation(completion: @escaping () -> Void)
}

// Добавить метод удаления

final class AppPresentor: AppPresenterProtocol {

    var delegate: AppPresentorDelegate?
    var coordinator: ProfileCoordinator?
    private let fileManager = FileManagerService()
    var photos: [Photo] = []


    private var backendService = FirebaseService.shared

    // MARK: - Functions

    func addPost(userPost: [String : Any]) {
        backendService.saveUserPost(dataPost: userPost)
        delegate?.didUpdatePost()
        coordinator?.dismiss()
    }



    func getPostForUser(user: User, completion: @escaping ([Post]) -> Void) {
        let failure: (String) -> Void = { [weak self] error in
            guard let self = self else { return }
            self.failureAlert(title: error,
                              message: nil,
                              preferredStyle: .alert,
                              actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }

        let handler: ([Post]) -> Void = { posts in
            completion(posts)

        }
        backendService.getPostsForUser(userPhone: user.phone, handler: handler, failure: failure)
    }




    func getAllPost(completion: @escaping ([Post]) -> Void) {
        let failure: (String) -> Void = { [weak self] error in
            guard let self = self else { return }
            self.failureAlert(title: error,
                              message: nil,
                              preferredStyle: .alert,
                              actions: [("Ok", UIAlertAction.Style.cancel, nil)])
        }

        let handler: ([Post]) -> Void = { posts in
            completion(posts)
        }
        backendService.getAllPosts(handler: handler, failure: failure)
    }



    func requestAuthorisation(completion: @escaping () -> Void) {
        let photoStatus: PHAuthorizationStatus
        photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if photoStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == .authorized || status == .limited{
                    completion()
                } else {
                    DispatchQueue.main.async {
                        self.alertForRequstAuthPH()
                    }
                }
            }
        } else if photoStatus == .authorized || photoStatus == .limited {
            completion()
        } else {
            DispatchQueue.main.async {
                self.alertForRequstAuthPH()
            }
        }

    }


    func getImage() {
        photos.removeAll()

        guard let urlImages = fileManager.getFiles() else { return }
        for url in urlImages {
            var photo: Photo?
            photo = Photo(image: UIImage(contentsOfFile: url.path) ?? UIImage(),
                          path: url.path)
            photos.append(photo!)

        }

    }


    private func alertForRequstAuthPH() {
        failureAlert(title: StringKey.accessFailed.localizedString(),
                     message: StringKey.accessFailedDescript.localizedString(),
                     preferredStyle: .alert,
                     actions: [("Ok", UIAlertAction.Style.default, nil)])
    }

    func exitProfile() {
        do {
            try Auth.auth().signOut()
            coordinator?.exitProfile()
        } catch let error as NSError {
            print(error.userInfo)
        }
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
