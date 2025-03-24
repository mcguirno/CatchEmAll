//
//  Creature.swift
//  CatchEmAll
//
//  Created by Noah McGuire on 3/17/25.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}
