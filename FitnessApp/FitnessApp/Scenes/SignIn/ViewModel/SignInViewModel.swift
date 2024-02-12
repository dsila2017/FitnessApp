//
//  SignInViewModel.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import Foundation
import Firebase
import LocalAuthentication

// MARK: - Enums
enum MyError: Error {
    case emptyEmail
}

enum AlertType: String {
    case mainAlert = "mainAlert"
    case IDAlert = "Do you want to save Face ID?"
    case IDFail = "Face ID is not set up, please sign in first."
}

// MARK: - ViewModel
final class SignInViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var pushNavigation = false
    @Published var forgotAlert = false
    
    // MARK: - Other Properties
    private var IDEmail: String? = nil
    private var IDPassword: String? = nil
    private var policy = "This is policy"
    private var wantID: Bool = false
    var alertType: AlertType?
    var error: String = ""
    
    // MARK: - Methods
    
    // Method for initiating the sign-in process
    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty else {
            throw MyError.emptyEmail
        }
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
    // Method for handling biometric authentication
    func faceID() async throws {
        let scanner = LAContext()
        var error: NSError?
        
        if UserDefaults.standard.bool(forKey: "wantID") == true {
            if scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: policy) { [weak self] result, authenticationError in
                    guard let self = self else { return }
                    if result {
                        // Successful Auth
                        Task {
                            do {
                                try await self.signIn(email: UserDefaults.standard.string(forKey: "IDEmail")!, password: UserDefaults.standard.string(forKey: "IDPassword")!)
                                DispatchQueue.main.async { [weak self] in
                                    self?.pushNavigation = true
                                }
                            } catch {
                                print("Authentication error: \(authenticationError?.localizedDescription ?? "")")
                            }
                        }
                    } else {
                        // Unsuccessful Auth
                        print(authenticationError?.localizedDescription ?? "")
                    }
                }
            } else {
                print("Cannot authenticate with biometrics")
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.alertType = .IDFail
                self?.showAlert = true
            }
        }
    }
    
    // Method for handling forgot password functionality
    func forgotPassword() async throws {
        try await AuthenticationManager.shared.forgotPassword(email: email)
    }
    
    // Method for storing biometric credentials
    func storeBiometricCredentials() {
        UserDefaults.standard.set(true, forKey: "wantID")
        UserDefaults.standard.set(self.email, forKey: "IDEmail")
        UserDefaults.standard.set(self.password, forKey: "IDPassword")
    }
    
    // Method for asking the user if they want to use biometric authentication
    func askID() {
        if UserDefaults.standard.bool(forKey: "wantID") == false {
            self.alertType = .IDAlert
            self.showAlert = true
        }
    }
    
    // Method for clearing the form
    func clearForm() {
        email = ""
        password = ""
    }
}

// MARK: - Extension for ErrorType
extension MyError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return NSLocalizedString("Email/Password cannot be empty.", comment: "")
        }
    }
}
