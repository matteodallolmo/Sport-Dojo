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

    @State var presentNewSquadView = false
    @State var editMode: EditMode = .inactive
    @State var selection: Set<Squad> = []
    
    var body: some View {
        VStack {
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
                    
                    List(user.squads, id: \.self, selection: $selection) { squad in
                        NavigationLink {
                            SquadDetailView(squadID: squad.id)
                                .task {
                                    await fetchPlayers(squadID: squad.id)
                                }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(squad.name)
                                    .fontWeight(.semibold)
                                Text(squad.notes)
                                    .font(.footnote)
                            }
                        }
                    }
                    .toolbar(content: toolbarContent)
                    .environment(\.editMode, $editMode)
                }
            }
            
            Button {
                presentNewSquadView = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundStyle(.blue)
                    
                    Text("Create new squad")
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        .sheet(isPresented: $presentNewSquadView, content: {
            AddSquadView()
                .padding()
        })
    }
}

extension SquadListView {
    func fetchPlayers(squadID: String) async {
        guard var squad = user.getSquad(id: squadID) else {
            print("Squad not found")
            return
        }

        do {
            let database = Firestore.firestore()
            let playersDoc = try await database.collection("users").document(user.userDocID).collection("squads").document(squadID).collection("players").getDocuments().documents
            for player in playersDoc {
                let playerData = player.data()
                if !squad.players.contains(where: { $0.id == player.documentID }) {
                    squad.players.append(Player(
                        name: playerData["name"] as! String,
                        notes: playerData["notes"] as! String,
                        age: playerData["age"] as! Int,
                        level: playerData["level"] as! String,
                        id: player.documentID))
                }
            }
            
            user.setSquad(id: squadID, squad: squad)
        } catch {
            print("There was an error fetching your players")
        }
    }
    
    func fetchSquads() async {
        do {
            let database = Firestore.firestore()
            let squadDoc = try await database.collection("users").document(user.userDocID).collection("squads").getDocuments().documents
            for squad in squadDoc {
                let squadData = squad.data()
                if !user.squads.contains(where: { $0.id == squad.documentID }) {
                    user.squads.append(Squad(
                        name: squadData["name"] as! String,
                        id: squad.documentID,
                        notes: squadData["notes"] as! String))
                }
            }
        } catch {
            print("There was an error fetching your squads")
        }
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
                    removeSquads(squads: Array(selection))
                }) {
                    Text("Delete")
                }
                .disabled(selection.isEmpty)
            }
        }
    }
    
    func removeSquads(squads: [Squad]) {
        Task {
            do {
                let database = Firestore.firestore()
                for squad in squads {
                    try await database.collection("users").document(user.userDocID).collection("squads").document(squad.id).delete()
                    user.squads.removeAll { squad2 in
                        squad == squad2
                    }
                }
                selection.removeAll()
            } catch {
                print("Failed removing players")
            }
        }
    }
}

struct AddSquadView: View {
    @EnvironmentObject var user: User
    
    @State var name: String = ""
    @State var notes: String = ""
    @State var players: [Player] = []
    @State var showError = false
    @State var showSuccess = false
    
    private let messageDuration: TimeInterval = 2.5 // Duration in seconds
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Name", text: $name)
                    
                    TextField("Notes", text: $notes)
                        .frame(minHeight: 100)
                }
                
                if showError || showSuccess {
                    Text(showError ? "Please enter values for Name and Notes" : "Successfully added squad")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .foregroundColor(showError ? .red : .green)
                        .padding(15)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.8)))
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + messageDuration) {
                                showError = false
                                showSuccess = false
                            }
                        }
                }
            }
            
            Button {
                Task {
                    if(name != "" && notes != "") {
                        await addSquad(name: name, notes: notes)
                        showSuccess = true
                        name = ""
                        notes = ""
                    }
                    else {
                        showError = true
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundStyle(.blue)

                    Text("Add new squad")
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        .navigationTitle("Add Squad")
    }
    
    func addSquad(name: String, notes: String) async {
        do {
            let database = Firestore.firestore()
            let docID = try await database.collection("users").document(user.userDocID).collection("squads").addDocument(data: ["name" : name, "notes" : notes]).documentID
            user.squads.append(Squad(name: name, id: docID, notes: notes, players: []))
        } catch {
            print("Error creating new squad")
        }
    }
}
