//
//  CustomTextField.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    @Binding var text: String
    
    var placeholder: String
    var iconName: String?
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
            
            if let iconName {
                Image(systemName: iconName)
                    .foregroundColor(AppColors.darkGray)
                    .font(.system(size: 24))
                    .padding(.leading, 12)
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .foregroundColor(AppColors.black)
        .padding(.horizontal, 16)
        .background(AppColors.silver)
        .cornerRadius(16)
    }
}
