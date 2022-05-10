//
//  ContentViewRow.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        
        
        let lesson = model.currentModule!.content.lessons[index]
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
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
            }
            .padding(.leading, 30)
        }
        .padding(.bottom, 5)
        
        
        
    }
}

struct ContentViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewRow(index: 0)
            .environmentObject(ContentModel())
    }
}
