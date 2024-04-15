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
    @State var showError = false

    private let messageDuration: TimeInterval = 2.5 // Duration in seconds
    
    @EnvironmentObject var user: User
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                    StartScreen()
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
                        .foregroundColor(Color(red: 8/255, green: 73/255, blue: 30/255))
                }
            }
            
            Text("SIGN UP")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
            
            VStack {
                NavigationStack {
                    VStack {
                        TextField("Name", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical)
                        
                        DatePicker("Birth Date", selection: $birthdate, displayedComponents: .date)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                        
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical)
                        
                        TextField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical)
                    }
                    .padding(.horizontal)
                    
                    Text("or continue with")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 35) {
                        
                        Button(action: {
                            //SIGN IN WITH FACEBOOK
                        }, label: {
                            Image("Facebook")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray.opacity(0.8), lineWidth: 1))
                        })
                        
                        Button(action: {
                            Task {
                                await signUpWithGoogle()
                            }
                        }, label: {
                            Image("Google")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray.opacity(0.8), lineWidth: 1))
                        })
                        
                        Button(action: {
                            //SIGN IN WITH APPLE
                        }, label: {
                            Image("Apple")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray.opacity(0.8), lineWidth: 1))
                        })
                    }.padding(.horizontal)
                    
                    if(showError) {
                        Text("Failed to sign up")
                            .foregroundStyle(.red)
                            .padding()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + messageDuration) {
                                    showError = false
                                }
                            }
                    }
                }//nav stack
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $isActive) {
                    if(!user.tutorialCompleted) {
                        TutorialScreen1()
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            
            Button(action: {
                Task {
                    if(password == confirmPassword) {
                        await signUpWithEmail(username: username, email: email, password: password, birthdate: birthdate)
                        if(user.uid != "") {
                            isActive = true
                        }
                    }
                    else {
                        print("Passwords don't match")
                    }
                }
            }, label: {
                Text("CREATE ACCOUNT")
                    .padding()
                    .font(.headline)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.cyan, .green], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .saturation(0.8)
            })
        }.padding()
    }//body
}

extension SignUpView {
    
    func signUpWithEmail(username: String, email: String, password: String, birthdate: Date) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let firebaseUser = result.user
            user.uid = firebaseUser.uid
            user.birthdate = birthdate
            user.password = password
            user.email = email
            user.username = username
            let database = Firestore.firestore()
            do {
                user.userDocID = try await database.collection("users").addDocument(data: ["username":username, "email":email, "password":password, "birthdate":birthdate,  "uid":user.uid]).documentID
            } catch {
                print("Failed to add user to database")
                showError = true
            }
        } catch {
            print("Failed to sign up with email/password")
            showError = true
        }
    }
    
    func signUpWithGoogle() async {
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
        
        do {
            let googleResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            let googleUser = googleResult.user
            let idTokenString = googleUser.idToken?.tokenString
            let accessTokenString = googleUser.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idTokenString!, accessToken: accessTokenString)
            do {
                let firebaseResult = try await Auth.auth().signIn(with: credential)
                let firebaseUser = firebaseResult.user
                user.uid = firebaseUser.uid
                user.email = googleUser.profile!.email
                user.username = googleUser.profile!.givenName!
                let database = Firestore.firestore()
                let snapshot = try await database.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments()
                print("doc count: "+snapshot.count.formatted())
                if(snapshot.count == 0) {
                    user.userDocID = try await database.collection("users").addDocument(data: ["username":googleUser.profile!.givenName as Any, "email":googleUser.profile!.email as Any, "uid":user.uid]).documentID
                }
            } catch {
                print("Firebase/Google sign up failed")
                showError = true
            }
        } catch {
            print("Google token failed")
            showError = true
        }
    }
}

#Preview {
    SignUpView()
}
