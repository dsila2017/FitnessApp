//
//  CustomSecureTextField.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import SwiftUI

struct CustomSecureTextFieldView: View {
    @Binding var text: String
    
    var placeholder: String
    var iconName: String?
    
    var body: some View {
        HStack {
            SecureField(placeholder, text: $text)
            
            if let iconName {
                Image(systemName: iconName)
                    .foregroundColor(Colors.darkGray)
                    .font(.system(size: 24))
                    .padding(.leading, 12)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .foregroundColor(Colors.black)
        .padding(.horizontal, 16)
        .background(Colors.silver)
        .cornerRadius(16)
    }
}
