//
//  SquadDetailView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/9/24.
//

import SwiftUI

struct SquadDetailView: View {
    @EnvironmentObject var user: User
    
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
                    
                    /*Button {
                        <#code#>
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 50)
                                .foregroundStyle(.blue)
                            
                            Text("Add Player")
                                .foregroundStyle(.white)
                        }
                    }*/
                }
            }
        }.navigationTitle(user.squads[squadIndex].name)
    }
}
