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
    
    @Published var gender = 0
    
    @Published var nickname = ""
    
    @Published var weight = ""
    
    @Published var calories = ""
    
    @Published var backgroundColor = Color(UIColor.white)
    
    @Published var mainProgressColor = Color(UIColor.darkText)
    
    @Published var mainProgressTrackColor = Color(UIColor.lightGray)
    
    var settingsUpdated: (()->Void)?
    
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
    
    func button() {
        settingsUpdated?()
    }
}
