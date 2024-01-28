//
//  SignUpViewModel.swift
//  FitnessApp
//
//  Created by David on 1/25/24.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var passPrivate: Bool = true
    var alert = ""
    
    // MARK: - Methods
    func createUser() async throws {
        guard !email.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert = true
            }
            throw MyError.emptyEmail
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func validateEmail() -> Bool {
        // Validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassCases() -> Bool {
        // Validate password contains at least one lowercase and one uppercase letter
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z]).+$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func validatePassDigits() -> Bool {
        // Validate password contains at least one digit
        let passwordRegex  = "^(?=.*?[0-9]).+$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func validatePassMin() -> Bool {
        // Validate password length is at least 8 characters
        if password.count >= 8 {
            return true
        } else { return false }
    }
    
    func canRegister() -> Bool {
        // Check if all validation conditions are met
        if validateEmail() && validatePassCases() && validatePassDigits() && validatePassMin() {
            return false
        }
        return true
    }
}
