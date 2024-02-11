//
//  MainPageViewModel.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import Foundation
import UIKit

final class MainPageViewModel {
    
    private var mainDB: MainDB
    private let settingsModel = ProfileViewModel.shared
    private var allowedProtein: Int
    private var allowedCarbs: Int
    private var allowedFats: Int
    
    var dataUpdated: (()->Void)?
    var name: String {
        didSet {
            self.dataUpdated?()
        }
    }
    var allowedCalories: Int {
        didSet {
            self.dataUpdated?()
            allowedProtein = Int(Double(allowedCalories / 4) * 0.4)
            allowedCarbs = Int(Double(allowedCalories / 4) * 0.3)
            allowedFats = Int(Double(allowedCalories / 9) * 0.3)
        }
    }
    
    init(mainDB: MainDB) {
        self.mainDB = mainDB
        self.name = "Username"
        self.allowedCalories = 2500
        self.allowedProtein = 0
        self.allowedCarbs = 0
        self.allowedFats = 0
    }
    
    func fetchCaloriesLimit() {
        self.allowedCalories = Int(settingsModel.calories) ?? 0
    }
    
    func calcCalories() -> Int {
        let result = mainDB.mainData.reduce(0.0) { partialResult, model in
            return partialResult + model.calories
        }
        return Int(result)
    }
    
    func calcProgress(type: NutritionType) -> Float {
        var finalResult: Float = 0.0
        switch type {
        case .Calories:
            finalResult = Float(calcCalories()) / Float(allowedCalories)
        case .Protein:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.proteinG
            }
            finalResult = Float(result) / Float(allowedProtein)
        case .Carbs:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.carbohydratesTotalG
            }
            finalResult = Float(result) / Float(allowedCarbs)
        case .Fats:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.fatTotalG
            }
            finalResult = Float(result) / Float(allowedFats)
        }
        return finalResult
    }
    
    func calcTypeCalories(type: FoodType) -> Int {
        var result = 0
        switch type {
        case .breakfast:
            result = mainDB.breakfastData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        case .lunch:
            result = mainDB.lunchData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        case .dinner:
            result = mainDB.dinnerData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        case .snack:
            result = mainDB.snackData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        }
        return Int(result)
    }
    
    func setupDateButton(button: UIButton) {
        let now = Date()
        let dateDayFormatter = DateFormatter()
        dateDayFormatter.dateFormat = "d"
        let dayOfMonth = dateDayFormatter.string(from: now)
        
        let dateMonthFormatter = DateFormatter()
        dateMonthFormatter.dateFormat = "LLL"
        let nameOfMonth = dateMonthFormatter.string(from: now)
        
        button.configuration?.title = dayOfMonth
        button.configuration?.titleAlignment = .center
        button.configuration?.subtitle = nameOfMonth
    }
}

enum FoodType: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

enum NutritionType: String {
    case Calories = "Calories"
    case Protein = "Protein"
    case Carbs = "Carbs"
    case Fats = "Fats"
}
