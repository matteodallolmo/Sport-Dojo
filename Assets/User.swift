//
//  User.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import Foundation

class User : ObservableObject {
    @Published var uid: String = ""
    @Published var tutorialCompleted = false
}
