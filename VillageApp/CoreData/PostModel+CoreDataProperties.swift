//
//  PostModel+CoreDataProperties.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 19.11.2022.
//
//

import Foundation
import CoreData


extension PostModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostModel> {
        return NSFetchRequest<PostModel>(entityName: "PostModel")
    }

    @NSManaged public var idUser: String?
    @NSManaged public var author: String?
    @NSManaged public var post: String?
    @NSManaged public var userPhone: String?

}

extension PostModel : Identifiable {

}
