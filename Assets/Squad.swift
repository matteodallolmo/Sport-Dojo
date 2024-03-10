//
//  Team.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/9/24.
//

import Foundation

struct Squad: Identifiable {
    let name: String
    let id: String
    let size: Int
    let notes: String
    var players: [Player] = []
}
