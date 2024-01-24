//
//  SignInViewModel.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import Foundation
import Firebase
import LocalAuthentication

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn(email: String, password: String) {
        
    }
    
}
