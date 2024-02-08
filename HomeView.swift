//
//  HomeView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storeManager: EventStoreManager
    
    var body: some View {
        VStack {
            CalendarView()
                .task {
                    await storeManager.listenForCalendarChanges()
                }
        }
    }
}

#Preview {
    HomeView()
}
