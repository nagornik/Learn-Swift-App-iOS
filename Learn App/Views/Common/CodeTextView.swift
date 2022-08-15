//
//  CodeTextView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 11.05.2022.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = UIColor(Color("background2"))
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        textView.attributedText = model.codeText
        textView.textColor = UIColor(Color("text"))
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
            .environmentObject(ContentModel())
            .preferredColorScheme(.dark)
    }
}
