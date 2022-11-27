//
//  HomeViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit

class HomeViewController: UIViewController {

    var presentor: AppPresenterProtocol?
    var arrayAllPosts: [Post]?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(.mainColor)
        indicator.style = .medium
        indicator.startAnimating()
        return indicator
    }()

    private lazy var homeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.register(HomeHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: HomeHeaderView.self))
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Init
    init(presentor: AppPresenterProtocol?) {
        self.presentor = presentor
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentor?.getAllPost(completion: { posts in
            self.arrayAllPosts = posts
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
    }

    private func setupLayout() {
        self.title = "Главная"
        view.backgroundColor = .systemBackground

        view.addSubviews(homeTableView, activityIndicator)

        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }



}

//MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

}

//MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAllPosts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        postCell.arrayPosts = arrayAllPosts ?? []
        postCell.cellIndex = indexPath.row
        postCell.configCell(userPost: arrayAllPosts![postCell.cellIndex])
        return postCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: HomeHeaderView.self)) as? HomeHeaderView else { return nil }
        return header
    }

}
