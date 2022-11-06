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
}
