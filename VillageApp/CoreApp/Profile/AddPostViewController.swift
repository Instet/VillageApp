//
//  AddPostViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 14.11.2022.
//

import UIKit

class AddPostViewController: UIViewController, ViewAppProtocol {

    weak var presentor: AppPresenterProtocol?
    weak var coordinator: AppCoordinatorProtocol?
    var user: User?
    var userPost = [String : Any]()
    

    private lazy var savePostBotton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(UIColor(.mainColor), for: .normal)
        button.setTitleColor(.systemGray2, for: .disabled)
        button.addTarget(self, action: #selector(saveUserPost), for: .touchUpInside)
        return button
    }()

    private lazy var cancelBotton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(UIColor(.mainColor), for: .normal)
        button.addTarget(self, action: #selector(cancelSave), for: .touchUpInside)
        return button
    }()

    private lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.3
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.layer.borderColor = UIColor(.mainColor)?.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = .systemBackground
        return textView
    }()

    // MARK: - Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postTextView.becomeFirstResponder()
        savePostBotton.isEnabled = false
      
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        postTextView.delegate = self
        setupLayout()

    }

    
    private func setupLayout() {
        view.addSubviews(cancelBotton, savePostBotton, postTextView)

        NSLayoutConstraint.activate([

            cancelBotton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topIndentOne),
            cancelBotton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingIndent),
            cancelBotton.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            savePostBotton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topIndentOne),
            savePostBotton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.trailingIndent),
            savePostBotton.heightAnchor.constraint(equalToConstant: Constants.heightStandart),

            postTextView.topAnchor.constraint(equalTo: cancelBotton.bottomAnchor, constant: Constants.genderTop),
            postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingIndent),
            postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.trailingIndent),
            postTextView.heightAnchor.constraint(equalToConstant: 250)
        ])

    }



    @objc private func saveUserPost() {
        guard let user = user else { return }
        let author = user.name + " " + user.lastName
        let userPhone = user.phone
        guard let post = postTextView.text else { return }
        userPost.updateValue(post, forKey: "post")
        userPost.updateValue(author, forKey: "author")
        userPost.updateValue(userPhone, forKey: "userPhone")
        presentor?.addPost(userPost: userPost)
    }


    @objc private func cancelSave() {
        dismiss(animated: true)
    }

}



// MARK: - UITextFieldDelegate

extension AddPostViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if !postTextView.text.isEmpty {
            savePostBotton.isEnabled = true
        } else {
            savePostBotton.isEnabled = false
        }
    }
}



