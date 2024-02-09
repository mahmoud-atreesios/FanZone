//
//  NewsModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 09/02/2024.
//

import Foundation

struct NewsModel: Codable {
    let url: String?
    let title: String?
    let img: String?
    let shortDesc: String?

    enum CodingKeys: String, CodingKey {
        case url, title
        case img = "news_img"
        case shortDesc = "short_desc"
    }
}

typealias NewsModels = [NewsModel]
