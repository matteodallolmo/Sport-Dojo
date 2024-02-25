//
//  ProfileView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 2/24/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseCore
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var user: User
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var username = ""
    @State var birthdate = Date()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height/9) {
                VStack(spacing: geometry.size.height/16) {
                    Text("Edit Profile")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                }
                
                VStack(spacing: 20) {
                    TextField("Name", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                    
                    if(user.password != nil) {//means they are a email/pass acc
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                        
                        DatePicker("Birth Date", selection: $birthdate, displayedComponents: .date)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                            .foregroundColor(.gray)
                        
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                            .foregroundColor(.blue)
                        
                        TextField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                    }
                    
                    Button(action: {
                        Task {
                            if(password == confirmPassword) {
                                if(user.password != nil) { //means they are a email/pass acc
                                    await updateRegularProfile(username: username, email: email, password: password, birthdate: birthdate)
                                }
                            }
                            else {
                                print("Passwords don't match")
                            }
                        }
                    }, label: {
                        Text("UPDATE PROFILE")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/15)
                            .background(LinearGradient(colors: [.cyan, .green], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .saturation(0.8)
                    })
                }
            }
        }.navigationTitle("Profile")
    }
    
    func updateRegularProfile(username: String, email: String, password: String, birthdate: Date) {
        user.username = username
        user.email = email
        user.password = password
        user.birthdate = birthdate
        Task.init(operation: {
            do {
                try await Auth.auth().currentUser!.updateEmail(to: email)
                try await Auth.auth().currentUser!.updatePassword(to: password)
                let database = Firestore.firestore()
                let documents = try await database.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments().documents
                for doc in documents {
                    let docid = doc.documentID
                    try await database.collection("users").document(docid).setData(["username":username, "email":email, "password":password, "birthdate":birthdate], merge: true)
                }
            }
        })
    }
}
