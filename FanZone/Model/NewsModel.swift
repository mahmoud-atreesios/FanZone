//
//  NewsModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 07/02/2024.
//

import Foundation

struct NewsModel: Codable {
    let url: String?
    let title: String?
    let newsImg: String?
    let shortDesc: String?
    let modifiedTitle: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case url, title
        case newsImg = "news_img"
        case shortDesc = "short_desc"
        case modifiedTitle = "modifiedTitle3"
        case img = "img"
    }
}

typealias NewsModels = [NewsModel]
