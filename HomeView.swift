//
//  HomeView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storeManager: EventStoreManager
    @State var isActive = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(width: 300, height: 70)
                    VStack(alignment: .leading) {
                        Text("My Course")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                }
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(width: 300, height: 70)
                    
                    Text("My Squads")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .padding(10)
                    
                }
                
                Button(action: {
                    isActive = true;
                }, label: {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .frame(width: 300, height: 70)
                        
                        Text("My Calendar")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding(10)
                        
                    }
                })
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(width: 300, height: 70)
                    
                    Text("Notifications")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .padding(10)
                    
                }
            }
        }
        .navigationTitle("Home")
        .navigationDestination(isPresented: $isActive) {
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
