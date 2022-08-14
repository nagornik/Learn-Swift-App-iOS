//
//  ContentDetailView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var completed = false
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
                    .aspectRatio(16/9, contentMode: .fit)
            }
            
            
            CodeTextView()

            HStack {
                
                Button {
                    if model.hasNextLesson() {
                        model.setNextLesson()
                    } else {
                        model.setNextLesson()
                        model.currentContentSelected = nil
                    }
                } label: {
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(model.hasNextLesson() ? "Next Lesson: \(model.currentModule?.content.lessons[model.currentLessonIndex+1].title ?? "Loading...")" : "Exit")
                            .foregroundColor(.white)
                            .bold()
                        
                    }
                }
                
                
                VStack {
                    Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .light))
                        .padding(.horizontal, 8)
                    Text(completed ? "Completed" : "Complete")
                        .font(.caption2)
                }
                .onTapGesture {
                    model.completeLesson()
                    completed.toggle()
                }

                
            }
            
//            if model.hasNextLesson() {
//                Button {
//                    model.setNextLesson()
//                } label: {
//                    ZStack {
//                        RectangleCard(color: .green)
//                            .frame(height: 48)
//                        Text("Next Lesson: \(model.currentModule?.content.lessons[model.currentLessonIndex+1].title ?? "Loading...")")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                }
//            } else {
//                Button {
//                    model.setNextLesson()
//                    model.currentContentSelected = nil
//                } label: {
//                    ZStack {
//                        RectangleCard(color: .green)
//                            .frame(height: 48)
//                        Text("Complete")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                }
//            }
            
            
        }
        .onAppear(perform: {
            guard model.currentLesson != nil else {return}
            if UserService.shared.user.completedLessons.contains(model.currentLesson!.title) {
                completed = true
            } else {
                completed = false
            }
        })
        .onChange(of: model.currentLessonIndex, perform: { _ in
            guard model.currentLesson != nil else {return}
            if UserService.shared.user.completedLessons.contains(model.currentLesson!.title) {
                completed = true
            } else {
                completed = false
            }
        })
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { // <2>
            ToolbarItem(placement: .principal) { // <3>
                if model.currentModule?.content.lessons.count ?? 0 > model.currentLessonIndex {
                    VStack {
                        Text("Lesson \(model.currentLessonIndex+1)").font(.subheadline)
                        Text(model.currentModule?.content.lessons[model.currentLessonIndex].title ?? "Loading...").font(.headline)
                    }
                }
                
            }
        }
        
        
        
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
            .environmentObject(ContentModel())
    }
}
