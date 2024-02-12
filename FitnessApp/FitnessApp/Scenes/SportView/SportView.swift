//
//  SportView.swift
//  FitnessApp
//
//  Created by David on 2/12/24.
//

import SwiftUI

struct SportView: View {
    @Binding var activity: ActivityModel
    var color: Color
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(14)
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 16))
                        Text(activity.subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundStyle(color)
                }
                //.padding()
                
                Text(activity.amount)
                    .font(.system(size: 24))
            }
            .padding()
        }
    }
}

//#Preview {
//    SportView(activity: ActivityModel(title: "Steps", subtitle: "Goal", image: "figure.walk", amount: "14000"))
//}
