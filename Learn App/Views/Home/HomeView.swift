//
//  ContentView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    let user = UserService.shared.user
    var navTitle: String {
        if user.lastLesson != nil || user.lastQuestion != nil {
            return "Welcome Back"
        } else {
            return "Get Started"
        }
    }
    
    @State var show = false
    let rand = [-1, 1]
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                

                ScrollView {
                    
                    
                    
                    LazyVStack {
                        
                        if user.lastLesson != nil && user.lastLesson! > 0 || user.lastQuestion != nil && user.lastQuestion! > 0 {
                            // Show the resume view
                            ResumeView(resumeSelected: 0)
                                .padding(.bottom, 20)
                        } else {
                            Text("What do you want to do today?")
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.leading, 20)
                        }
                        
                        
                        
                        ForEach(model.modules) { module in
                            
                            NavigationLink(tag: module.id.hash, selection: $model.currentContentSelected) {
                                ContentView()
                                    .onAppear {
                                        model.getDatabaseLessons(module: module) {
                                            model.beginModule(moduleId: module.id)
                                        }
                                        
                                    }
                            } label: {
                                HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
//                                HomeCoverView(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                            }
                            
                            NavigationLink(tag: module.id.hash, selection: $model.currentTestSelected) {
                                TestView()
                                    .onAppear {
                                        model.getDatabaseQuestions(module: module) {
                                            model.beginTest(moduleId: module.id)
                                        }
                                    }
                            } label: {
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                            }
                            
                        }.padding(.bottom, 20)
                    }
                    .padding()
//                    .accentColor(.black)
                }
            }
            .background(Color("background2"))
            
            .background(Color(hex: "#FB6E3D"))
            .navigationTitle(navTitle)
            .onChange(of: model.currentContentSelected) { newValue in
                if newValue == nil {
                    model.currentModule = nil
                }
            }
            .onChange(of: model.currentTestSelected) { newValue in
                if newValue == nil {
                    model.currentModule = nil
                }
            }
        }
        
        .navigationViewStyle(.stack)
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
