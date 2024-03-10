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
                        .opacity(viewRouter.currentView == "home" ? 1 : 0.5)
                })
                //Learning image
                Button(action: {
                    viewRouter.previousView = viewRouter.currentView
                    viewRouter.currentView = "learn"
                }, label: {
                    Image("Learning")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(viewRouter.currentView == "learn" ? 1 : 0.5)
                })
                
                //Network image
                Button(action: {
                    viewRouter.previousView = viewRouter.currentView
                    viewRouter.currentView = "network"
                }, label: {
                    Image("Network")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(viewRouter.currentView == "network" ? 1 : 0.5)
                })
                
                //Profile image
                Button(action: {
                    viewRouter.previousView = viewRouter.currentView
                    viewRouter.currentView = "profile"
                }, label: {
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(viewRouter.currentView == "profile" ? 1 : 0.5)
                })
            }
            .padding(.bottom, 20)
            //HStack end
        }
}//body end
}

#Preview {
    TabBarView(viewRouter: ViewRouter())
}
