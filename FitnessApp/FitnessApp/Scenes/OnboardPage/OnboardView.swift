//
//  OnboardView.swift
//  FitnessApp
//
//  Created by David on 2/11/24.
//

import SwiftUI

struct OnboardView: View, MainNavigationController {
    
    let title: String
    let image: LottieView
    let description: String
    let isLast: Bool
    
    var body: some View {
        
        if !isLast {
            VStack{
                image
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 20)
                Text(title)
                    .font(.title.bold())
                    .padding()
                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 140)
                    
                    
            }
        } else {
            VStack {
                Spacer()
                image
                    .frame(width: 300, height: 300)
                Text(title)
                    .font(.title.bold())
                    .padding()
                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
                Spacer()
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "has-seen-onboarding")
                    self.push(viewController: UIHostingController(rootView: SignInView()), animated: true)
                }, label: {
                    Text("Continue")
                })
                .buttonStyle(.plain)
                .padding(.horizontal, 40)
                .padding(.bottom, 70)
            }
        }
    }
}

#Preview {
    OnboardView(title: "Title", image: LottieView(animationName: "Scan"), description: "Description", isLast: false)
}
