//
//  Team.swift
//  KBApp
//
//  Created by Sam Richard on 1/31/23.
//

import Foundation

struct Team: Codable {
    let players: [Player]
    var score: Int
}
