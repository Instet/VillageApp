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
        self.birthday = data["birthday"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
        self.city = data["city"] as? String ?? ""
        self.isMale = data["isMale"] as? Bool ?? true
        self.phone = data["phone"] as? String ?? ""
    }

   
}
