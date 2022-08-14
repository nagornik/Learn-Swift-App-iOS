//
//  HomeViewRow.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var title: String
    var description: String
    var count: String
    var time: String
    var module: Module
    
    @State var showContent = false
    
    var body: some View {
        if !showContent {
        VStack {

            VStack (alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Image(image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                Text(description)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                    .font(.callout)
                HStack {
                    Image(systemName: "text.book.closed")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(count)
                        .font(Font.system(size: 13))
                    Spacer()
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(time)
                        .font(Font.system(size: 13))
                }
            }
            .foregroundColor(.white)
            .padding()
            
        }
        .padding()
        .background(Color(hex: "1E1E1E"))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding()
        .shadow(color: .black, radius: 20, x: 0, y: 20)
        } else {
            ScrollView {
                VStack {
                    ForEach(0..<module.content.lessons.count) { index in
                        ContentViewRow(index: index)
                    }
                }
                .padding()
                .background(Color(hex: "1E1E1E"))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()
            }
        }
        
        
        
    }
    
    var oldcard: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116, alignment: .center)
                    .clipShape(Circle())
                Spacer()
                VStack (alignment: .leading, spacing: 10) {
                    Text(title)
                        .bold()
                    Text(description)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                        .font(.caption)
                    HStack {
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(count)
                            .font(Font.system(size: 10))
                        Spacer()
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(time)
                            .font(Font.system(size: 10))
                    }
                }
                .padding(.leading)
            }
            .padding(.horizontal, 30)
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "Understand the fundamentals of the Swift programming language.", count: "20 Lessons", time: "2 Hours", module: ContentModel().localModules[0])
    }
}
