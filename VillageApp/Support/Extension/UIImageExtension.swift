//
//  UIImageExtension.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import UIKit

extension UIImage {

    /// convenience init for enum ImageSet
    convenience init?(_ setImage: ImageSet) {
        self.init(named: setImage.rawValue)
    }

}
