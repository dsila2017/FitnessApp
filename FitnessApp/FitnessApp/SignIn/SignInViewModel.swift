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
    var IDEmail: String? = nil
    var IDPassword: String? = nil
    var policy = "This is policy"
    var wantID: Bool = false
    var alertType: AlertType?
    var error: String = ""
    
    // MARK: - Methods
    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty else {
            throw MyError.emptyEmail
        }
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
//    func createUser() async throws {
//        guard !email.isEmpty else {
//            DispatchQueue.main.async { [weak self] in
//                self?.alertType = .mainAlert
//                self?.showAlert = true
//            }
//            throw MyError.emptyEmail
//        }
//        try await AuthenticationManager.shared.createUser(email: email, password: password)
//    }
    
    func faceID() async throws {
        let scanner = LAContext()
        var error: NSError?
        
        if self.wantID == true {
            if scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: policy) { [weak self] result, authenticationError in
                    guard let self = self else { return }
                    if result {
                        // Successful Auth
                        Task {
                            do {
                                try await self.signIn(email: self.IDEmail!, password: self.IDPassword!)
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
    
    func forgotPassword() async throws {
        try await AuthenticationManager.shared.forgotPassword(email: email)
    }
    
    func writeID() {
        self.wantID = true
        self.IDEmail = self.email
        self.IDPassword = self.password
    }
    
    func askID() {
        if self.wantID == false {
            self.alertType = .IDAlert
            self.showAlert = true
        }
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
