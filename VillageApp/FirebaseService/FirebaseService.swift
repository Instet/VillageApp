//
//  FirebaseService.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 07.11.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService {

    static let shared: FirebaseService = FirebaseService()

    let dataBase = Firestore.firestore()

    var post = [[String : Any]]()

    private init() {}

    /// Registration by phone number for firebase
    func regUserByPhone(phoneNumber: String,
                        completion: @escaping (String) -> Void) {
        Auth.auth().languageCode = "ru"
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let verificationID = verificationID else { return }
            completion(verificationID)
        }
    }

    /// Verification id check for firebase
    ///
    /// verificationCode - user input in TextField
    func verificationCheck(verificationID: String,
                           verificationCode: String,
                           failure: @escaping (String) -> Void,
                           completion: @escaping () -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID,
                                                                 verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { authDataResult, error in
            guard error == nil else { failure("Неправильный код верификации, проверьте еще раз"); return }
            completion()
        }
    }

    /// save user in firestore
    func saveUser(dataUser: [String : Any],
                  completion: @escaping (String) -> Void) {
        var newUser: DocumentReference? = nil
        newUser = dataBase.collection("User").addDocument(data: dataUser) { error in
            guard error == nil else { print(error!.localizedDescription); return }
            completion(newUser!.documentID)
        }
    }

    /// get user by number phone
    func getUserByPhone(phone: String,
                        handler: @escaping (([String : Any])?) -> Void,
                        failure: @escaping (String) -> Void) {
        let userRef =  dataBase.collection("User")
        let query = userRef.whereField("phone", isEqualTo: phone)
        query.getDocuments { querySnapshot, error in
            guard error == nil else { failure(error!.localizedDescription); return }
            if querySnapshot!.documents.isEmpty {
                handler(nil)
            } else {
                var document = querySnapshot?.documents[0].data()
                document?.updateValue(querySnapshot!.documents[0].documentID, forKey: "id")
                handler(document)
            }
        }
    }

    /// save new post
    func savePost(dataPost: [String : Any]) {
        dataBase.collection("Post").addDocument(data: dataPost, completion: { error in
            guard error == nil else { print(error!.localizedDescription); return }
        })
    }


    func getUserPost(userPhone: String,
                     handler: @escaping ([[String : Any]]) -> Void,
                     failure: @escaping (String) -> Void) {
        let postRef = dataBase.collection("Post")
        let query = postRef.whereField("userPhone", isEqualTo: userPhone)

        query.getDocuments { querySnapshot, error in
            guard error == nil else { failure(error!.localizedDescription); return }
            let posts = querySnapshot?.documents.map({ (document) -> [String : Any] in
                let post = document.data()
                return post
            })
            handler(posts!)
        }

    }




}
