//
//  ProfileViewModel.swift
//  FitnessApp
//
//  Created by David on 2/9/24.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    static let shared = ProfileViewModel()
    
    // MARK: - Properties
    
    @Published var gender = 0
    
    @Published var nickname = "Username"
    
    @Published var weight = ""
    
    @Published var calories = "2500"
    
    @Published var backgroundColor = Color(UIColor.white)
    
    @Published var mainProgressColor = Color(UIColor.darkText)
    
    @Published var mainProgressTrackColor = Color(UIColor.lightGray)
    
    var settingsUpdated: (()->Void)?
    
    // MARK: -  Init
    
    private init() {}
    
    func calculateCalories() -> Int {
        switch gender {
        case 0:
            if Int(weight) ?? 0 >= 80 {
                return 2900
            } else {
                return 2500
            }
        case 1:
            if Int(weight) ?? 0 >= 80 {
                return 2400
            } else {
                return 2000
            }
        default:
            return 0
        }
    }
    
    // MARK: -  Methods
    
    func updateUserDefaults() {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
        self.nickname = nickname
        
        guard let weight = UserDefaults.standard.string(forKey: "weight") else { return }
        self.weight = weight
        
        guard let calories = UserDefaults.standard.string(forKey: "calories") else { return }
        self.calories = calories
        
        settingsUpdated?()
    }
    
    func button() {
        
        
        //UserDefaults.standard.set(gender, forKey: "gender")
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(calories, forKey: "calories")
        
        settingsUpdated?()
    }
}
