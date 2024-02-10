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
    
    @Published var gender = 0 {
        didSet {
            settingsUpdated?()
        }
    }
    
    @Published var nickname = "" {
        didSet {
            settingsUpdated?()
        }
    }
    
    @Published var weight = "" {
        didSet {
            settingsUpdated?()
        }
    }
    
    @Published var calories = "" {
        didSet {
            settingsUpdated?()
        }
    }
    
    @Published var backgroundColor = Color(UIColor.white) {
        didSet {
            settingsUpdated?()
        }
    }
    
    @Published var mainProgressColor = Color(UIColor.darkText) {
        didSet {
            settingsUpdated?()
        }
    }
    
    @Published var mainProgressTrackColor = Color(UIColor.lightGray) {
        didSet {
            settingsUpdated?()
        }
    }
    
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
}
