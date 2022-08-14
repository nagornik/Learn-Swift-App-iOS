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
        
        
//        let lesson = model.currentModule!.content.lessons[index]
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                .frame(height: 66)
            HStack (spacing: 30) {
                Text(String(index + 1))
                    .bold()
                VStack (alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
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
//                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                
            }
            .padding(.leading, 30)
            
//                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
//                    .font(.system(size: 24, weight: .light))
//                    .padding(.horizontal, 8)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .onTapGesture {
//                        model.completeLesson(lesson: lesson)
//                        completed.toggle()
//                    }
            
            
        }
        .padding(.bottom, 5)
        .onAppear {
            if UserService.shared.user.completedLessons.contains(lesson.title) {
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
    }
}
