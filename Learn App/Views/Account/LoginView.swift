//
//  LoginView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 08.06.2022.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String?
    
    var buttonText: String {
        if loginMode == Constants.LoginMode.login {
            return "Log In"
        } else {
            return "Sign Up"
        }
    }
    
    var body: some View {
        VStack (spacing: 10) {
            Spacer()
            Group {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFit()
                .frame(maxWidth: 150)
                Text("Learnzilla")
            }
            
            Spacer()
            Group {
                Picker("Login Mode", selection: $loginMode) {
                    Text("Log In")
                        .tag(Constants.LoginMode.login)
                    Text("Sign Up")
                        .tag(Constants.LoginMode.createAccount)
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Email:", text: $email)
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name:", text: $name)
                }
                SecureField("Password:", text: $password)
                
                if errorMessage != nil {
                    Text(errorMessage!)
                }
            }
            Button {
                if loginMode == Constants.LoginMode.login {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        guard error == nil else {
                            errorMessage = error!.localizedDescription
                            return
                        }
                        self.errorMessage = nil
                        model.checkLogin()
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        guard error == nil else {
                            errorMessage = error!.localizedDescription
                            return
                        }
                        self.errorMessage = nil
                        model.checkLogin()
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundColor(.blue)
                        .frame(height: 40)
                    Text(buttonText)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal, 40)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ContentModel())
    }
}
