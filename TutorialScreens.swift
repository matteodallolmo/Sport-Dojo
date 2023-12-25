//
//  TutorialScreens.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct TutorialScreen1: View {
    var uid: String
    
    var body: some View {
        NavigationStack {
            Text(uid)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TutorialScreen1(uid: "uid")
}
