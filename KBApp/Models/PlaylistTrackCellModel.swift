//
//  PlaylistTrackCellModel.swift
//  KBApp
//
//  Created by Sam Richard on 1/16/23.
//

import Foundation

struct PlaylistTrackCellModel: Identifiable, Equatable {    
    let name: String
    let id: String
    let artistName: String
    let artworkURL: URL?
}
