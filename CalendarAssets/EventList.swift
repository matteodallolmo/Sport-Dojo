/*
Abstract:
A view to display and delete monthly events.
*/

import SwiftUI
import EventKit
import EventKitUI

struct EventList: View {
    @EnvironmentObject var storeManager: EventStoreManager
    @State private var shouldPresentError: Bool = false
    @State private var alertMessage: String?
    @State private var alertTitle: String?
    @State var selection: Set<EKEvent> = []
    @State var editMode: EditMode = .inactive
    @State var showEventEditViewController = false
    
    /*
        Displays a list of events that occur within this month in all the user's calendars. Removes an event from Calendar when the user deletes it
        from the list.
    */
    var body: some View {
            VStack {
                if storeManager.events.isEmpty {
                    MessageView(message: .events)
                } else {
                    List(selection: $selection) {
                        ForEach(storeManager.events, id: \.self) { event in
                            VStack(alignment: .leading, spacing: 7) {
                                Text(event.title)
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                HStack {
                                    Text(event.startDate, style: .date)
                                        .foregroundStyle(.primary)
                                        .font(.caption)
                                    Text("at")
                                        .foregroundStyle(.primary)
                                        .font(.caption)
                                    Text(event.startDate, style: .time)
                                        .foregroundStyle(.primary)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .toolbar(content: toolbarContent)
                    .environment(\.editMode, $editMode)
                }
                
                Spacer()
                
                Button(action: {
                    showEventEditViewController = true
                    
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300, height: 50)
                            .foregroundStyle(.blue)
                        
                        Text("Add Event")
                            .foregroundStyle(.white)
                    }
                })
            }
            .alertErrorMessage(message: alertMessage, title: alertTitle, isPresented: $shouldPresentError)
            .sheet(isPresented: $showEventEditViewController, onDismiss: {
                showEventEditViewController = false
            }, content: {
                EventEditViewController(eventStore: storeManager.store)
            })
    }
    
    /// Delete the selected event from Calendar.
    func removeEvents(_ events: [EKEvent]) {
        Task {
            do {
                try await storeManager.removeEvents(events)
                selection.removeAll()
            } catch {
                showError(error, title: "Delete failed.")
            }
        }
    }
    
    func showError(_ error: Error, title: String) {
        alertTitle = title
        alertMessage = error.localizedDescription
        shouldPresentError = true
    }
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                selection.removeAll()
                editMode = .inactive
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            if editMode == .active {
                Button(action: {
                    removeEvents(Array(selection))
                }) {
                    Text("Delete")
                }
                .disabled(selection.isEmpty)
            }
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
            .environmentObject(EventStoreManager())
    }
}
