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
                else {
                    Spacer()
                    
                    TabBarView(viewRouter: viewRouter)
                }
                /*else if(self.viewRouter.currentView == "log")
                 {
                 LogView()
                 
                 Spacer()
                 
                 TabBarView(viewRouter: self.viewRouter)
                 .edgesIgnoringSafeArea(.bottom)
                 }
                 else if(self.viewRouter.currentView == "addIncome")
                 {
                 AddIncomeView(viewRouter: self.viewRouter, geometry: geometry)
                 }
                 else
                 {
                 AddExpenseView(viewRouter: self.viewRouter, geometry: geometry)
                 }*/
            }
        }
    }
}

#Preview {
    ViewController()
}
