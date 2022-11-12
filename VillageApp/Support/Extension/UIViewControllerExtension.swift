//
//  UIViewControllerExtension.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 07.11.2022.
//

import UIKit

extension UIViewController {

    /// added custom back button
    func addBackButton() {
        let button: UIButton = UIButton()
        let image = UIImage(.backBlack)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(backButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

    }

    @objc private func backButtonClick(sender : UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
}
