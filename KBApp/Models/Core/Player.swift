//
//  Player.swift
//  KBApp
//
//  Created by Sam Richard on 1/31/23.
//

import Foundation

struct Player: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    var score: Int
}
