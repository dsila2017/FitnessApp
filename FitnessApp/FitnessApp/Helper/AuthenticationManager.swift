//
//  AuthenticationManager.swift
//  FitnessApp
//
//  Created by David on 1/25/24.
//

import Foundation
import Firebase

struct AuthResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthResultModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthResultModel(user: authResult.user)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthResultModel{
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthResultModel(user: authResult.user)
    }
    
    func forgotPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
