//
//  UIViewExtension.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

}
