//
//  Button Extension.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import SwiftUI

extension Button {
    var primaryButtonStyle: some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
            .background(AppColors.black)
            .cornerRadius(40)
    }
    
    var secondaryButtonStyle: some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(AppColors.black)
            .background(AppColors.white)
            .cornerRadius(40)
    }
}
