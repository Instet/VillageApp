//
//  UIColorExtension.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import UIKit

extension UIColor {

    /// convenience init for enum ColorSet
    convenience init?(_ setColor: ColorSet) {
        self.init(named: setColor.rawValue)
    }

    /// static func  to customize the dark theme
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
            }
        } else {
            return lightMode
        }
    }


}
