//
//  MainOnboard.swift
//  FitnessApp
//
//  Created by David on 2/11/24.
//

import SwiftUI

struct MainOnboard: View {
    var body: some View {
        TabView {
            OnboardView(title: "Daily Nutrition", image: LottieView(animationName: "firstPage"), description: "Track meals, calories, nutrients for healthier lifestyle. Simple, intuitive.", isLast: false)
            
            OnboardView(title: "Progress Monitoring", image: LottieView(animationName: "thirdPage"), description: "Track your progress over time with interactive charts and graphs", isLast: false)
            
            OnboardView(title: "Food Tracking", image: LottieView(animationName: "secondPage"), description: "Monitor your intake of calories and macronutrients (carbohydrates, proteins, and fats)", isLast: true)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    MainOnboard()
}
