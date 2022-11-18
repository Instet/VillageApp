//
//  ProfileTableViewCell.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 07.11.2022.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {


    private let viewElements: ViewElements = ViewElements.shared

    var callback: (() -> ())?

    var stateButton: Bool = false

    private lazy var fullNameLabel = viewElements.getLabel(text: .noNameString,
                                                           size: 18,
                                                           textColor: UIColor(.mainColor)!,
                                                           weight: .semibold,
                                                           textAlignment: .left)
    private lazy var professionLabel = viewElements.getLabel(textString: "My profession",
                                                             size: 14,
                                                             textColor: .systemGray2,
                                                             weight: .semibold,
                                                             textAlignment: .left)

    private lazy var detailInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(.info), for: .normal)
        button.setTitle(" Подробная информация", for: .normal)
        button.setTitleColor(UIColor.createColor(lightMode: .darkText, darkMode: .lightText),
                             for: .normal)
        button.addTarget(self, action: #selector(tapDetailInfo), for: .touchUpInside)
        return button
    }()

    private lazy var avatar: UIImageView = {
        let image = viewElements.getSystemImage(image: "person.circle")
        image.layer.cornerRadius = 30
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    // MARK: Detail info for user
    private lazy var cityLabelTitle = viewElements.getLabel(text: .city,
                                                            size: 12,
                                                            textColor: .systemGray2,
                                                            textAlignment: .left)

    private lazy var cityLabel = viewElements.getLabel(textString: "no data",
                                                       size: 14,
                                                       textColor: UIColor(.mainColor)!,
                                                       weight: .semibold,
                                                       textAlignment: .left)

    private lazy var birthdayLabelTitle = viewElements.getLabel(text: .birthday,
                                                                size: 12,
                                                                textColor: .systemGray2,
                                                                textAlignment: .left)

    private lazy var birthdayLabel = viewElements.getLabel(textString: "no data",
                                                           size: 14,
                                                           textColor: UIColor(.mainColor)!,
                                                           weight: .semibold,
                                                           textAlignment: .left)

    private lazy var genderLabelTitle = viewElements.getLabel(text: .birthday,
                                                              size: 12,
                                                              textColor: .systemGray2,
                                                              textAlignment: .left)

    private lazy var genderLabel = viewElements.getLabel(textString: "no data",
                                                         size: 14,
                                                         textColor: UIColor(.mainColor)!,
                                                         weight: .semibold,
                                                         textAlignment: .left)


    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setupLayout() {
        contentView.addSubviews(avatar, fullNameLabel, professionLabel, detailInfoButton)

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topReg),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.normalLeadingIndent),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),

            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topIndentThree),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Constants.smallLeadingIndent),

            professionLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            professionLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: Constants.smallTopIndent),

            detailInfoButton.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: Constants.topIndentSix),
            detailInfoButton.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Constants.smallLeadingIndent),
//            detailInfoButton.heightAnchor.constraint(equalToConstant: Constants.heightButtonSize),
            detailInfoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomIndent)
        ])
    }

    
    @objc private func tapDetailInfo() {
        stateButton.toggle()
        if stateButton {

            detailInfoButton.removeFromSuperview()
            contentView.addSubviews(detailInfoButton, cityLabelTitle,
                                    cityLabel, birthdayLabelTitle,
                                    birthdayLabel, genderLabelTitle,
                                    genderLabel)
            detailInfoButton.setTitle(" Скрыть информацию", for: .normal)

            NSLayoutConstraint.activate([
                detailInfoButton.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: Constants.topIndentSix),
                detailInfoButton.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Constants.smallLeadingIndent),
                detailInfoButton.heightAnchor.constraint(equalToConstant: Constants.heightButtonSize),
//                detailInfoButton.bottomAnchor.constraint(equalTo: cityLabelTitle.topAnchor, constant: Constants.trailingIndent),

                cityLabelTitle.topAnchor.constraint(equalTo: detailInfoButton.bottomAnchor, constant: Constants.topIndentThree),
                cityLabelTitle.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),

                cityLabel.leadingAnchor.constraint(equalTo: cityLabelTitle.leadingAnchor),
                cityLabel.topAnchor.constraint(equalTo: cityLabelTitle.bottomAnchor, constant: Constants.smallTopIndent),

                birthdayLabelTitle.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
                birthdayLabelTitle.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.topIndentOne),

                birthdayLabel.topAnchor.constraint(equalTo: birthdayLabelTitle.bottomAnchor, constant: Constants.smallTopIndent),
                birthdayLabel.leadingAnchor.constraint(equalTo: birthdayLabelTitle.leadingAnchor),

                genderLabelTitle.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: Constants.topIndentOne),
                genderLabelTitle.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor),

                genderLabel.topAnchor.constraint(equalTo: genderLabelTitle.bottomAnchor, constant: Constants.smallTopIndent),
                genderLabel.leadingAnchor.constraint(equalTo: genderLabelTitle.leadingAnchor),
                genderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomIndent)
            ])

        } else {
            cityLabelTitle.removeFromSuperview()
            cityLabel.removeFromSuperview()
            birthdayLabelTitle.removeFromSuperview()
            birthdayLabel.removeFromSuperview()
            genderLabelTitle.removeFromSuperview()
            genderLabel.removeFromSuperview()
            setupLayout()
            detailInfoButton.setTitle(" Подробная информация", for: .normal)

        }
        self.callback!()
    }



    func configUserData(user: [String : Any]) {
        fullNameLabel.text = (user["name"] as? String ?? "Test") + " " + (user["lasname"] as? String ?? "User")
        cityLabel.text = user["city"] as? String ?? "Moscow"
        birthdayLabel.text = user["birthday"] as? String ?? "12.12.2012"

        let gender = user["isMale"] as? Bool ?? true
        if gender {
            genderLabel.text = "Мужской"
        } else {
            genderLabel.text = "Женский"
        }
    }
    
}
