//
//  ProfileView.swift
//  FitnessApp
//
//  Created by David on 2/8/24.
//

import SwiftUI

struct ProfileView: View, MainNavigationController {
    
    // MARK: - Properties
    
    @StateObject var model = ProfileViewModel.shared
    @State var text = ""
    @State private var gender = 0
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {
            
            Spacer()
            Spacer()
            
            HStack {
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text("Settings")
                    .font(.title.bold())
                    .alignmentGuide(HorizontalAlignment.center) { dimension in
                        dimension[.trailing]
                    }
                Spacer()
                Button(action: {
                    self.dismiss(animated: true)
                    self.popToRoot(animated: true)
                }, label: {
                    Text("Log Out")
                })
                .buttonStyle(.borderless)
                Spacer()
            }
            
            VStack {
                LottieView(animationName: "profileSettings")
                    .frame(maxWidth: 120, maxHeight: 120)
            }
            
            ScrollView {
                
                VStack{
                    Text("Nickname")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    CustomTextFieldView(text: $model.nickname, placeholder: "Nickname")
                    Text("Weight(kg)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                    CustomTextFieldView(text: $model.weight, placeholder: "Weight")
                    Text("Suggested Calories Limit \(model.calculateCalories())")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                        .onChange(of: model.calculateCalories()) { oldValue, newValue in
                            model.calories = String(newValue)
                        }
                    CustomTextFieldView(text: $model.calories, placeholder: "Calories")
                }
                .padding()
                .font(.subheadline.bold())
                
                Picker(selection: $model.gender, label: Text("Select Gender")) {
                    Text("Male").tag(0)
                    Text("Female").tag(1)
                }
                .padding()
                .pickerStyle(.segmented)
                .onChange(of: model.gender) { oldValue, newValue in
                    model.gender = newValue
                }
                
                ColorPicker("Background Color:", selection: $model.backgroundColor)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .font(.headline.bold())
                
                ColorPicker("Progress Color:", selection: $model.mainProgressColor)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .font(.headline.bold())
                
                ColorPicker("Track Color:", selection: $model.mainProgressTrackColor)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .font(.headline.bold())
            }
            
            Button(action: {
                self.model.button()
                self.dismiss(animated: true)
            }, label: {
                Text("Save")
            })
            .primaryButtonStyle
            .padding(.horizontal, 120)
            .onAppear(perform: {
                model.updateUserDefaults()
            })
        }
        .background(model.backgroundColor)
    }
}

#Preview {
    ProfileView()
}
