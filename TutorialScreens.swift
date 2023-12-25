//
//  TutorialScreens.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct TutorialScreen1: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationStack {
            Text(user.uid)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TutorialScreen1()
}
