//
//  TestView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 11.05.2022.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex: Int?
    @State var numCorrect = 0
    @State var submitted = false
    @State var showResult = false
    
    var buttonText: String {
        if submitted {
            if model.currentQuestionIndex+1 < model.currentModule?.test.questions.count ?? 0 {
                return "Next question"
            }
            return "Finish! Get results"
        } else {
            return "Submit"
        }
    }
    
    
    var body: some View {
        
        if model.currentQuestion != nil && showResult == false {
            VStack (alignment: .leading) {
                Text("Question \(model.currentQuestionIndex+1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading)
                CodeTextView()
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                    .padding(.vertical)
                
                ScrollView {
                    VStack{
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            Button {
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : Color("back"))
                                            .frame(height: 48)
                                    } else {
                                        if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        } else if index == model.currentQuestion?.correctIndex ?? 0 {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else {
                                            RectangleCard(color: Color("back"))
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion?.answers[index] ?? "Loading...")
                                        .foregroundColor(Color("text"))
                                }
                                
                            }
                            .disabled(submitted)
                        }
                    }
                    
                    .padding()
                }
                Button {
                    
                    if submitted == true {
                        if model.currentQuestionIndex+1 == model.currentModule?.test.questions.count ?? 0 {
                            model.nextQuestion()
                            showResult = true
                        } else {
                            model.nextQuestion()
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                        
                        
                        
                    } else {
                        submitted = true
                        if selectedAnswerIndex == model.currentQuestion?.correctIndex ?? 0 {
                            numCorrect += 1
                        }
                    }
                    
                } label: {
                    ZStack {
                            
                        Text(buttonText)
                            .bold()
                            .frame(height: 48)
                        
                    }
//                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("text"))
                    .background(.green.opacity(0.5))
                    .background(Color("back"))
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(
                                LinearGradient(colors: [Color("text").opacity(0.1), Color("back")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
                
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
            .background(Color("background2").ignoresSafeArea())
        } else if showResult == true {
//            ProgressView()
            TestResultView(numCorrect: numCorrect)
        } else {
            ProgressView()
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(ContentModel())
    }
}
