//
//  SignInView.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import SwiftUI

struct SignInView: View, MainNavigationController {
    @StateObject private var model: SignInViewModel = SignInViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            LogoView()
            
            Spacer()
            Spacer()
            
            VStack(spacing: 12) {
                CustomTextFieldView(text: $model.email, placeholder: "Email")
                CustomSecureTextFieldView(text: $model.password, placeholder: "Password")
                ForgotButton(model: model)
            }
            .onAppear(perform: {
                model.clearForm()
                
            })
            
            Spacer()
            
            VStack(spacing: 12) {
                SignInButton(model: model)
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

private struct LogoView: View {
    var body: some View {
        Label {
            Text("Nutrition")
                .fontWeight(.bold)
        } icon: {
            //Image(systemName: "apple.logo")
        }
        .font(.system(size: 30))
        .foregroundStyle(.black)
        .padding(40)
    }
}

private struct ForgotButton: View {
    @ObservedObject var model: SignInViewModel
    
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
        .alert(isPresented: $model.forgotAlert) {
            Alert(title: Text("Important message"), message: Text(model.error), dismissButton: .default(Text("OK")))
        }
    }
}

private struct SignInButton: View, MainNavigationController {
    @ObservedObject var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await model.signIn(email: model.email, password: model.password)
                    model.pushNavigation = true
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
        .alert(isPresented: $model.showAlert) {
            switch model.alertType {
            case.IDAlert:
                Alert(title: Text("Face ID"), message: Text(model.alertType?.rawValue ?? ""),
                      primaryButton: .default(Text("Yes")) {
                    model.storeBiometricCredentials()
                },
                      secondaryButton: .default(Text("No")))
            case.mainAlert:
                Alert(title: Text("Important message"), message: Text(model.error), dismissButton: .default(Text("OK")))
            case.IDFail:
                Alert(title: Text("Face ID"), message: Text(model.alertType?.rawValue ?? ""), dismissButton: .default(Text("OK")))
            case .none:
                Alert(title: Text("Unknown Message"), message: Text("Unknown Error"), dismissButton: .default(Text("OK")))
            }
        }
        .onChange(of: model.pushNavigation) { oldValue, newValue in
            if newValue == true {
                self.push(viewController: MainView(), animated: true)
                model.pushNavigation = false
            }
        }
    }
}

private struct SignUpButton: View, MainNavigationController {
    @ObservedObject var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            // Update to SignUpView()
            self.push(viewController: UIHostingController(rootView: SignUpView()), animated: true)
        }, label: {
            Text("Create Account")
        })
        .primaryButtonStyle
    }
}

private struct FaceIDButton: View {
    @ObservedObject var model: SignInViewModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await model.faceID()
                } catch {
                    model.error = error.localizedDescription
                    model.alertType = .none
                    model.showAlert = true
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
