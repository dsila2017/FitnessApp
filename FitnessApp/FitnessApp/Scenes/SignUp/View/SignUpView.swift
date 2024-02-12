//
//  SignUpView.swift
//  FitnessApp
//
//  Created by David on 1/25/24.
//

import SwiftUI

struct SignUpView: View, MainNavigationController {
    // MARK: - Properties
    @StateObject private var model: SignUpViewModel = SignUpViewModel()
    
    // MARK: - Body
    var body: some View {
        
        VStack(spacing: 12) {
            Spacer()
            SignUpLogoView()
            Spacer()
            EmailPasswordForm(model: model)
            Spacer()
            ValidationMessages(model: model)
            Spacer()
            RegisterButton(model: model)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(Colors.white)
    }
}

#Preview {
    SignUpView()
}

// MARK: - Private Views
private struct SignUpLogoView: View {
    var body: some View {
        Label {
            Text("Sign Up")
                .fontWeight(.bold)
        } icon: {
            //Image(systemName: "apple.logo")
        }
        .font(.system(size: 30))
        .foregroundStyle(Colors.black)
        .padding(40)
    }
}

private struct CheckMarkLabel: View {
    var text: String
    var check: Bool
    
    var body: some View {
        Label(text, systemImage: "checkmark.circle")
            .foregroundStyle(check ? .green : Colors.darkGray)
    }
}

private struct PasswordField: View {
    @ObservedObject var model: SignUpViewModel
    
    var body: some View {
        Group {
            if model.passPrivate {
                CustomSecureTextFieldView(text: $model.password, placeholder: "Password")
            }
            else {
                CustomTextFieldView(text: $model.password, placeholder: "Password")
            }
        }
        .overlay(alignment: .trailing) {
            Button(action: {
                model.passPrivate.toggle()
            }, label: {
                Image(systemName: model.passPrivate ? "eye" : "eye.slash")
                    .tint(Colors.darkGray)
            })
            .padding(.trailing, 24)
        }
    }
}

private struct ValidationMessages: View {
    @ObservedObject var model: SignUpViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            CheckMarkLabel(text: "Valid email address", check: model.validateEmail())
            CheckMarkLabel(text: "8 or more characters", check: model.validatePassMin())
            CheckMarkLabel(text: "Upper & lowercase letters", check: model.validatePassCases())
            CheckMarkLabel(text: "At least one number", check: model.validatePassDigits())
        }
        .foregroundStyle(.gray)
    }
}

private struct RegisterButton: View, MainNavigationController {
    @ObservedObject var model: SignUpViewModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await model.createUser()
                    model.alert = "Success"
                    model.showAlert = true
                } catch {
                    model.alert = error.localizedDescription
                    model.showAlert = true
                }
            }
        }, label: {
            Text("Create Account")
        })
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .foregroundColor(Colors.white)
        .background(model.canRegister() ? Colors.lightGray : Colors.black)
        .cornerRadius(40)
        .disabled(model.canRegister())
        .alert(isPresented: $model.showAlert) {
            Alert(title: Text("Registration message"), message: Text(model.alert), dismissButton: .default(Text("OK")) { self.pop(animated: true) })
        }
    }
}

private struct EmailPasswordForm: View {
    @ObservedObject var model: SignUpViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            CustomTextFieldView(text: $model.email, placeholder: "Email")
            PasswordField(model: model)
        }
    }
}
