//
//  AllTeamsModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 07/05/2024.
//

import Foundation

struct AllTeamsModel: Codable {
    let success: Int
    let result: [Teams]
}

// MARK: - Result
struct Teams: Codable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}
