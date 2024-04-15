//
//  User.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import Foundation

class User : ObservableObject {
    @Published var uid: String = ""
    @Published var userDocID: String = ""
    @Published var tutorialCompleted = false
    @Published var birthdate: Date? = nil
    @Published var username: String = ""
    @Published var password: String? = nil
    @Published var email: String = ""
    @Published var squads: [Squad] = []
    
    func getSquad(id: String) -> Squad? {
        return squads.first { $0.id == id }
    }
    
    func getSquadIndex(id: String) -> Int? {
        return squads.firstIndex { $0.id == id }
    }
    
    func setSquad(id: String, squad: Squad) {
        if let index = getSquadIndex(id: id) {
            squads[index] = squad
        }
    }
}
