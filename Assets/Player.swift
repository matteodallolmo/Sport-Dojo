//
//  Player.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/9/24.
//

import Foundation

struct Player: Identifiable, Hashable {
    let name: String
    let notes: String
    let age: Int
    let level: String
    let id: String
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}
