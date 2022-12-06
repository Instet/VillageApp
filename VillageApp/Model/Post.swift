//
//  Post.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 13.11.2022.
//

import Foundation

class Post {
    var post: String
    var author: String
    var userPhone: String
    var isFavorite: Bool
    var dateCreated: Int
    var postId: String

    init(postData: [String : Any]) {
        self.post = postData["post"] as? String ?? ""
        self.author = postData["author"] as? String ?? ""
        self.userPhone = postData["userPhone"] as? String ?? ""
        self.isFavorite = postData["isFavorite"] as? Bool ?? false
        self.dateCreated = postData["dateCreated"] as? Int ?? 0
        self.postId = postData["postId"] as? String ?? ""
    }
}
