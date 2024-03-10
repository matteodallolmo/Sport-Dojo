//
//  HomeView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var storeManager: EventStoreManager
    @State var calIsActive = false
    @State var dashIsActive = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                Text("Welcome "+user.username)
                    .foregroundColor(Color.black)
                    .font(.title)
                    .fontWeight(.bold)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(width: 300, height: 70)
                    Text("My Course")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .padding(10)
                }
                
                Button {
                    dashIsActive = true
                } label: {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .frame(width: 300, height: 70)
                        Text("Coaching Dashboard")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                }
                
                Button(action: {
                    calIsActive = true
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
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
        .navigationDestination(isPresented: $calIsActive) {
            CalendarView()
                .task {
                    await storeManager.listenForCalendarChanges()
                }
        }
        .navigationDestination(isPresented: $dashIsActive) {
            DashboardView()
                .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
    }
}



#Preview {
    HomeView()
}
