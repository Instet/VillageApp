//
//  User.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import Foundation

class User {
    var id: String
    var birthday: String
    var name: String
    var lastName: String
    var city: String
    var isMale: Bool
    var phone: String

    init(data: [String : Any]) {
        self.id = data["id"] as? String ?? ""
        self.birthday = data["birthday"] as? String ?? "21.11.2022"
        self.name = data["name"] as? String ?? "User"
        self.lastName = data["lastName"] as? String ?? "Model"
        self.city = data["city"] as? String ?? "Samara"
        self.isMale = data["isMale"] as? Bool ?? true
        self.phone = data["phone"] as? String ?? "+7(999)987-65-45"
    }

   
}
