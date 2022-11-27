//
//  StringSet.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import Foundation

enum StringSet: String {
    
    case registrationString
    case hasAccountString
    case nextString
    case enterNumberString
    case numberForString
    case termsOfUse
    case confirmRegString
    case logIn
    case smsString
    case enterSMS
    case greatingString
    case enterNumberForApp
    case confirmString
    case noNameString
    case name
    case lastName
    case gender
    case birthday
    case city
    case editString
    case photos
    case photosIsEmty
    case myPosts
    case allPosts
    case myPhotos
    case emptyFavoritPost
    case exitString
    case titleHome
    case titleFavorites
    case info
    case infoHidden
    case male
    case female
    case savePost
    case cancelSave
    case basicInfo
    case failedNumber
    case failedCode
    case failedCodeDescript
    case error
    case errorDescript
    case titleProfile
    case formatWrong
    case accessFailed
    case accessFailedDescript


    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

}
