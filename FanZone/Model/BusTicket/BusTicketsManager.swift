//
//  BusTicketsManager.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 13/04/2024.
//

import Foundation

class BusTicketsManager{
    static let shared = BusTicketsManager()
    private init() {}

    var selectedBusTicketsModel: BusTicketsModel?
}
