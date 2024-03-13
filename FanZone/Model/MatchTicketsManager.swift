//
//  MatchTicketsManager.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 10/03/2024.
//

import Foundation

class MatchTicketsManager{
    static let shared = MatchTicketsManager()
    private init() {}

    var selectedMatchTicketsModel: MatchTicketsModel?
}
