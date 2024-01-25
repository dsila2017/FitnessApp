//
//  SignInView.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import SwiftUI
import UIKit

struct SignInView: View, MainNavigationController {
    @StateObject var model: SignInViewModel = SignInViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            LogoView()
            
            Spacer()
            Spacer()
            
            VStack(spacing: 12) {
                CustomTextFieldView(text: $model.email, placeholder: "Email")
                CustomSecureTextFieldView(text: $model.password, placeholder: "Password")
                ForgotButton(model: model)
                    .alert(isPresented: $model.forgotAlert) {
                        Alert(title: Text("Important message"), message: Text(model.error), dismissButton: .default(Text("OK")))
                    }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                SignInButton(model: model)
                    .alert(isPresented: $model.showAlert) {
                        switch model.alertType {
                        case.IDAlert:
                            Alert(title: Text("Face ID Message"), message: Text("Do you want to save Face ID?"),
                                  primaryButton: .default(Text("Yes")) {
                                model.writeID()
                            },
                                  secondaryButton: .default(Text("No")))
                        case.mainAlert:
                            Alert(title: Text("Important message"), message: Text(model.error), dismissButton: .default(Text("OK")))
                        case.emptyAlert:
                            Alert(title: Text("Important message"), message: Text("Email/Password is empty"), dismissButton: .default(Text("OK")))
                        case.IDFail:
                            Alert(title: Text("Face ID"), message: Text("Face ID is not set up, please sign in first."), dismissButton: .default(Text("OK")))
                        case .none:
                            Alert(title: Text("NONE Message"), message: Text("Error4"), dismissButton: .default(Text("OK")))
                        }
                    }
                    .onChange(of: model.isActive) { oldValue, newValue in
                        if newValue == true {
                            self.push(viewController: ViewController(), animated: true)
                            model.isActive = false
                        }
                    }
                
                SignUpButton(model: model)
                FaceIDButton(model: model)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(Colors.white)
    }
}

#Preview {
    SignInView()
}

struct LogoView: View {
    var body: some View {
        Label {
            Text("Fitness")
                .fontWeight(.bold)
        } icon: {
            Image(systemName: "apple.logo")
        }
        .font(.system(size: 30))
        .foregroundStyle(.black)
        .padding(40)
    }
}

struct ForgotButton: View {
    @State var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await model.forgotPassword()
                    model.error = "Success"
                    model.forgotAlert = true
                } catch {
                    model.error = error.localizedDescription
                    model.forgotAlert = true
                }
            }
        }, label: {
            Text("Forgot password?")
                .fontWeight(.thin)
                .foregroundStyle(Colors.darkGray)
                .padding()
        })
    }
}

struct SignInButton: View, MainNavigationController {
    @State var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await model.signIn(email: model.email, password: model.password)
                    self.push(viewController: UIViewController(), animated: true)
                    DispatchQueue.main.async {
                        model.askID()
                    }
                } catch {
                    model.error = error.localizedDescription
                    model.alertType = .mainAlert
                    model.showAlert = true
                }
            }
        }, label: {
            Text("Sign In")
        })
        .primaryButtonStyle
    }
}

struct SignUpButton: View, MainNavigationController {
    @State var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            // Update to SignUpView()
            self.push(viewController: UIHostingController(rootView: SignInView()), animated: true)
        }, label: {
            Text("Create Account")
        })
        .primaryButtonStyle
    }
}

struct FaceIDButton: View {
    @State var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            // ViewModel FaceID Action
            Task {
                do {
                    try await model.faceID()
                } catch {
                    
                }
            }
        }, label: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Colors.black, lineWidth: 1)
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "faceid")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Colors.black)
                )
        })
        .secondaryButtonStyle
        .padding(.top, 14)
    }
}
