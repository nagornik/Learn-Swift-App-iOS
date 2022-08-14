////
////  LottieView.swift
////  DesignCode-1
////
////  Created by Anton Nagornyi on 11.08.2022.
////
//
//import SwiftUI
//import Lottie
//
//struct LottieView: UIViewRepresentable {
//    
//    var filename: String
//    
//    typealias UIViewType = UIView
//    
//    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
//        let view = UIView(frame: .zero)
//        
//        let animationView = AnimationView()
//        let animation = Animation.named(filename)
//        animationView.animation = animation
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.play()
//        
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(animationView)
//        
//        NSLayoutConstraint.activate([
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//        ])
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
//    }
//}
