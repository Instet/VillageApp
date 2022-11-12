//
//  ProfileHeaderView.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 07.11.2022.
//

import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {

    let viewElements: ViewElements = ViewElements.shared

    private lazy var fullNameLabel = viewElements.getLabel(text: .noNameString,
                                              size: 18,
                                              textColor: UIColor(.mainColor)!,
                                              weight: .semibold,
                                              textAlignment: .left)

    private lazy var detailInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(.info)?.withTintColor(UIColor(.orange)!), for: .normal)
        button.setTitle("Подробная информация", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(tapDetailInfo), for: .touchUpInside)
        return button
    }()

    




    @objc private func tapDetailInfo() {
        print(#function)
    }
    
}
