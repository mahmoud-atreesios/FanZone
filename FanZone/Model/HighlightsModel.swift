//
//  HighlightsModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 09/02/2024.
//

import Foundation

struct HighlightsModel: Codable {
    let response: [HighlightResponse]
}

// MARK: - Response
struct HighlightResponse: Codable {
    let title, competition: String?
    let matchviewURL, competitionURL: String?
    let thumbnail: String?
    let videos: [Video]

    enum CodingKeys: String, CodingKey {
        case title, competition
        case matchviewURL = "matchviewUrl"
        case competitionURL = "competitionUrl"
        case thumbnail, videos
    }
}

// MARK: - Video
struct Video: Codable {
    let id, title, embed: String
}
