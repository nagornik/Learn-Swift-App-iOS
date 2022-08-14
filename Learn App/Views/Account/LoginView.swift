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
    
    enum FocusedFields: Hashable {
        case email
        case password
        case name
    }
    
    @FocusState private var focus: FocusedFields?
    @State var isFocused = false
    @State var showAlert = false
    @State var alertTitle = "Uh-oh!"
    @State var alertMessage = "Something went wrong."
    @State var dragAlert = CGSize.zero
    @State var switchingOffset = CGFloat.zero
    @State var makeDark = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color("background2")
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .ignoresSafeArea(.all, edges: .bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
             
                CoverView()
                
                
                VStack {
                    
                    if loginMode == .createAccount {
                        HStack {
                            
                            Image(systemName: "person.crop.circle.fill")
                                .foregroundColor(Color(hex: "A7B6DC"))
                                .frame(width: 44, height: 44)
                                .background(Color("background1"))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.leading)
                                .scaleEffect(focus == .name ? 1.2 : 1)
                                .hueRotation(.degrees(focus == .name ? 45 : 0))
                                .animation(.spring(response: 0.2, dampingFraction: 0.7, blendDuration: 0), value: focus)
                            
                            TextField("Name".uppercased(), text: $name)
                                .focused($focus, equals: .name)
                                .padding(.leading)
                                .keyboardType(.emailAddress)
                                .font(.subheadline)
                                .frame(height: 44)
                                
                        }
                        .onTapGesture {
                            isFocused = true
                            focus = .name
                        }
                        
                        Divider().padding(.leading, 80)
                        
                    }
                    
                    HStack {
                        
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color(hex: "A7B6DC"))
                            .frame(width: 44, height: 44)
                            .background(Color("background1"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                            .scaleEffect(focus == .email ? 1.2 : 1)
                            .hueRotation(.degrees(focus == .email ? 45 : 0))
                            .animation(.spring(response: 0.2, dampingFraction: 0.7, blendDuration: 0), value: focus)
                        
                        TextField("Email".uppercased(), text: $email)
                            .focused($focus, equals: .email)
                            .padding(.leading)
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
                            .frame(height: 44)
                            
                    }
                    .onTapGesture {
                        isFocused = true
                        focus = .email
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    HStack {
                        
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(hex: "A7B6DC"))
                            .frame(width: 44, height: 44)
                            .background(Color("background1"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                            .scaleEffect(focus == .password ? 1.2 : 1)
                            .hueRotation(.degrees(focus == .password ? 45 : 0))
                            .animation(.spring(response: 0.2, dampingFraction: 0.7, blendDuration: 0), value: focus)
                        
                        SecureField("Password".uppercased(), text: $password)
                            .focused($focus, equals: .password)
                            .padding(.leading)
                            .keyboardType(.default)
                            .font(.subheadline)
                            .frame(height: 44)
                        
                        if !email.isEmpty && !password.isEmpty && focus == .password {
                            Button {
                                logInOrType()
                            } label: {
                                Text(loginMode == .login ? "Log In" : "Sign Up")
                                    .foregroundColor(.primary)
                                    .padding(12)
                                    .padding(.horizontal, 12)
                                    .background(Color(hex: "FB6E3D"))
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                                    .shadow(color: Color(hex: "FB6E3D").opacity(0.5), radius: 10, x: 0, y: 10)
                                    .padding(.trailing)
                            }
                        }
                            
                    }
                    .onTapGesture {
                        isFocused = true
                        focus = .password
                    }
                    
                }
//                .frame(height:136)
                .padding(.vertical)
                .frame(maxWidth: 500)
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 20)
                .padding(.horizontal)
                .offset(y: -30)
                .offset(x: switchingOffset)
                
                Button {
                    withAnimation(.spring()) {
                        if loginMode == .login {
                            loginMode = .createAccount
                        } else {
                            loginMode = .login
                        }
                        
//                        switchingOffset = UIScreen.main.bounds.width
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                            switchingOffset = -UIScreen.main.bounds.width
//                            withAnimation(.spring()) {
//
//                                switchingOffset = 0
//                            }
//
//                        }
                        
                    }
                } label: {
                    HStack {
                        Text("\(loginMode == .login ? "Don't" : "Already") have an account?")
                        Text(loginMode != .login ? "Log in" : "Sign up")
                            .bold()
                            .foregroundColor(.black)
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .offset(x: switchingOffset)
                }
                
            }
            .blur(radius: showAlert ? 5 : 0)
            
            HStack {
                
                if loginMode == .login {
                    Text("Forgot password?")
                        .font(.subheadline)
                        .opacity(loginMode == .login ? 1 : 0)
                        .onTapGesture {
                            sendPasswordResetEmail()
                        }
                    Spacer()
                }
                
                Button {
                    logInOrType()
                } label: {
                    Text(loginMode == .login ? "Log In" : "Sign Up")
                        .foregroundColor(.primary)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(hex: "FB6E3D"))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .shadow(color: Color(hex: "FB6E3D").opacity(0.5), radius: 10, x: 0, y: 10)
                }
                
//                if loginMode != .login {
//                    Spacer()
//                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding()
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Error"),
//                    message: Text(alertMessage),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
            .opacity(isFocused ? 0 : 1)
            .blur(radius: showAlert ? 5 : 0)
            .offset(x: switchingOffset)
            

            
                ZStack(alignment: .center) {
                    if showAlert {
                        
                        Color.black
                            .opacity(0.4)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 18) {
                            Text(alertTitle)
                                .font(.title3.bold())
                            
                            Text(alertMessage)
                                .font(.footnote)
                                .padding(.horizontal)
                            
                            Divider()
                            
                            Button {
                                showAlert = false
                            } label: {
                                Text("Ok")
                            }

                            
                        }
                        .frame(maxWidth: 300)
                        .padding()
//                        .background(Color("background2"))
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .offset(dragAlert)
                        .scaleEffect(1 - (abs(dragAlert.height) + abs(dragAlert.width))/1000)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .trailing))
                
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            dragAlert = value.translation
                            if abs(value.translation.width) > 150 {
                                showAlert = false
                                dragAlert = .zero
                            }
                        })
                        .onEnded({ value in
                            
                                withAnimation(.spring()) {
                                    dragAlert = .zero
                                }
                            
                        })
                )
            
            
        }
        .ignoresSafeArea(.all, edges: .top)
        .offset(y: isFocused ? -60 : 0)
        .onTapGesture {
            hideKeyboard()
        }
        .animation(.spring(), value: isFocused)
        .animation(.spring(), value: showAlert)
        .background(.black.opacity(makeDark ? 1 : 0))
        .animation(.linear(duration: 2), value: makeDark)
        
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isFocused = false
    }
    
    func logInOrType() {
        if loginMode == .createAccount && name.isEmpty {
            isFocused = true
            focus = .name
        } else if email.isEmpty {
            isFocused = true
            focus = .email
        } else if password.isEmpty {
            isFocused = true
            focus = .password
        } else {
            hideKeyboard()
            
            if loginMode == .login {
                makeDark = true
                Auth.auth().signIn(withEmail: email, password: password) { result, error in

                    guard error == nil else {
                        alertMessage = error?.localizedDescription ?? "Error"
                        showAlert = true
                        makeDark = false
                        return
                    }
                    model.loggedIn = true
                    makeDark = false
                }
            } else {
                makeDark = true
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
    
                    guard error == nil else {
                        alertMessage = error?.localizedDescription ?? "Error"
                        showAlert = true
                        makeDark = false
                        return
                    }
                    model.loggedIn = true
    
                    UserService.shared.user.name = name
                    makeDark = false
                    
                }
            }
        }
    }
    
    
    
    
    
    
    
    func sendPasswordResetEmail() {
        if email.isEmpty {
            focus = .email
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                alertTitle = "Uh-oh!"
                alertMessage = error!.localizedDescription
                showAlert.toggle()
                return
            }
            alertTitle = "Password reset email sent."
            alertMessage = "Check your inbox for an email to reset your password."
            showAlert.toggle()
            return
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
//        CoverView()
            .environmentObject(ContentModel())
    }
}

