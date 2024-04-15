//
//  Team.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/9/24.
//

import Foundation

struct Squad: Identifiable, Hashable {
    let name: String
    let id: String
    let notes: String
    var players: [Player] = []
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable
    static func ==(lhs: Squad, rhs: Squad) -> Bool {
        return lhs.id == rhs.id
    }
}
