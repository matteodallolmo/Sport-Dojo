//
//  DashboardView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/8/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore

struct DashboardView: View {
    @EnvironmentObject var user: User
    @State var subviewSelection = "SQUADS"
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        subviewSelection = "SQUADS"
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(lineWidth: subviewSelection == "SQUADS" ? 1.6 : 0.9)
                                        .foregroundColor(subviewSelection == "SQUADS" ? Color(red: 8/255, green: 73/255, blue: 30/255) : Color.black)
                                        .opacity(subviewSelection == "SQUADS" ? 1 : 0.6)
                                )
                                .frame(width: 100, height: 45)
                            Text("My Squads")
                                .font(.headline)
                                .foregroundColor(subviewSelection == "SQUADS" ? Color(red: 8/255, green: 73/255, blue: 30/255) : Color.black)
                                .opacity(subviewSelection == "SQUADS" ? 1 : 0.6)
                                .padding(10)
                        }
                    })
                    
                    Button(action: {
                        subviewSelection = "ANALYTICS"
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(lineWidth: subviewSelection == "ANALYTICS" ? 1.6 : 0.9)
                                        .foregroundColor(subviewSelection == "ANALYTICS" ? Color(red: 8/255, green: 73/255, blue: 30/255) : Color.black)
                                        .opacity(subviewSelection == "ANALYTICS" ? 1 : 0.6)
                                )
                                .frame(width: 100, height: 45)
                            Text("Analytics")
                                .font(.headline)
                                .foregroundColor(subviewSelection == "ANALYTICS" ? Color(red: 8/255, green: 73/255, blue: 30/255) : Color.black)
                                .opacity(subviewSelection == "ANALYTICS" ? 1 : 0.6)
                        }
                    })
                    
                    Button(action: {
                        subviewSelection = "MATERIALS"
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(lineWidth: subviewSelection == "MATERIALS" ? 1.6 : 0.9)
                                        .foregroundColor(subviewSelection == "MATERIALS" ? Color(red: 8/255, green: 73/255, blue: 30/255) : Color.black)
                                        .opacity(subviewSelection == "MATERIALS" ? 1 : 0.6)
                                )
                                .frame(width: 100, height: 45)
                            Text("Materials")
                                .font(.headline)
                                .foregroundColor(subviewSelection == "MATERIALS" ? Color(red: 8/255, green: 73/255, blue: 30/255) : Color.black)
                                .opacity(subviewSelection == "MATERIALS" ? 1 : 0.6)
                                .padding(10)
                        }
                    })
                }
                .padding(.top)
                
                Spacer()
                
                if(subviewSelection == "SQUADS") {
                    SquadListView()
                        .task {
                            await fetchSquads()
                        }
                }
                else if(subviewSelection == "ANALYTICS") {
                    Text("Analytics View")
                }
                else {
                    Text("Materials View")
                }
                
                Spacer()
            }
        }
        .navigationTitle("Dashboard")
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
}

extension DashboardView {
    func fetchSquads() async {
        do {
            let database = Firestore.firestore()
            let userDoc = database.collection("users").document(user.userDocID)
            let squadDocQuery = try await userDoc.collection("squads").getDocuments().documents
            for squadDoc in squadDocQuery {
                let squadData = squadDoc.data()
                if(!user.squads.contains(where: { squad1 in
                    squad1.id == squadDoc.documentID
                })) {
                    user.squads.append(Squad(
                        name: squadData["name"] as! String,
                        id: squadDoc.documentID,
                        size: squadData["size"] as! Int,
                        notes: squadData["notes"] as! String))
                }
            }
        } catch {
            print("There was an error fetching your squads")
        }
    }
}

#Preview {
    DashboardView()
}
