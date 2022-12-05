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

    func dataInDate(data: Int) -> String {
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(data))
        let dateFormated = DateFormatter()
        dateFormated.timeZone = TimeZone(identifier: "UTC")
        dateFormated.dateFormat = "dd MMMM yyyy"
        dateFormated.locale = Locale(identifier: StringKey.datePost.localizedString())
        return dateFormated.string(from: date)
    }

}
