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

    private init() {}

    /// Registration by phone number for firebase
    func regUserByPhone(phoneNumber: String,
                        handler: @escaping (String) -> Void) {
        Auth.auth().languageCode = "ru"
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let verificationID = verificationID else { return }
            handler(verificationID)
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
    func saveUser(dataUser: [String : Any], copmpletion: @escaping () -> Void) {
        dataBase.collection("User").addDocument(data: dataUser) { error in
            guard error == nil else { print(error!.localizedDescription); return }
            copmpletion()
        }
    }

    
    /// get user by number phone
    func getUserByPhone(phone: String,
                        handler: @escaping (User?) -> Void,
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
                let currentUser = User(data: document!)
                handler(currentUser)
            }
        }
    }

    /// save new post user
    func saveUserPost(dataPost: [String : Any]) {
        dataBase.collection("Post").addDocument(data: dataPost, completion: { error in
            guard error == nil else { print(error!.localizedDescription); return }
        })
    }
    

    /// get post for user by phone number
    func getPostsForUser(userPhone: String,
                         handler: @escaping ([Post]) -> Void,
                         failure: @escaping (String) -> Void) {
        let postRef = dataBase.collection("Post")
        let query = postRef.whereField("userPhone", isEqualTo: userPhone)

        query.getDocuments { querySnapshot, error in
            guard error == nil else { failure(error!.localizedDescription); return }
            let posts = querySnapshot?.documents.map({ (document) -> [String : Any] in
                let post = document.data()
                return post
            })
            let arrayPost = posts?.map({ dictPost in
                let post = Post(postData: dictPost)
                return post
            })
            handler(arrayPost!)
        }
    }

    /// get all posts
    func getAllPosts(handler: @escaping ([Post]) -> Void,
                     failure: @escaping (String) -> Void) {
        let postRef = dataBase.collection("Post")
        postRef.getDocuments { querySnapshot, error in
            guard error == nil else { failure(error!.localizedDescription); return }
            let posts = querySnapshot?.documents.map({ documets in
                let post = documets.data()
                return post
            })

            let arrayPost = posts?.map({ dictPost in
                let post = Post(postData: dictPost)
                return post
            })
            handler(arrayPost!)

        }
    }


}
