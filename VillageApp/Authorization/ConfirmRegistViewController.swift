//
//  ConfirmRegistViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

final class ConfirmRegistViewController: UIViewController, ViewAuthorisationProtocol {

    var presenter: AuthorisationPresenterProtocol?

    private let viewElements: ViewElements = ViewElements.shared

    private var phoneCode: String = ""
    var phone = ""

    private lazy var confirmLabel = viewElements.getLabel(text: .confirmRegString,
                                                          size: 18,
                                                          textColor: UIColor(.orange)!,
                                                          weight: .bold)
    private lazy var labelPhone = viewElements.getLabel(textString: phone,
                                                        size: 14,
                                                        textColor: .black,
                                                        weight: .semibold)

    private lazy var secondConfirm = viewElements.getLabel(text: .smsString,
                                                           size: 14,
                                                           textColor: UIColor(.mainColor)!,
                                                           weight: .regular)
    private lazy var enterSMSLabel = viewElements.getLabel(text: .enterSMS,
                                                           size: 12,
                                                           textColor: .systemGray,
                                                           weight: .regular,
                                                           textAlignment: .left)

    private lazy var codeTextField: UITextField = {
        let textField = viewElements.getTextFieldForPhone(placeholder: "___-___")
        textField.delegate = self
        return textField
    }()

    private lazy var registationButton: UIButton = {
        let button = viewElements.getButton(name: .registrationString)
        button.addTarget(self, action: #selector(registrationConfirmAction), for: .touchUpInside)
        return button
    }()

    private lazy var image = viewElements.getAssetsImage(.labelApp)


    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        

        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        view.addGestureRecognizer(gesture)
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubviews(confirmLabel, secondConfirm, labelPhone, enterSMSLabel,
                         codeTextField, registationButton, image)

        NSLayoutConstraint.activate([

            confirmLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topIndentFive),
            confirmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            secondConfirm.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: Constants.topIndentTwo),
            secondConfirm.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            labelPhone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelPhone.topAnchor.constraint(equalTo: secondConfirm.bottomAnchor, constant: Constants.topIndentOne),

            enterSMSLabel.topAnchor.constraint(equalTo: labelPhone.bottomAnchor, constant: Constants.indent),
            enterSMSLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.bigLeadingIndent),

            codeTextField.topAnchor.constraint(equalTo: enterSMSLabel.bottomAnchor, constant: Constants.topIndentOne),
            codeTextField.leadingAnchor.constraint(equalTo: enterSMSLabel.leadingAnchor),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.bigTrailingIndent),
            codeTextField.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            registationButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: Constants.topIndentSeven),
            registationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registationButton.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.uniIndentBig),
            registationButton.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: registationButton.bottomAnchor, constant: Constants.topIndent)
        ])
    }

    

    @objc private func registrationConfirmAction() {
        presenter?.checkVerificationID(verificationCode: phoneCode)
    }

    @objc private func endEdit() {
        view.endEditing(true)
    }

}

// MARK: - UITextFieldDelegate
extension ConfirmRegistViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = String.formatPhoneNumber(number: newString, mask: "___-___")
        phoneCode = newString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return false
    }
    
    
}
