//
//  FavoritesViewController.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 06.11.2022.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, ViewAppProtocol {

    var presentor: AppPresenterProtocol?
    var coordinator: AppCoordinatorProtocol?
    private let coreData: CoreDataManager = CoreDataManager.shared
    private let viewElements: ViewElements = ViewElements.shared


    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var fetchResultController: NSFetchedResultsController<PostModel> = {
        let fetchRequest = PostModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "post", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let resultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: coreData.mainContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
        resultController.delegate = self
        return resultController
    }()

    // MARK: - Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoritPosts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        }

    }

    private func setupLayout() {
        self.title = "Избранное"
        view.backgroundColor = .systemBackground

        view.addSubviews(favoritesTableView)

        NSLayoutConstraint.activate([
            favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

    private func fetchFavoritPosts() {
        fetchResultController.fetchRequest.predicate = nil
        coreData.mainContext.perform {
            do {
                try self.fetchResultController.performFetch()

                self.favoritesTableView.reloadData()

            } catch let error as NSError {
                print(error.userInfo)

            }
        }
    }

}



 // MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                            title: nil ) { action, view, handler in
            let postDelete = self.fetchResultController.object(at: indexPath)
            self.coreData.mainContext.delete(postDelete)
            do {
                try self.coreData.mainContext.save()
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            handler(true)
        }

        deleteAction.image = UIImage(systemName: "trash")
        let swipeDelete = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeDelete
    }

}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fetchResultController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favoritPost = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        favoritPost.addInNoteButton.isHidden = true
        favoritPost.cellIndex = indexPath.row
        let fetchPost = fetchResultController.object(at: indexPath)
        var postData: [String : Any] = [:]
        postData.updateValue((fetchPost.author ?? "") as String, forKey: "author")
        postData.updateValue((fetchPost.post ?? "") as String, forKey: "post")
        favoritPost.configCell(userPost: postData)
        return favoritPost

    }

}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoritesTableView.beginUpdates()
    }


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { fallthrough }
            favoritesTableView.insertRows(at: [newIndexPath], with: .automatic)
            favoritesTableView.reloadData()
        case .delete:
            guard let indexPath = indexPath else { fallthrough }
            favoritesTableView.deleteRows(at: [indexPath], with: .automatic)
            favoritesTableView.reloadData()
        case .move:
            guard let indexPath = indexPath,
            let newIndexPath = newIndexPath else { fallthrough }
            favoritesTableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { fallthrough }
            favoritesTableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }



    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoritesTableView.endUpdates()
    }

}
