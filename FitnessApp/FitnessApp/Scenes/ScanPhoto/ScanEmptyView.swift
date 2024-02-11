//
//  ScanEmptyView.swift
//  FitnessApp
//
//  Created by David on 2/11/24.
//

import SwiftUI

struct ScanEmptyView: View {
    var body: some View {
        
        VStack {
            Spacer()
                .font(.title.bold())
            LottieView(animationName: "Scan")
                .frame(maxWidth: .infinity, maxHeight: 340)
            Spacer()
        }
    }
}

#Preview {
    ScanEmptyView()
}
