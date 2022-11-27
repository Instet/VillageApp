//
//  UserDataViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 08.11.2022.
//

import UIKit

class UserDataViewController: UIViewController, ViewAuthorisationProtocol {

    var presenter: AuthorisationPresenterProtocol?

    private let viewElements: ViewElements = ViewElements.shared
    var isMale: Bool = true

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private lazy var nameLabel = viewElements.getLabel(text: .name,
                                                       size: 12,
                                                       textColor: .black,
                                                       weight: .medium,
                                                       textAlignment: .left)

    private lazy var nameTextField = viewElements.getTextFieldForReg(placeholder: StringSet.name.localizedString())

    private lazy var lastNameLabel = viewElements.getLabel(text: .lastName,
                                                           size: 12,
                                                           textColor: .black,
                                                           weight: .medium,
                                                           textAlignment: .left)

    private lazy var lastNameTextField = viewElements.getTextFieldForReg(placeholder: StringSet.lastName.localizedString())

    private lazy var genderLabel = viewElements.getLabel(text: .gender,
                                                       size: 12,
                                                       textColor: .black,
                                                       weight: .medium,
                                                       textAlignment: .left)

    private lazy var birthdayLabel = viewElements.getLabel(text: .birthday,
                                                           size: 12,
                                                           textColor: .black,
                                                           weight: .medium,
                                                           textAlignment: .left)

    private lazy var birthdayTextField = viewElements.getTextFieldForReg(placeholder: "__.__.____")

    private lazy var cityLabel = viewElements.getLabel(text: .city,
                                                           size: 12,
                                                           textColor: .black,
                                                           weight: .medium,
                                                           textAlignment: .left)

    private lazy var cityTextField = viewElements.getTextFieldForReg(placeholder: StringSet.city.localizedString())

    private lazy var isMaleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle")?.withTintColor(.createColor(lightMode: .darkText, darkMode: .lightText),
                                                                     renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled")?.withTintColor(UIColor(.orange)!, renderingMode: .alwaysOriginal), for: .selected)
        button.setTitle(" " + StringSet.male.localizedString(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(UIColor.createColor(lightMode: .darkText, darkMode: .lightText),
                             for: .normal)
        button.addTarget(self, action: #selector(chooseGender), for: .touchUpInside)
        return button
    }()

    private lazy var isFemaleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle")?.withTintColor(.createColor(lightMode: .darkText, darkMode: .lightText),
                                                                     renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled")?.withTintColor(UIColor(.orange)!,
                                                                                  renderingMode: .alwaysOriginal),   for: .selected)
        button.setTitle(" " + StringSet.female.localizedString(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(UIColor.createColor(lightMode: .darkText, darkMode: .lightText),
                             for: .normal)
        button.addTarget(self, action: #selector(chooseGender), for: .touchUpInside)
        return button
    }()



    // MARK: - Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        tabBarController?.tabBar.isHidden = true
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightTopButton()
        birthdayTextField.delegate = self
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        cityTextField.delegate = self
        birthdayTextField.keyboardType = .decimalPad
        setupLayout()
        conditionGenderButtons()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    private func setupLayout() {
        view.backgroundColor = .systemBackground
        self.title = StringSet.basicInfo.localizedString()
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(nameLabel, nameTextField, lastNameLabel,
                                lastNameTextField, genderLabel, isMaleButton,
                                isFemaleButton, birthdayLabel, birthdayTextField,
                                cityLabel, cityTextField)





        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topIndentFour),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.normalLeadingIndent),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.topIndentOne),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingIndent),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.heightRegTF),

            lastNameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.topReg),
            lastNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: Constants.topIndentOne),
            lastNameTextField.leadingAnchor.constraint(equalTo: lastNameLabel.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingIndent),
            lastNameTextField.heightAnchor.constraint(equalToConstant: Constants.heightRegTF),

            genderLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: Constants.topReg),
            genderLabel.leadingAnchor.constraint(equalTo: lastNameLabel.leadingAnchor),

            isMaleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: Constants.genderTop),
            isMaleButton.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor),
            isMaleButton.heightAnchor.constraint(equalToConstant: Constants.indent),

            isFemaleButton.topAnchor.constraint(equalTo: isMaleButton.bottomAnchor, constant: Constants.genderTop),
            isFemaleButton.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor),
            isFemaleButton.heightAnchor.constraint(equalToConstant: Constants.indent),

            birthdayLabel.topAnchor.constraint(equalTo: isFemaleButton.bottomAnchor, constant: Constants.topIndentFour),
            birthdayLabel.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor),

            birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: Constants.topIndentOne),
            birthdayTextField.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor),
            birthdayTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingIndent),
            birthdayTextField.heightAnchor.constraint(equalToConstant: Constants.heightRegTF),

            cityLabel.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: Constants.topReg),
            cityLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor),

            cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.topIndentOne),
            cityTextField.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            cityTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingIndent),
            cityTextField.heightAnchor.constraint(equalToConstant: Constants.heightRegTF)
        ])
    }

    

    @objc private func chooseGender() {
        if isMaleButton.isSelected {
            isMaleButton.isSelected = false
            isMale = false
            isFemaleButton.isSelected = true
        } else {
            isMaleButton.isSelected = true
            isMale = true
            isFemaleButton.isSelected = false
        }
    }

    private func conditionGenderButtons() {
        if isMale {
            isMaleButton.isSelected = true
        } else {
            isFemaleButton.isSelected = true
        }
    }


    @objc private func endView() {
        contentView.endEditing(true)
    }


    // MARK: Observer action for keyboard
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if nameTextField.isEditing == true || lastNameTextField.isEditing == true {
                scrollView.contentOffset.y = keyboardSize.height - (scrollView.frame.height - birthdayTextField.frame.minY) + 50
                scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            } else {
                scrollView.contentOffset.y = keyboardSize.height - (scrollView.frame.height - cityTextField.frame.minY) + 50
                scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }



    @objc private func saveUserData() {
        var userData = [String : Any]()
        userData.updateValue(nameTextField.text!, forKey: "name")
        userData.updateValue(lastNameTextField.text!, forKey: "lastName")
        userData.updateValue(cityTextField.text!, forKey: "city")
        userData.updateValue(isMale, forKey: "isMale")
        userData.updateValue(birthdayTextField.text!, forKey: "birthday")

        presenter?.checkUserData(userData: userData)
    }


    @objc private func cancelSaveUser() {
        presenter?.coordinator?.callback(nil)

    }
    
}

// MARK: - top buttons

extension UserDataViewController {

    private func addRightTopButton() {
        let buttonRight = UIBarButtonItem(image: UIImage(systemName: "checkmark")?.withTintColor(UIColor(.orange)!,
                                                                                            renderingMode: .alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(saveUserData))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = buttonRight
        let buttonLeft = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(UIColor(.orange)!,
                                                                                            renderingMode: .alwaysOriginal),
                                         style: .done,
                                         target: self,
                                         action: #selector(cancelSaveUser))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = buttonLeft


    }
}

// MARK: - UITextFieldDelegate
extension UserDataViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if birthdayTextField.isEditing == true {
            guard let text = textField.text else { return false}
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = String.formatPhoneNumber(number: newString, mask: "__.__.____")
            return false
        }
        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }


}
