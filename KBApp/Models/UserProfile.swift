//
//  UserProfile.swift
//  KBApp
//
//  Created by Sam Richard on 12/22/22.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
}
