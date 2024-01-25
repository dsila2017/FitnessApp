//
//  SignInViewModel.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import Foundation
import Firebase
import LocalAuthentication

enum MyError: Error {
    case emptyEmail
}

enum AlertType {
    case mainAlert
    case emptyAlert
    case IDAlert
    case IDFail
}

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var isActive = false
    @Published var forgotAlert = false
    
    var IDEmail: String? = nil
    var IDPassword: String? = nil
    var policy = "This is policy"
    var wantID: Bool = false
    var alertType: AlertType?
    var error = ""
    
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
                                    self?.isActive = true
                                }
                            } catch {
                                print(error)
                            }
                        }
                    } else {
                        // Unsuccessful Auth
                        print(authenticationError?.localizedDescription ?? "")
                    }
                }
            } else {
                print("Can't Auth")
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

extension MyError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return NSLocalizedString("Email/Password cannot be empty.", comment: "")
        }
    }
}