struct CoverView: View {
    
    @State var show = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var maxValue: CGFloat {
        guard viewState != .zero else { return 0 }
        if abs(viewState.height) > abs(viewState.width) {
            return abs(viewState.height) / 20
        } else {
            return abs(viewState.width) / 20
        }
    }
    
    var body: some View {
        VStack {
            
            GeometryReader { geo in
                Text("Learn Swift & SwiftUI fundamentals.")
                    .font(.system(size: geo.size.width/10, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: 375, maxHeight: 100)
            .padding(.horizontal, 16)
            .offset(x: viewState.width/15, y: viewState.height/15)
            
            Text("20 video & text lessons for SwiftUI, React and design tools.")
                .font(.subheadline)
//                .blendMode(.hardLight)
                .frame(width: 250)
                .offset(x: viewState.width/20, y: viewState.height/20)
            
            Spacer()
            
        }
        .padding(.top, 100)
        .multilineTextAlignment(.center)
        .frame(height: 477)
        .frame(maxWidth: .infinity)
        .background(Image("Card3").offset(x: viewState.width/25, y: viewState.height/25), alignment: .bottom)
        .background(
            ZStack {
                Image("Blob")
                    .offset(x: -150, y: -200)
                    .rotationEffect(.degrees(show ? 360+90 : 90))
                    .blendMode(.colorBurn)
                    .animation(.linear(duration: 60).repeatForever(autoreverses: false), value: show)
                Image("Blob")
                    .offset(x: -200, y: -250)
                    .rotationEffect(.degrees(show ? 360 : 0), anchor: .leading)
                    .blendMode(.overlay)
                    .animation(.linear(duration: 100).repeatForever(autoreverses: false), value: show)
            }
                .onAppear {
                    show = true
                }
        )
        .background(Color(hex: "#FB6E3D"))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isDragging ? maxValue : 0), axis: (-viewState.height, viewState.width, 0))
        .scaleEffect(isDragging ? 0.95 : 1)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    viewState = value.translation
                    isDragging = true
                })
                .onEnded({ value in
                    viewState = .zero
                    isDragging = false
                })
        )
        .animation(.easeInOut, value: viewState)
        .animation(.easeInOut, value: isDragging)
    }
}


