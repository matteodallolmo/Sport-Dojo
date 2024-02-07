//
//  CalendarView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 2/6/24.
//

import SwiftUI
import EventKit

struct CalendarView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    func fetchCalendarEvents() {
        // Initialize the store.
        var store = EKEventStore()
        
        if(EKEventStore.authorizationStatus(for: .event) != .fullAccess) {
            // Request access to reminders.
            store.requestFullAccessToReminders { granted, error in
                // Handle the response to the request.
            }
        }
    }
}

#Preview {
    CalendarView()
}
