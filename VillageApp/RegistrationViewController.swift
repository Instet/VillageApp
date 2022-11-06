//
//  RegistrationViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 05.11.2022.
//

import UIKit

final class RegistrationViewController: UIViewController {

    private let viewElements: ViewElements = ViewElements.shared

    private lazy var registrationLabel = viewElements.getLabel(text: .registrationString,
                                                               size: 18,
                                                               textColor: UIColor(.mainColor)!,
                                                               weight: .bold)

    private lazy var enterNumbelLabel = viewElements.getLabel(text: .enterNumberString,
                                                              size: 16,
                                                              textColor: .systemGray4,
                                                              weight: .medium,
                                                              textAlignment: .center)

    private lazy var secondNumerLabel = viewElements.getLabel(text: .numberForString,
                                                              size: 12,
                                                              textColor: .systemGray,
                                                              weight: .regular,
                                                              textAlignment: .center)

    private lazy var privacyPolicyLabel = viewElements.getLabel(text: .termsOfUse,
                                                                size: 12,
                                                                textColor: .systemGray,
                                                                weight: .regular,
                                                                textAlignment: .center)

    private lazy var nextAppButton: UIButton = {
        let button = viewElements.getButton(name: .nextString)
        button.addTarget(self, action: #selector(nextAppAction), for: .touchUpInside)
        return button
    }()

    private lazy var numberTextField: UITextField = {
        let textField = viewElements.getTextFieldForPhone(placeholder: "+7(___)___-__-__")
        textField.delegate = self
        textField.addTarget(self, action: #selector(endEdit), for: .touchUpInside)
        return textField
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        view.addGestureRecognizer(gesture)

    }


    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubviews(registrationLabel, enterNumbelLabel, secondNumerLabel,
                         numberTextField, nextAppButton, privacyPolicyLabel)

        NSLayoutConstraint.activate([
            registrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topBigIndent),
            registrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            enterNumbelLabel.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: Constants.veryBigTopIndent),
            enterNumbelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            secondNumerLabel.topAnchor.constraint(equalTo: enterNumbelLabel.bottomAnchor, constant: Constants.miniTopIndent),
            secondNumerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondNumerLabel.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.bigTotalIndent),

            numberTextField.topAnchor.constraint(equalTo: secondNumerLabel.bottomAnchor, constant: Constants.indent),
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.bigLeadingIndent),
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.bigTrailingIndent),
            numberTextField.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            nextAppButton.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: Constants.veryBigTopIndent),
            nextAppButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextAppButton.heightAnchor.constraint(equalToConstant: Constants.heightStandart),
            nextAppButton.widthAnchor.constraint(equalToConstant: Constants.nextWeight),

            privacyPolicyLabel.topAnchor.constraint(equalTo: nextAppButton.bottomAnchor, constant: Constants.indentNextTop),
            privacyPolicyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyPolicyLabel.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.nextWeight)
        ])
    }



    @objc private func nextAppAction() {
        print(#function)
    }

    
    @objc private func endEdit() {
        view.endEditing(true)
    }


}


// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {

}
