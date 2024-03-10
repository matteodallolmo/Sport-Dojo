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

struct SquadsView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        if(user.squads.isEmpty) {
            Text("You don't have any teams right now")
                .font(.title)
                .multilineTextAlignment(.center)
                .opacity(0.55)
                .padding(.horizontal)
        }
        else {
            Text("Under progress")
        }
    }
}

extension SquadsView {
    func fetchSquads() async -> any View {
        do {
            let database = Firestore.firestore()
            let userDocQuery = try await database.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments().documents
            var userDocid = ""
            for doc in userDocQuery {
                userDocid = doc.documentID
            }
            let userDoc = database.collection("users").document(userDocid)
            let squadDocQuery = try await userDoc.collection("squads").getDocuments().documents
            var squadDocInfo: [[Any]] = []
            for squadDoc in squadDocQuery {
                let squadData = squadDoc.data()
                squadDocInfo.append([squadDoc.documentID, squadData["name"] as! String, squadData["size"] as! Int])
            }
            if(squadDocInfo.isEmpty) {
                return Text("You don't have any teams right now")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .opacity(0.55)
                    .padding(.horizontal)
            }
        } catch {
            print("There was an error fetching the squads")
            return Text("Goodbye")
        }
        
        
        
        return Text("Goodbye")
    }
}

#Preview {
    SquadsView()
}
