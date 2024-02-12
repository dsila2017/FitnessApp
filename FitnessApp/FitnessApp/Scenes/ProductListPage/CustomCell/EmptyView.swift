//
//  EmptyView.swift
//  FitnessApp
//
//  Created by David on 2/11/24.
//

import SwiftUI

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
