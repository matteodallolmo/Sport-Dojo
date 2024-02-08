/*
Abstract:
Manages reading and writing data from the event store.
*/

import EventKit

actor EventDataStore {
    let eventStore: EKEventStore
            
    init() {
        self.eventStore = EKEventStore()
    }
    
    var isFullAccessAuthorized: Bool {
        if #available(iOS 17.0, *) {
            EKEventStore.authorizationStatus(for: .event) == .fullAccess
        } else {
            // Fall back on earlier versions.
            EKEventStore.authorizationStatus(for: .event) == .authorized
        }
    }

    /// Prompts the user for full-access authorization to Calendar.
    private func requestFullAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            Task.detached(operation: {
                return try await self.eventStore.requestFullAccessToEvents()
            })
        } else {
            // Fall back on earlier versions.
            return try await eventStore.requestAccess(to: .event)
        }
        return false;
    }
    
    /// Verifies the authorization status for the app.
    func verifyAuthorizationStatus() async throws -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            return try await requestFullAccess()
        case .restricted:
            throw EventStoreError.restricted
        case .denied:
            throw EventStoreError.denied
        case .fullAccess:
            return true
        case .writeOnly:
            throw EventStoreError.upgrade
        @unknown default:
            throw EventStoreError.unknown
        }
    }
    
    /// Fetches all events occuring within a month in all the user's calendars.
    func fetchEvents() -> [EKEvent] {
        guard isFullAccessAuthorized else { return [] }
        let secondsInADay: TimeInterval = 60 * 60 * 24
        let thirtyDaysInSeconds: TimeInterval = 30 * secondsInADay
        let start = Date.now
        let end = start.advanced(by: thirtyDaysInSeconds)
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        let sortedEvents = eventStore.events(matching: predicate).sorted { (event1, event2) -> Bool in
            return event1.startDate < event2.startDate
        }
        return sortedEvents
    }
    
    /// Removes an event.
    private func removeEvent(_ event: EKEvent) throws {
        try self.eventStore.remove(event, span: .thisEvent, commit: false)
    }
    
    /// Batches all the remove operations.
    func removeEvents(_ events: [EKEvent]) throws {
        do {
            try events.forEach { event in
                try removeEvent(event)
            }
            try eventStore.commit()
         } catch {
             eventStore.reset()
             throw error
         }
    }
}
