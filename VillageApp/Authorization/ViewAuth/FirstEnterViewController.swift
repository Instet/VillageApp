//
//  FirstEnterViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 04.11.2022.
//

import UIKit

final class FirstEnterViewController: UIViewController, ViewAuthorisationProtocol {
    
    var presenter: AuthorisationPresenterProtocol?
    var coordinator: CoordinatorProtocol?

    private let viewElements: ViewElements = ViewElements.shared

    private lazy var image = viewElements.getAssetsImage(.launch)

    private lazy var registationButton: UIButton = {
        let button = viewElements.getButton(name: .registrationString)
        button.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
        return button
    }()

    private lazy var logInButton: UIButton = {
        let button = viewElements.getButton(name: .hasAccountString,
                                            textColor: .createColor(lightMode: .darkText, darkMode: .lightText))
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
        return button
    }()


    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubviews(image,
                         registationButton,
                         logInButton)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topIndentFive),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: view.frame.width - Constants.totalIndent),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),

            registationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            registationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.bigLeadingIndent),
            registationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.bigTrailingIndent
                                                       ),
            registationButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Constants.topIndentFive),
            registationButton.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            logInButton.topAnchor.constraint(equalTo: registationButton.bottomAnchor, constant: Constants.topIndentFour),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    @objc private func registrationAction() {
        coordinator?.regView()
        UserDefaults.standard.set(false, forKey: "hasAccount")

    }

    @objc private func logInAction() {
        coordinator?.logInView()
        UserDefaults.standard.set(true, forKey: "hasAccount")

    }



}

