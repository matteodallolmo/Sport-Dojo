//
//  SquadsView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/8/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore

struct SquadListView: View {
    @EnvironmentObject var user: User
    @State var newSquadName: String = ""
    
    var body: some View {
        if user.squads.isEmpty {
            Text("You don't have any teams right now")
                .font(.title)
                .multilineTextAlignment(.center)
                .opacity(0.55)
                .padding(.horizontal)
        } else {
            VStack() {
                HStack() {
                    Text("Squads")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .horizontal])
                    
                    Spacer()
                }
                
                List(0..<user.squads.count) { squadIndex in
                    NavigationLink {
                        SquadDetailView(squadIndex: squadIndex)
                            .task {
                                await fetchPlayers(squadIndex: squadIndex)
                            }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.squads[squadIndex].name)
                                .fontWeight(.semibold)
                            Text(user.squads[squadIndex].notes)
                                .font(.footnote)
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    TextField("New squad name", text: $newSquadName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Button {
                        Task {
                            if(newSquadName != "") {
                                await addSquad(name: newSquadName)
                            }
                            else {
                                print("Empty squad name")
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundStyle(.blue)

                            Text("Create new squad")
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(alignment: .center)
                .padding(.horizontal, 12)
                .padding(.top, 10)
            }
        }
    }
}

extension SquadListView {
    func fetchPlayers(squadIndex: Int) async {
        do {
            let database = Firestore.firestore()
            let playersDoc = try await database.collection("users").document(user.userDocID).collection("squads").document(user.squads[squadIndex].id).collection("players").getDocuments().documents
            for player in playersDoc {
                let playerData = player.data()
                if(!user.squads[squadIndex].players.contains(where: { player1 in
                    player1.id == player.documentID
                })) {
                    user.squads[squadIndex].players.append(Player(
                        name: playerData["name"] as! String,
                        notes: playerData["notes"] as! String,
                        age: playerData["age"] as! Int,
                        level: playerData["level"] as! String,
                        id: player.documentID))
                }
            }
        } catch {
            print("There was an error fetching your players")
        }
    }
    
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
    
    func addSquad(name: String) async {
        do {
            let database = Firestore.firestore()
            let docID = try await database.collection("users").document(user.userDocID).collection("squads")
                .addDocument(data: ["name" : name, "notes": "New Team", "size": 0]).documentID
            user.squads.append(Squad(name: name, id: docID, size: 0, notes: "New Team"))
            newSquadName = ""
        } catch {
            print("Error creating new squad")
        }
    }
}
