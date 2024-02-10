//
//  MainPageViewModel.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import Foundation
import NetworkManager2_0
import UIKit

final class MainPageViewModel {
    
    var mainDB: MainDB
    var settingsModel = ProfileViewModel.shared
    
    var allowedCalories = 2500 {
        didSet {
            self.dataUpdated?()
            print("THis happended too")
            allowedProtein = Int(Double(allowedCalories / 4) * 0.4)
            allowedCarbs = Int(Double(allowedCalories / 4) * 0.3)
            allowedFats = Int(Double(allowedCalories / 9) * 0.3)
        }
    }
    
    lazy var allowedProtein = 0
    lazy var allowedCarbs = 0
    lazy var allowedFats = 0
    
    var name = "Username" {
        didSet {
            print("Data Name")
            self.dataUpdated?()
        }
    }
    
    var dataUpdated: (()->Void)?
    
    init(mainDB: MainDB) {
            self.mainDB = mainDB
//            self.name = "Username" // Default value for name
//            self.allowedCalories = 2500 // Default value for allowedCalories
//            self.allowedProtein = 0 // Default value for allowedProtein
//            self.allowedCarbs = 0 // Default value for allowedCarbs
//            self.allowedFats = 0 // Default value for allowedFats
        }
    
    func fetchCaloriesLimit() {
        print("Fetch Happened")
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
