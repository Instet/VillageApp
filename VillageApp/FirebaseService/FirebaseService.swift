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

    static let sharad: FirebaseService = FirebaseService()

    let dataBase = Firestore.firestore()

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







}
