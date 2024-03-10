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
    
    @State var password = ""
    @State var confirmPassword = ""
    @State var username = ""
    @State var birthdate = Date()
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Edit Profile")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
        
            TextField("Name", text: $username)
                .textFieldStyle(.roundedBorder)
            
            if(user.password != nil) {//means they are a email/pass acc
                DatePicker("Birth Date", selection: $birthdate, displayedComponents: .date)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                
                TextField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.blue)
                
                TextField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button(action: {
                Task {
                    if(password == confirmPassword) {
                        if(user.password != nil) { //means they are a email/pass acc
                            await updateRegularProfile(username: username, password: password, birthdate: birthdate)
                        }
                        else {
                            await updateGoogleProfile(username: username)
                        }
                    }
                    else {
                        print("Passwords don't match")
                    }
                }
            }, label: {
                Text("UPDATE PROFILE")
                    .padding()
                    .font(.headline)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.cyan, .green], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .saturation(0.8)
            })
        }
        .padding(.horizontal)
        .navigationTitle("Profile")
    }
    
    func updateRegularProfile(username: String, password: String, birthdate: Date) async {
        do {
            let database = Firestore.firestore()
            let document = database.collection("users").document(user.userDocID)
            
            if(!isEmpty(field: username)) {
                user.username = username
                try await document.setData(["username":username], merge: true)
            }
            if(!isEmpty(field: password)) {
                user.password = password
                try await Auth.auth().currentUser!.updatePassword(to: password)
                try await document.setData(["password":password], merge: true)
            }
            if(!isEmpty(field: birthdate)) {
                user.birthdate = birthdate
                try await document.setData(["birthdate":birthdate], merge: true)
            }
        } catch {
            print("There was an error updating your account")
        }
    }
    
    func updateGoogleProfile(username: String) async {
        user.username = username
        do {
            let database = Firestore.firestore()
            try await database.collection("users").document(user.userDocID).setData(["username":username], merge: true)
        } catch {
            print("There was an error updating your account")
        }
    }
    
    func isEmpty(field: Any) -> Bool {
        if(field is String) {
            return field as! String == ""
        }
        if(field is Date) {
            return field as! Date == Date()
        }
        return false
    }
}
