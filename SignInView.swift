//
//  SignInView.swift
//  Sport Dojo
//
//  Created by Matteo Dall'Olmo on 12/20/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    @State var isActive = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height/7) {
                    VStack(spacing: geometry.size.height/10) {
                        HStack {
                            NavigationLink {
                                HomeScreen()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color.black)
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("Create Account")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.black)
                            }
                        }.frame(width: geometry.size.width * 0.85)
                        
                        Text("SIGN IN")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                    }
                    
                        
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height/20)
                        
                        Button(action: {
                            isActive = true
                            signInWithEmail(email: email, password: password)
                        }, label: {
                            Text("SIGN IN")
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
                                signInWithGoogle()
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
                }.position(x: geometry.size.width / 2, y: geometry.size.height/2.75)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

func signInWithEmail(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        
        if error != nil {
            print(error?.localizedDescription ?? "")
        }
        else if(result != nil) {
            print(result!.user.email! as String)
        }
        else {
            print("result is nil")
        }
    }
}

func signInWithGoogle() {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
        fatalError("No client ID found")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootVC = window.rootViewController else {
        print("There is no root vc")
        return
    }
        
    GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
        if(error != nil) {
            print(error!.localizedDescription)
        }
        else if(result != nil) {
            let user = result!.user
            let googleUID = user.userID
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: googleUID!, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if(error != nil) {
                    print(error!.localizedDescription)
                }
                else if(result != nil) {
                    let firebaseUser = result!.user
                    let firebaseUID = firebaseUser.uid
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
