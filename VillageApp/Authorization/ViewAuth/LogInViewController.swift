//
//  LogInViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

class LogInViewController: UIViewController, ViewAuthorisationProtocol {

    var presenter: AuthorisationPresenterProtocol?

    private let viewElements: ViewElements = ViewElements.shared

    private var numberPhone: String = ""

    private lazy var greatigLabel = viewElements.getLabel(text: .greatingString,
                                                          size: 18,
                                                          textColor: UIColor(.orange)!,
                                                          weight: .bold)

    private lazy var secondLabel = viewElements.getLabel(text: .enterNumberForApp,
                                                         size: 14,
                                                         textColor: UIColor(.mainColor)!,
                                                         weight: .regular)

    private lazy var numberTextField: UITextField = {
        let textField = viewElements.getTextFieldForPhone(placeholder: "+7(___)___-__-__")
        textField.delegate = self
        return textField
    }()

    private lazy var confirmButton: UIButton = {
        let button = viewElements.getButton(name: .confirmString)
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        view.addGestureRecognizer(gesture)
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubviews(greatigLabel, secondLabel, numberTextField, confirmButton)

        NSLayoutConstraint.activate([
            greatigLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.bigTopIndent),
            greatigLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            secondLabel.topAnchor.constraint(equalTo: greatigLabel.bottomAnchor, constant: Constants.topIndentSix),
            secondLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondLabel.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.veryBigTotalIndent),

            numberTextField.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: Constants.topIndentTwo),
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.bigLeadingIndent),
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.bigTrailingIndent),
            numberTextField.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            confirmButton.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: Constants.bigTopIndent),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: Constants.heightStandart),
            confirmButton.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.veryBigTotalIndent)
        ])
    }


    @objc private func confirmAction() {
        guard let numberPhone = numberTextField.text else { return }
        presenter?.registrationUser(phone: numberPhone)
    }

    @objc private func endEdit() {
        view.endEditing(true)
    }


}

// MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = String.formatPhoneNumber(number: newString, mask: "+_(___)___-__-__")
        numberPhone = "+" + newString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return false
    }
    
}
