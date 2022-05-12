//
//  ContentView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                ScrollView {
                    LazyVStack {
                        ForEach(model.modules) { module in
                            
                            NavigationLink(tag: module.id, selection: $model.currentContentSelected) {
                                ContentView()
                                    .onAppear {
                                        model.beginModule(moduleId: module.id)
                                    }
                            } label: {
                                HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                            }
                            
                            NavigationLink(tag: module.id, selection: $model.currentTestSelected) {
                                TestView()
                                    .onAppear {
                                        model.beginTest(moduleId: module.id)
                                    }
                            } label: {
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                            }
                            
                        }.padding(.bottom, 20)
                    }
                    .padding()
                    .accentColor(.black)
                }
            }
            .navigationTitle("Get Started")
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
