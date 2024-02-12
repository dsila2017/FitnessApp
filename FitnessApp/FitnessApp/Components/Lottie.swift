//
//  Lottie.swift
//  FitnessApp
//
//  Created by David on 2/11/24.
//

import Foundation
import UIKit
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    // MARK: - Properties
    
    var animationName: String
    
    // MARK: - Methods
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: animationName)
        
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
            
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
