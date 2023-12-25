//
//  ContentView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/20/23.
//

import SwiftUI

struct HomeScreen: View {
    
    var body: some View {
        
        @StateObject var user = User()
        
        NavigationStack {
    GeometryReader { geometry in
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.black, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .edgesIgnoringSafeArea(.all)
                .saturation(1.2)
            
            VStack {
                Image("LOGO")
                    .resizable()
                    .frame(width: geometry.size.width/1.6, height: geometry.size.width/2.8)
                
                VStack(spacing: 12) {
                    
                    Text("By tapping ‘Sign in’ you agree to our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .frame(width: geometry.size.width * 0.9)
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("CREATE ACCOUNT")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/15)
                            .background(.white)
                            .cornerRadius(40)
                            .foregroundColor(.teal)
                    }
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("SIGN IN")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/15)
                            .background(RoundedRectangle(cornerRadius: 40)
                                .stroke(.white, lineWidth: 3))
                            .foregroundColor(Color.white)
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }.position(x: geometry.size.width / 2, y: geometry.size.height/1.5)
        }
    }
        }//nav stack
        .navigationBarBackButtonHidden(true)
        .environmentObject(user)
    }
}

#Preview {
    HomeScreen()
}
