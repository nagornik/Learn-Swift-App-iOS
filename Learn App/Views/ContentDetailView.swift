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
            
            
            if model.hasNextLesson() {
                Button {
                    model.setNextLesson()
                } label: {
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 46)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex+1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    
                }
            }
            
            
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
                .toolbar { // <2>
                    ToolbarItem(placement: .principal) { // <3>
                        VStack {
                            Text("Lesson \(model.currentLessonIndex+1)").font(.subheadline)
                            Text(model.currentModule!.content.lessons[model.currentLessonIndex].title).font(.headline)
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
