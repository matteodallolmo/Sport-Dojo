//
//  DashboardView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 3/8/24.
//

import SwiftUI

struct DashboardView: View {
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
                
                Spacer()
                
                if(subviewSelection == "SQUADS") {
                    SquadsView()
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

#Preview {
    DashboardView()
}
