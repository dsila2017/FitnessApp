//
//  MainPageViewModel.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import Foundation
import UIKit

final class MainPageViewModel {
    
    // MARK: - Private Properties
    
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
    
    // MARK: - Init
    
    init(mainDB: MainDB) {
        self.mainDB = mainDB
        self.name = "Username"
        self.allowedCalories = 2500
        self.allowedProtein = 0
        self.allowedCarbs = 0
        self.allowedFats = 0
    }
    
    // MARK: - Properties
    
    func fetchCaloriesLimit() {
        self.allowedCalories = Int(settingsModel.calories) ?? 0
    }
    
    func calcNutrition(type: NutritionType) -> Int {
        switch type {
        case.Calories:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.calories
            }
            return Int(result)
        case .Protein:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.proteinG
            }
            return Int(result)
        case .Carbs:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.carbohydratesTotalG
            }
            return Int(result)
        case .Fats:
            let result = mainDB.mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.fatTotalG
            }
            return Int(result)
        }
    }
    
    func calcProgress(type: NutritionType) -> Float {
        var finalResult: Float = 0.0
        switch type {
        case .Calories:
            finalResult = Float(calcNutrition(type: .Calories)) / Float(allowedCalories)
        case .Protein:
            finalResult = Float(calcNutrition(type: .Protein)) / Float(Double(allowedCalories / 4) * 0.4)
        case .Carbs:
            finalResult = Float(calcNutrition(type: .Carbs)) / Float(Double(allowedCalories / 4) * 0.3)
        case .Fats:
            finalResult = Float(calcNutrition(type: .Fats)) / Float(Double(allowedCalories / 9) * 0.3)
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
