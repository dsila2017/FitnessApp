//
//  EmptyView.swift
//  FitnessApp
//
//  Created by David on 2/11/24.
//

import UIKit
import SwiftUI
import Lottie

struct EmptyView: View {
    var body: some View {
        
        VStack {
            Spacer()
            Text("List is empty")
                .font(.title.bold())
            LottieView(animationName: "EmptyCart")
                .frame(maxWidth: .infinity, maxHeight: 340)
            Text("add some products to list")
                .font(.subheadline.bold())
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    EmptyView()
}

struct LottieView: UIViewRepresentable {
    var animationName: String
    
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
