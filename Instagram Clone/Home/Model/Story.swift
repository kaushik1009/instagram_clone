//
//  Story.swift
//  Instagram Clone
//
//  Created by kaushik on 08/01/24.
//

import Foundation

struct Story: Codable {
    let stories: [StoryData]
}

struct StoryData: Codable {
    let storyOwner: String
    let imageUrl: String
    let videoUrl: String
    let profileImageUrl: String
    let isOpened: Bool

    enum CodingKeys: String, CodingKey {
        case storyOwner, isOpened
        case imageUrl, profileImageUrl, videoUrl
    }
}
