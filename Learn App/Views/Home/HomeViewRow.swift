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
    
    var body: some View {
        
        ZStack {
            
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
                .foregroundColor(Color("text"))
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

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "Understand the fundamentals of the Swift programming language.", count: "20 Lessons", time: "2 Hours")
//        HomeCoverView(image: "swift", title: "Learn Swift", description: "Understand the fundamentals of the Swift programming language.", count: "20 Lessons", time: "2 Hours")
            .preferredColorScheme(.dark)
    }
}


// MARK: NOT USED (JUST IN CASE)
struct HomeCoverView: View {
    
    @State var show = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var image: String
    var title: String
    var description: String
    var count: String
    var time: String
    
    let rand = [-1, 1]
    
    var maxValue: CGFloat {
        guard viewState != .zero else { return 0 }
        if abs(viewState.height) > abs(viewState.width) {
            return abs(viewState.height) / 20
        } else {
            return abs(viewState.width) / 20
        }
    }
    
    var body: some View {
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
            .foregroundColor(Color("text"))
            .padding(.horizontal)
            
        }
        .padding()
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .background(Color("back").opacity(0.5))
        .background(
            ZStack {
                Image("Blob")
                    .offset(x: CGFloat.random(in: -200..<100), y: CGFloat.random(in: -200..<200))
                    .rotationEffect(.degrees(show ? Double(rand.randomElement()! * 360 + 90) : 90))
                    .blendMode(.colorBurn)
                    .animation(.linear(duration: 60).repeatForever(autoreverses: false), value: show)
                Image("Blob")
                    .offset(x: CGFloat.random(in: -200..<100), y: CGFloat.random(in: -200..<200))
                    .rotationEffect(.degrees(show ? Double(rand.randomElement()! * 360) : 0), anchor: .leading)
                    .blendMode(.overlay)
                    .animation(.linear(duration: 100).repeatForever(autoreverses: false), value: show)
            }
                .onAppear {
                    show = true
                }
        )
        .background(Color(hex: "#FB6E3D"))
        
        
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isDragging ? maxValue : 0), axis: (-viewState.height, viewState.width, 0))
        .scaleEffect(isDragging ? 0.95 : 1)
        .animation(.easeInOut, value: viewState)
        .animation(.easeInOut, value: isDragging)
    }
}
