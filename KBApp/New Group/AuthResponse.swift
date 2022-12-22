//
//  AuthResponse.swift
//  KBApp
//
//  Created by Sam Richard on 12/21/22.
//

import Foundation

struct AuthRepsonse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
    let scope: String
    let token_type: String
}
