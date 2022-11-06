//
//  StringExtension.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import Foundation

extension String {

    /// for localization
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// format phone number  "12345678910" -> "+1(234)567-89-10"
    ///
    /// where mask - example: +x(xxx)xxx-xx-xx
    static func formatPhoneNumber(number: String, mask: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "_" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
