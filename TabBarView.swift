//
//  TabBarView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    //House image
                    Button(action: {
                        viewRouter.previousView = viewRouter.currentView
                        viewRouter.currentView = "home"
                    }, label: {
                        Image("Home")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(viewRouter.currentView == "home" ? .black : .gray)
                            .opacity(viewRouter.currentView == "home" ? 100 : 50)
                    })
                    
                    //Dashboard image
                    Button(action: {
                        viewRouter.previousView = viewRouter.currentView
                        viewRouter.currentView = "dash"
                    }, label: {
                        Image("Dashboard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(viewRouter.currentView == "dash" ? .black : .gray)
                            .opacity(viewRouter.currentView == "dash" ? 100 : 50)
                    })
                    
                    //Dashboard image
                    Button(action: {
                        viewRouter.previousView = viewRouter.currentView
                        viewRouter.currentView = "learn"
                    }, label: {
                        Image("Learning")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(viewRouter.currentView == "learn" ? .black : .gray)
                            .opacity(viewRouter.currentView == "learn" ? 100 : 50)
                    })
                    
                    //Dashboard image
                    Button(action: {
                        viewRouter.previousView = viewRouter.currentView
                        viewRouter.currentView = "network"
                    }, label: {
                        Image("Network")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(viewRouter.currentView == "network" ? .black : .gray)
                            .opacity(viewRouter.currentView == "network" ? 100 : 50)
                    })
                    
                    //Dashboard image
                    Button(action: {
                        viewRouter.previousView = viewRouter.currentView
                        viewRouter.currentView = "profile"
                    }, label: {
                        Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(viewRouter.currentView == "profile" ? .black : .gray)
                            .opacity(viewRouter.currentView == "profile" ? 100 : 50)
                    })
                }//HStack end
            }
        }
}//body end
}

#Preview {
    TabBarView(viewRouter: ViewRouter())
}
