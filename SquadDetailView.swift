//
//  SquadDetailView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/9/24.
//

import SwiftUI
import FirebaseFirestore

struct SquadDetailView: View {
    @EnvironmentObject var user: User
    
    @State private var presentNewPlayerView = false
    @State var editMode: EditMode = .inactive
    @State var selection: Set<Player> = []
    
    var squadID: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if user.getSquad(id: squadID)!.players.isEmpty {
                    Text("Your squad doesn't have any players right now")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .opacity(0.55)
                        .padding(.horizontal)
                } else {
                    VStack(alignment: .leading) {
                        Text("Players")
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .padding([.top, .horizontal])
                        List(user.getSquad(id: squadID)!.players, id: \.self, selection: $selection) { player in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(player.name)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(player.age)")
                                }
                                Text(player.level)
                                    .font(.footnote)
                                Text(player.notes)
                                    .font(.footnote)
                            }
                        }
                        .toolbar(content: toolbarContent)
                        .environment(\.editMode, $editMode)
                    }
                }
                
                Button {
                    presentNewPlayerView = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .foregroundStyle(.blue)
                        
                        Text("Create new player")
                            .foregroundStyle(.white)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(user.getSquad(id: squadID)!.name)
        .sheet(isPresented: $presentNewPlayerView, content: {
            AddPlayerView(squadID: squadID)
                .padding()
        })
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
                    removePlayers(players: Array(selection))
                }) {
                    Text("Delete")
                }
                .disabled(selection.isEmpty)
            }
        }
    }
    
    func removePlayers(players: [Player]) {
        Task {
            guard var squad = user.getSquad(id: squadID) else {
                print("Squad not found")
                return
            }
            
            do {
                let database = Firestore.firestore()
                for player in players {
                    try await database.collection("users").document(user.userDocID).collection("squads").document(user.getSquad(id: squadID)!.id).collection("players").document(player.id).delete()
                    squad.players.removeAll { player2 in
                        player == player2
                    }
                }
                user.setSquad(id: squadID, squad: squad)
                selection.removeAll()
            } catch {
                print("Failed removing players")
            }
        }
    }
}

struct AddPlayerView: View {
    @EnvironmentObject var user: User
    
    @State var name: String = ""
    @State var age: Int = 1
    @State var level: String = "Beginner"
    @State var notes: String = ""
    @State var showError = false
    @State var showSuccess = false
    
    private let messageDuration: TimeInterval = 2.5 // Duration in seconds
    private let levels = ["Beginner", "Intermediate", "Advanced"]
    private let ageRange = 1...25
    
    var squadID: String
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Name", text: $name)
                    
                    Picker("Level", selection: $level) {
                        ForEach(levels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    
                    Picker("Age", selection: $age) {
                        ForEach(ageRange, id: \.self) { age in
                            Text("\(age)")
                        }
                    }
                    
                    TextField("Notes", text: $notes)
                        .frame(minHeight: 100)
                }
                
                if showError || showSuccess {
                    Text(showError ? "Please enter values for Name, Age, and Level" : "Successfully added player")
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
                    if(name != "" && age != 0 && level != "") {
                        await addPlayer(name: name, notes: notes, level: level, age: age)
                        showSuccess = true
                        name = ""
                        notes = ""
                        age = 1
                        level = "Beginner"
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

                    Text("Add new player")
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        .navigationTitle("Add Player")
    }
    
    func addPlayer(name: String, notes: String, level: String, age: Int) async {
        guard var squad = user.getSquad(id: squadID) else {
            print("Squad not found")
            return
        }
        
        do {
            let database = Firestore.firestore()
            let docID = try await database.collection("users").document(user.userDocID).collection("squads").document(squadID).collection("players").addDocument(data: ["name" : name, "notes" : notes, "level" : level, "age" : age]).documentID
            squad.players.append(Player(name: name, notes: notes, age: age, level: level, id: docID))
            
            user.setSquad(id: squadID, squad: squad)
        } catch {
            print("Error creating new squad")
        }
    }
}
