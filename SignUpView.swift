//
//  SignUpView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/20/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var username = ""
    @State var birthdate = Date()
    @State var isActive = false
    @State var firebaseUID = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height/9) {
                    VStack(spacing: geometry.size.height/16) {
                        HStack {
                            NavigationLink {
                                HomeScreen()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color.black)
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                SignInView()
                            } label: {
                                Text("Sign In")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.black)
                            }
                        }.frame(width: geometry.size.width * 0.85)
                        
                        Text("CREATE ACCOUNT")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                    }
                    
                        
                    VStack(spacing: 20) {
                        TextField("Username", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                        
                        DatePicker("Birth Date", selection: $birthdate, displayedComponents: .date)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                            .foregroundColor(.gray)
                        
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        
                        TextField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                        
                        Button(action: {
                            firebaseUID = signUpWithEmail(username: username, email: email, password: password, birthdate: birthdate)
                            if(firebaseUID != "") {
                                isActive = true
                            }
                        }, label: {
                            Text("CREATE ACCOUNT")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height/15)
                                .background(LinearGradient(colors: [.cyan, .green], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .saturation(0.8)
                        })
                        
                        Text("or continue with")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 35) {
                            
                            Button(action: {
                                //SIGN IN WITH FACEBOOK
                            }, label: {
                                Image("Facebook")
                                    .frame(width: geometry.size.width/5, height: geometry.size.height/12)
                                    .background(RoundedRectangle(cornerRadius: 15)
                                        .stroke(.gray.opacity(0.8), lineWidth: 1))
                            })
                            
                            Button(action: {
                                firebaseUID = signUpWithGoogle()
                                if(firebaseUID != "") {
                                    isActive = true
                                }
                            }, label: {
                                Image("Google")
                                    .frame(width: geometry.size.width/5, height: geometry.size.height/12)
                                    .background(RoundedRectangle(cornerRadius: 15)
                                        .stroke(.gray.opacity(0.8), lineWidth: 1))
                            })
                            
                            Button(action: {
                                //SIGN IN WITH APPLE
                            }, label: {
                                Image("Apple")
                                    .frame(width: geometry.size.width/5, height: geometry.size.height/12)
                                    .background(RoundedRectangle(cornerRadius: 15)
                                        .stroke(.gray.opacity(0.8), lineWidth: 1))
                            })
                        }
                    }
                }.position(x: geometry.size.width / 2, y: geometry.size.height/2.2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isActive) {
            HomeScreen()
        }
    }
}

extension SignUpView {
    
    func signUpWithEmail(username: String, email: String, password: String, birthdate: Date) -> String {
        var firebaseUID = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            if(err != nil)
            {
                print(err!.localizedDescription)
            }
            else if(result != nil)
            {
                let database = Firestore.firestore()
                database.collection("users").addDocument(data: ["username":username, "email":email, "password":password, "birthdate":birthdate,  "uid":result!.user.uid]) { (error) in
                    if(error != nil)
                    {
                        print("Account made successfully, but user data couldn't be saved")
                    }
                    else {
                        firebaseUID = result!.user.uid
                    }
                }
            }
        }
        
        return firebaseUID
    }
    
    func signUpWithGoogle() -> String {
        var firebaseUID = ""
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            print("There is no root vc")
            return firebaseUID
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else if(result != nil) {
                let user = result!.user
                let idTokenString = user.idToken?.tokenString
                let accessTokenString = user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idTokenString!, accessToken: accessTokenString)
                
                Auth.auth().signIn(with: credential) { result, error in
                    if(error != nil) {
                        print(error!.localizedDescription)
                    }
                    else if(result != nil) {
                        let firebaseUser = result!.user
                        firebaseUID = firebaseUser.uid
                    }
                }
            }
        }
        
        return firebaseUID
    }
}

#Preview {
    SignUpView()
}
