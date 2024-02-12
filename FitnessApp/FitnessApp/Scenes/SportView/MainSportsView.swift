//
//  MainSportsView.swift
//  FitnessApp
//
//  Created by David on 2/12/24.
//

import SwiftUI

struct MainSportsView: View {
    @StateObject var healthManager = HealthManager()
    var settings = ProfileViewModel.shared
    
    var body: some View {
        ZStack {
            settings.backgroundColor.ignoresSafeArea()
            VStack {
                Spacer()
                Text("Activity")
                    .font(.title.bold())
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2), spacing: 20, content: {
                    SportView(activity: $healthManager.stepsActivity, color: .green)
                    
                    SportView(activity: $healthManager.caloriesActivity, color: .red)
                    
                    SportView(activity: $healthManager.runningActivity, color: .yellow)
                    
                    SportView(activity: $healthManager.swimmingActivity, color: .blue)
                    
                    SportView(activity: $healthManager.basketballActivity, color: .red)
                    
                    SportView(activity: $healthManager.baseballActivity, color: .orange)
                    
                    SportView(activity: $healthManager.soccerActivity, color: .pink)
                    
                    SportView(activity: $healthManager.boxingActivity, color: .black)
                })
            }
            .padding()
            
        }
    }
}

#Preview {
    MainSportsView()
}
