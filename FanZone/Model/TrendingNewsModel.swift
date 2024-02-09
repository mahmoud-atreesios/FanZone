//
//  NewsModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 07/02/2024.
//

import Foundation

struct TrendingNewsModel: Codable {
    let url: String?
    let title: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case url, title
        case img = "img"
    }
}

typealias TrendingNewsModels = [TrendingNewsModel]
