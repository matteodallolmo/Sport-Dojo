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
    
    var squadIndex: Int
    
    var body: some View {
        NavigationStack {
            if user.squads[squadIndex].players.isEmpty {
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
                    
                    List(user.squads[squadIndex].players) { player in
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
        }
        .navigationTitle(user.squads[squadIndex].name)
        .sheet(isPresented: $presentNewPlayerView, content: {
            AddPlayerView(squadIndex: squadIndex)
                .padding()
        })
    }
}

struct AddPlayerView: View {
    @EnvironmentObject var user: User
    
    @State var name: String = ""
    @State var age: Int = 0
    @State var level: String = "Beginner"
    @State var notes: String = ""
    @State var showError = false
    
    private let errorMessageDuration: TimeInterval = 3 // Duration in seconds
    private let levels = ["Beginner", "Intermediate", "Advanced"]
    private let ageRange = 1...25
    
    var squadIndex: Int
    
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
                if(showError) {
                    Text("Please enter values for Name, Age, and Level")
                        .foregroundStyle(.red)
                }
                
                Button {
                    Task {
                        if(name != "" && age != 0 && level != "") {
                            await addPlayer(name: name, notes: notes, level: level, age: age)
                        }
                        else {
                            showError = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + errorMessageDuration) {
                                    showError = false
                            }
                            print("empty fields")
                            print("name: "+name)
                            print("notes: "+notes)
                            print("age: \(age)")
                            print("level: "+level)
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
            }
        }
        .navigationTitle("Add Player")
    }
    
    func addPlayer(name: String, notes: String, level: String, age: Int) async {
        do {
            let database = Firestore.firestore()
            let docID = try await database.collection("users").document(user.userDocID).collection("squads").document(user.squads[squadIndex].id).collection("players").addDocument(data: ["name" : name, "notes" : notes, "level" : level, "age" : age]).documentID
            user.squads[squadIndex].players.append(Player(name: name, notes: notes, age: age, level: level, id: docID))
        } catch {
            print("Error creating new squad")
        }
    }
}
