//
//  ProfileView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 08.06.2022.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    let user = UserService.shared.user
    @State var showNameInput = false
    @State var name = ""
    
    var body: some View {
//        NavigationView {
            ZStack {
                VStack(spacing: 0.0) {
                    
                    Text("Completed lessons")
                        .font(.title2.bold())
                        .padding(0)
                    
                    ForEach(model.modules) { module in

                        VStack(alignment: .leading) {
                            
                            Text(module.category)
                                .font(.title2.bold())
                                .padding(8)
                            ForEach(user.finishedLessons.filter({$0.module == module.category}).sorted(by: {$0.lessonNumber < $1.lessonNumber}), id:\.lessonTitle) { lesson in
                                Text("\(lesson.lessonNumber + 1). \(lesson.lessonTitle)")
                            }
                        }
                        .foregroundColor(Color("text"))
                        .padding(.horizontal)
                        
                        }
                        .padding()
            //            .background(Color("back"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(.thickMaterial)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(
                                    LinearGradient(colors: [Color("text").opacity(0.1), Color("back")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .padding(.top)
                        
                    Spacer()
                    
                    HStack {
                        Text("You've completed: \(user.finishedLessons.count) Lessons")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button {
                            if model.loggedIn {
                                try? Auth.auth().signOut()
                                model.checkLogin()
                            }
                        } label: {
                            Text("Sign Out")
                                .foregroundColor(.primary)
                                .padding(12)
                                .padding(.horizontal, 30)
    //                            .background(Color(hex: "FB6E3D"))
                                .background(Color("back"))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                                .shadow(color: Color("back").opacity(0.5), radius: 10, x: 0, y: 10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                }
                .foregroundColor(Color("text"))
                .padding()
                .toolbar {
                    ToolbarItem(id: "settings", placement: .confirmationAction) {
                        Image(systemName: "person.fill")
                            .onTapGesture {
                                withAnimation {
                                    showNameInput = true
                                }
                            }
                    }
                }
                .navigationTitle("Hello, " + UserService.shared.user.name)
                .background(Color("background2").ignoresSafeArea())
                .overlay {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(showNameInput ? 0.5 : 0)
                }
                
                
                ZStack {
                    if showNameInput {
                        VStack {
                            Text("Change your name")
                            TextField("Name", text: $name)
                                .padding()
                            Button {
                                if !name.isEmpty {
                                    UserService.shared.user.name = name
                                    model.saveData(writeToDatabase: true)
                                }
                                showNameInput = false
                            } label: {
                                Text("Ok")
                            }

                        }
                        .padding()
            //            .background(Color("back"))
                        .background(.thickMaterial)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(
                                    LinearGradient(colors: [Color("text").opacity(0.1), Color("back")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .padding()
                    }
                }
                .transition(.slide.animation(.spring()))
                
            }
            
//        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ContentModel())
    }
}
