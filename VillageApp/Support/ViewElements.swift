//
//  ViewElements.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import UIKit

final class ViewElements {

    static let shared = ViewElements()

    private init() {}

    func getButton(name: StringKey) -> UIButton {
        let button = UIButton()
        button.setTitle(name.localizedString(), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = UIColor(.mainColor)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 1
        return button
    }
    /// more fine-tuning of the button
    func getButton(name: StringKey,
                   textColor: UIColor,
                   backroundColor: UIColor = .white,
                   cornerRadius: CGFloat = 0,
                   isShadow: Bool = false) -> UIButton {
        let button = UIButton()
        button.setTitle(name.localizedString(), for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backroundColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        if isShadow {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.cornerRadius = 4
            button.layer.shadowOpacity = 1
        }
        return button
    }

    func getLabel(text: StringKey,
                  size: CGFloat,
                  textColor: UIColor = .black,
                  weight: UIFont.Weight = .regular,
                  textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = text.localizedString()
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }

    func getLabel(textString: String,
                  size: CGFloat,
                  textColor: UIColor = .black,
                  weight: UIFont.Weight = .regular,
                  textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = textString
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }

    /// add system picture
    func getSystemImage(image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: image)?.withTintColor(UIColor(.mainColor)!, renderingMode: .alwaysOriginal)
        return imageView
    }

    /// add picture from assets catalog
    func getAssetsImage(_ image: ImageSet) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(image)
        imageView.contentMode = .scaleToFill
        return imageView
    }

    func getTextFieldForPhone(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor(.mainColor)
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(.mainColor)?.cgColor
        textField.keyboardType = .namePhonePad
        return textField
    }

    func getTextFieldForReg(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.textColor = .black
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(.backgraundCell)
        textField.keyboardType = .default
        return textField
    }


}

