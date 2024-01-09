//
//  Post.swift
//  Instagram Clone
//
//  Created by kaushik on 28/12/23.
//

import Foundation

struct Post: Codable {
    let posts: [PostData]
}

struct PostData: Codable {
    let postOwner, caption: String
    let likes: Int
    let imageUrl: String
    let videoUrl: String
    let profileImageUrl: String
    let comments: [Comment]
    let timeStamp: String

    enum CodingKeys: String, CodingKey {
        case postOwner, caption, likes
        case imageUrl, profileImageUrl, videoUrl
        case comments, timeStamp
    }
}

struct Comment: Codable {
    let username, comment: String
}
