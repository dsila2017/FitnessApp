//
//  MainPageViewModel.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import Foundation
import NetworkManager2_0
import UIKit

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

final class MainPageViewModel {
    var allowedCalories = 2740
    var allowedProtein = 10
    var allowedCarbs = 100
    var allowedFats = 10
    
    var dataUpdated: (()->Void)?
    var reload: (()->Void)?
    
    lazy var mainData: [Model] = breakfastData + lunchData + dinnerData + snackData {
        didSet {
            self.dataUpdated?()
            self.reload?()
            print("Data Updated")
        }
    }
    
    var breakfastData: [Model] = [] {
        didSet {
            print("breakfastData Updated")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    var lunchData: [Model] = [] {
        didSet {
            print("lunchData Updated")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    var dinnerData: [Model] = [] {
        didSet {
            print("dinnerData Updated")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    var snackData: [Model] = [] {
        didSet {
            print("snackData Updated")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    func foodFetch(type: FoodType, food: String) {
        let query = food.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let string = "https://api.api-ninjas.com/v1/nutrition?query=" + "\(query)"
        
        NetworkManager2_0.NetworkManager.shared.fetchData(url: string, apiKey: "D4mxCWylaJ1eZRLj3A8Igg==E3BevRxVIsFkXpKb") { [weak self] (result: Result<[Model], Error>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    switch type {
                    case.breakfast:
                        self?.breakfastData.append(contentsOf: model)
                    case .lunch:
                        self?.lunchData.append(contentsOf: model)
                    case .dinner:
                        self?.dinnerData.append(contentsOf: model)
                    case .snack:
                        self?.snackData.append(contentsOf: model)
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func calcCalories() -> Int {
        let result = mainData.reduce(0.0) { partialResult, model in
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
            let result = mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.proteinG
            }
            finalResult = Float(result) / Float(allowedProtein)
        case .Carbs:
            let result = mainData.reduce(0.0) { partialResult, model in
                return partialResult + model.carbohydratesTotalG
            }
            finalResult = Float(result) / Float(allowedCarbs)
        case .Fats:
            let result = mainData.reduce(0.0) { partialResult, model in
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
            result = breakfastData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        case .lunch:
            result = lunchData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        case .dinner:
            result = dinnerData.reduce(0) { partialResult, model in
                return partialResult + Int(model.calories)
            }
        case .snack:
            result = snackData.reduce(0) { partialResult, model in
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
