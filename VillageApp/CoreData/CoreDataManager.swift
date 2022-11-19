//
//  CoreDataManager.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 19.11.2022.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared: CoreDataManager = CoreDataManager()


    lazy var persistenContainer: NSPersistentContainer = {
        let persistenContainer = NSPersistentContainer(name: "AppModel")
        persistenContainer.loadPersistentStores { persisten, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        persistenContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        persistenContainer.viewContext.shouldDeleteInaccessibleFaults = true
        persistenContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistenContainer
    }()

    lazy var mainContext: NSManagedObjectContext = {
        return persistenContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        return persistenContainer.newBackgroundContext()
    }()


    func savePost(index: Int, postData: [[String : Any]]) {
        let fetchRequest = PostModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "post == %@", postData[index]["post"] as? String ?? "")
        do {
            let count = try backgroundContext.count(for: fetchRequest)
            if count > 0 {
                let fetchResult = try backgroundContext.fetch(fetchRequest) as [NSManagedObject]
                if let post = fetchResult.first as? PostModel {
                    backgroundContext.delete(post)
                }
            } else {
                backgroundContext.perform {
                    guard let favoritPost = NSEntityDescription.insertNewObject(forEntityName: "PostModel", into: self.backgroundContext) as? PostModel else { return }
                    favoritPost.author = postData[index]["author"] as? String
                    favoritPost.post = postData[index]["post"] as? String
                    favoritPost.userPhone = postData[index]["userPhone"] as? String
                    do{
                        try self.backgroundContext.save()
                    } catch let error as NSError {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

}
