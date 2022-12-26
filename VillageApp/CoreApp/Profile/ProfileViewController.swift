//
//  ProfileViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

class ProfileViewController: UIViewController, ViewAppProtocol {
    
    var presenter: AppPresenterProtocol?
    var coordinator: ProfileCoordinator?
    var user: User
    var postData = [String : Any]()
    var array: [Post]?
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(.mainColor)
        indicator.style = .large
        indicator.startAnimating()
        return indicator
    }()
    
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String(describing: ProfileTableViewCell.self))
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
        tableView.register(PostHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: PostHeaderView.self))
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.backgroundColor = .systemBackground
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updatePost), for: .valueChanged)

        return tableView
    }()
    
    // MARK: - Init
    
    init(presenter: AppPresenterProtocol?,
         coordinator: ProfileCoordinator?,
         user: User) {
        self.presenter = presenter
        self.coordinator = coordinator
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getImage()
        profileTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        profileTableView.delegate = self
        profileTableView.dataSource = self
        presenter?.delegate = self
        setupLayout()
        
        presenter?.getPostForUser(user: user, completion: { [weak self] posts in
            guard let self = self else { return }
            self.array = posts.sorted(by: {$0.dateCreated > $1.dateCreated })
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        })

    }



    private func setupLayout() {

        let barButton = UIBarButtonItem(title: StringKey.exitString.localizedString(),
                                        style: .plain,
                                        target: self,
                                        action: #selector(exitProfile))
        barButton.tintColor = UIColor(.mainColor)
        navigationItem.rightBarButtonItem = barButton

        view.addSubviews(profileTableView, activityIndicator)

        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func exitProfile() {
        presenter?.exitProfile()
    }

    @objc private func updatePost() {
        presenter?.getPostForUser(user: user, completion: { [weak self] posts in
            guard let self = self else { return }
            self.array = posts.sorted(by: {$0.dateCreated > $1.dateCreated })
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
                self.profileTableView.refreshControl?.endRefreshing()
            }
        })

    }

}


// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 2 else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: PostHeaderView.self)) as? PostHeaderView else { return nil}
        header.coordinator = coordinator
        header.presenter = presenter
        header.user = user
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 2 else { return 0 }
        return 40
    }

}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return array?.count ?? 0
        } else {
            return 1
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let profileCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self)) as? ProfileTableViewCell else { return UITableViewCell() }

            profileCell.configUserData(user: user)

            profileCell.callback = {
                tableView.reloadData()
            }

            return profileCell

        } else if indexPath.section == 1 {

            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self)) as? PhotosTableViewCell else { return UITableViewCell() }
            photoCell.coordinator = coordinator
            photoCell.presenter = presenter
            photoCell.configViewCell(photos: presenter?.photos)
            return photoCell
        } else if indexPath.section == 2 {

            guard let postCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
            postCell.arrayPosts = array ?? []
            postCell.coordinator = coordinator
            postCell.presenter = presenter
            postCell.cellIndex = indexPath.row
            postCell.deletePostButton.isHidden = false
            postCell.addInNoteButton.isHidden = true
            postCell.configCell(userPost: array![indexPath.row])
            postCell.callback = { [weak self] in
                guard let self = self else { return }
                self.didUpdatePost()
            }
            return postCell
        }
        return UITableViewCell()
    }

}


// MARK: - AppPresenterDelegate

extension ProfileViewController: AppPresenterDelegate {

    func didUpdatePost() {
        activityIndicator.startAnimating()
        presenter?.getPostForUser(user: user, completion: {  [weak self] posts in
            guard let self = self else { return }
            self.array = posts.sorted(by: {$0.dateCreated > $1.dateCreated })
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        })
    }

}

