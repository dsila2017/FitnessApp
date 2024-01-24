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
                ForgotButton()
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: {
                    //ViewModel Action
                    
                }, label: {
                    Text("Sign In")
                })
                .primaryButtonStyle
                
                SignUpButton()
                FaceIDButton()
                    .padding(.top, 14)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(AppColors.white)
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
    var body: some View {
        Button(action: {
            //ViewModel Action
            
        }, label: {
            Text("Forgot password?")
                .fontWeight(.thin)
                .foregroundStyle(AppColors.darkGray)
                .padding()
        })
    }
}

struct SignUpButton: View, MainNavigationController {
    var body: some View {
        Button(action: {
            self.push(viewController: UIHostingController(rootView: SignInView()), animated: true)
            
        }, label: {
            Text("Create Account")
        })
        .primaryButtonStyle
    }
}

struct FaceIDButton: View {
    var body: some View {
        Button(action: {
            // ViewModel FaceID Action
        }, label: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.black, lineWidth: 1)
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "faceid")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(AppColors.black)
                )
        })
        .secondaryButtonStyle
    }
}
