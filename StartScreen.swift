//
//  ContentView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/20/23.
//

import SwiftUI

struct StartScreen: View {
    
    @StateObject var user = User()
    @StateObject var storeManager: EventStoreManager = EventStoreManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: [.black, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .edgesIgnoringSafeArea(.all)
                    .saturation(1.2)
                
                VStack {
                    Spacer()
                    
                    Image("LoadingScreenLogo")
                        .scaleEffect(1.2)
                        .padding()
                    
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 20) {
                        
                        Text("By tapping ‘Sign in’ you agree to our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("CREATE ACCOUNT")
                                .padding()
                                .font(.headline)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(40)
                                .foregroundColor(.teal)
                        }
                        
                        NavigationLink {
                            SignInView()
                        } label: {
                            Text("SIGN IN")
                                .padding()
                                .font(.headline)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 40)
                                    .stroke(.white, lineWidth: 3))
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }.padding(.horizontal)
            }
        }//nav stack
        .navigationBarBackButtonHidden(true)
        .environmentObject(user)
        .environmentObject(storeManager)
    }
}

#Preview {
    StartScreen()
}
