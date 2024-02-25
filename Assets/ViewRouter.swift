//
//  ViewRouter.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import Foundation

class ViewRouter : ObservableObject {
    @Published var currentView : String = "home"
    @Published var previousView: String = ""
}
