//
//  ContentViewRow.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import SwiftUI
import FirebaseAuth

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    
    var index: Int
    var lesson: Lesson {
        if model.currentModule != nil && index < model.currentModule!.content.lessons.count {
            return model.currentModule!.content.lessons[index]
        } else {
            return Lesson(id: "0", title: "Loading...", video: "Loading...", duration: "Loading...", explanation: "Loading...")
        }
    }
    
    @State var completed = false
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                HStack {
                    Text("\(index + 1).")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 4.0) {
                        
                        Text(lesson.title)
                            .bold()
                        Text(lesson.duration)
                            .font(.callout)
                    }
                    
                    Spacer()
                    
                    if Auth.auth().currentUser != nil {
                        Button {
                            model.completeLesson(inputLesson: lesson)
                            completed.toggle()
                        } label: {
                            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 24, weight: .light))
                                .padding(.trailing, 8)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .foregroundColor(Color("text"))
            .padding(.vertical)
            .background(Color("back"))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [Color("text").opacity(0.1), Color("back")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            })
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        .padding(.bottom, 5)
        .onAppear {
            if UserService.shared.user.finishedLessons.contains(where: {$0.lessonTitle == lesson.title}) {
                completed = true
            } else {
                completed = false
            }
        }
        
        
        
    }
}

struct ContentViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewRow(index: 0)
            .environmentObject(ContentModel())
            .preferredColorScheme(.dark)
    }
}
