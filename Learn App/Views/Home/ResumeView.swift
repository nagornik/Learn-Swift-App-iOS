//
//  ResumeView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 09.06.2022.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var model: ContentModel
    let user = UserService.shared.user
    
    @State var resumeSelected: Int?
    
    var resumeTitle: String {
        let module = model.modules[user.lastModule ?? 0]
        if user.lastLesson != 0 {
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
        }
        else {
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
    }
    
    var destination: some View {
        return Group {
            let module = model.modules[user.lastModule ?? 0]
            if user.lastLesson! > 0 {
                ContentDetailView()
                    .onAppear(perform: {
                        model.getDatabaseLessons(module: module) {
                            model.beginModule(moduleId: module.id)
                            model.beginLesson(lessonId: user.lastLesson!)
                        }
                    })
            } else {
                TestView()
                    .onAppear(perform: {
                        model.getDatabaseQuestions(module: module) {
                            model.beginTest(moduleId: module.id)
                            model.currentQuestionIndex = user.lastQuestion!
                        }
                    })
            }
        }
    }
    
    var body: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        NavigationLink(destination: destination, tag: module.id.hash, selection: $resumeSelected) {
            
            ZStack {
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Continue where you left off:")
                            Text(resumeTitle)
                                .bold()
                        }
                        .foregroundColor(Color("text"))
                        Spacer()
                        Image("play")
                            .resizable()
                            .scaledToFit()
                            .frame(width:40, height: 40)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(.thickMaterial)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(
                            LinearGradient(colors: [Color("text").opacity(0.1), Color("back")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                })
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
        }
    }
}
