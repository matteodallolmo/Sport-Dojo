//
//  ViewController.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct ViewController: View {
    
    @ObservedObject var viewRouter = ViewRouter()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if(viewRouter.currentView == "home")
                {
                    HomeView()
                    
                    Spacer()
                    
                    TabBarView(viewRouter: viewRouter)
                }
                else if(viewRouter.currentView == "dash") {
                    Text("Dashboard")
                    
                    Spacer()
                    
                    TabBarView(viewRouter: viewRouter)
                }
                else if(viewRouter.currentView == "learn") {
                    Text("Learning Module")
                    
                    Spacer()
                    
                    TabBarView(viewRouter: viewRouter)
                }
                else if(viewRouter.currentView == "network") {
                    Text("Network")
                    
                    Spacer()
                    
                    TabBarView(viewRouter: viewRouter)
                }
                else {
                    Text("Profile")
                    
                    Spacer()
                    
                    TabBarView(viewRouter: viewRouter)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ViewController()
}