//var body: some View {
//    VStack (spacing: 10) {
//        Spacer()
//        Group {
//            Image(systemName: "book")
//                .resizable()
//                .scaledToFit()
//            .frame(maxWidth: 150)
//            Text("Learnzilla")
//        }
//
//        Spacer()
//        Group {
//            Picker("Login Mode", selection: $loginMode) {
//                Text("Log In")
//                    .tag(Constants.LoginMode.login)
//                Text("Sign Up")
//                    .tag(Constants.LoginMode.createAccount)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            TextField("Email:", text: $email)
//            if loginMode == Constants.LoginMode.createAccount {
//                TextField("Name:", text: $name)
//            }
//            SecureField("Password:", text: $password)
//
//            if errorMessage != nil {
//                Text(errorMessage!)
//            }
//        }
//        Button {
//            if loginMode == Constants.LoginMode.login {
//                Auth.auth().signIn(withEmail: email, password: password) { result, error in
//                    guard error == nil else {
//                        errorMessage = error!.localizedDescription
//                        return
//                    }
//                    self.errorMessage = nil
//                    model.checkLogin()
//                }
//            } else {
//                Auth.auth().createUser(withEmail: email, password: password) { result, error in
//                    guard error == nil else {
//                        errorMessage = error!.localizedDescription
//                        return
//                    }
//                    self.errorMessage = nil
//                    model.checkLogin()
//                }
//            }
//        } label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 30, style: .continuous)
//                    .foregroundColor(.blue)
//                    .frame(height: 40)
//                Text(buttonText)
//                    .bold()
//                    .foregroundColor(.white)
//            }
//        }
//        Spacer()
//    }
//    .textFieldStyle(RoundedBorderTextFieldStyle())
//    .padding(.horizontal, 40)
//}
