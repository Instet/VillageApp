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


    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "AppModel")
        persistentContainer.loadPersistentStores { persisten, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer
    }()

    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()


    func savePost(index: Int, postData: [Post]) {
        let fetchRequest = PostModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "post == %@", postData[index].post )
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
                    favoritPost.author = postData[index].author
                    favoritPost.post = postData[index].post
                    favoritPost.userPhone = postData[index].userPhone
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
