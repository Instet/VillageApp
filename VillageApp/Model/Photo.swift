//
//  Photo.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 28.11.2022.
//

import Foundation
import UIKit

final class Photo {

    var image: UIImage
    var path: String

    init(image: UIImage, path: String) {
        self.image = image
        self.path = path
    }

}
