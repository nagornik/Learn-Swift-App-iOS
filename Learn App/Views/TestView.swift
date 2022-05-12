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
        
        if model.currentQuestion != nil {
            VStack (alignment: .leading) {
                Text("Question \(model.currentQuestionIndex+1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading)
                CodeTextView()
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack{
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            Button {
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    } else {
                                        if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        } else if index == model.currentQuestion?.correctIndex ?? 0 {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion?.answers[index] ?? "Loading...")
                                }
                            }
                            .disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                Button {
                    
                    if submitted == true {
                        model.nextQuestion()
                        submitted = false
                        selectedAnswerIndex = nil
                    } else {
                        submitted = true
                        if selectedAnswerIndex == model.currentQuestion?.correctIndex ?? 0 {
                            numCorrect += 1
                        }
                    }
                    
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
                
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
        } else {
//            ProgressView()
            TestResultView(numCorrect: numCorrect)
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(ContentModel())
    }
}
