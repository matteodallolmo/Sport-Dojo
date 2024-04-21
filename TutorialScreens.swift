//
//  TutorialScreens.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/25/23.
//

import SwiftUI

struct TutorialScreen1: View {
    //@EnvironmentObject var user: User
    /*
     Need to add a "finishedTutorial" bool for every user that determines whether
     they see the tutorial at the beginning
     */
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Spacer()
                
                Text("Welcome to Sport Dojo!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 8/255, green: 73/255, blue: 30/255))
                
                Text("In Sport Dojo, we empower coaches and connect communities through sports. Let's embark on a journey of skill enhancement, inclusivity, and positive impact!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .lineSpacing(7)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                NavigationLink(destination: TutorialScreen2()) {
                    HStack {
                        Spacer()
                        
                        Text("Next")
                            .foregroundStyle(.black)
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.black)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Tutorial") // Set navigation title
            .navigationBarTitleDisplayMode(.inline) // Set title display mode
            .navigationBarItems(trailing: EmptyView()) // Hide navigation bar trailing items
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation view style
    }
}


struct TutorialScreen2: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Spacer()
                
                Text("Welcome to Sport Dojo!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 8/255, green: 73/255, blue: 30/255))
                
                Text("Unlock the 'Sport Dojo' certification by completing our video course, crafted in collaboration with football experts. Pass the final test and  become a certified coach ready to make a difference!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .lineSpacing(7)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                NavigationLink(destination: TutorialScreen2()) {
                    HStack {
                        Spacer()
                        
                        Text("Next")
                            .foregroundStyle(.black)
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.black)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Tutorial") // Set navigation title
            .navigationBarTitleDisplayMode(.inline) // Set title display mode
            .navigationBarItems(trailing: EmptyView()) // Hide navigation bar trailing items
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation view style
    }
}

struct TutorialScreen3: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Spacer()
                
                Text("Welcome to Sport Dojo!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 8/255, green: 73/255, blue: 30/255))
                
                Text("Join our network of coaches! Once certified, you'll be matched with local families seeking affordable sports activities for their children. \nYou'll gain free access to high-level tools for the continuous improvement of your players.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .lineSpacing(7)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                NavigationLink(destination: ViewController()) {
                    Text("START")
                        .padding(.vertical, 15)
                        .padding(.horizontal, 40)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .background(LinearGradient(colors: [.cyan, .green], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .saturation(0.8)
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Tutorial") // Set navigation title
            .navigationBarTitleDisplayMode(.inline) // Set title display mode
            .navigationBarItems(trailing: EmptyView()) // Hide navigation bar trailing items
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation view style
    }
}


#Preview {
    TutorialScreen3()
}

