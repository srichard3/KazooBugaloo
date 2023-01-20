//
//  Playlist.swift
//  KBApp
//
//  Created by Sam Richard on 1/6/23.
//

import Foundation

struct Playlist: Codable, Identifiable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
