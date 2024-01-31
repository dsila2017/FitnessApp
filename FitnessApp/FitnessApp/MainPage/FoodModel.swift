//
//  FoodModel.swift
//  FitnessApp
//
//  Created by David on 1/29/24.
//

import UIKit

struct FoodModel {
    let name: FoodType
    let image: String
    let color: UIColor
    
    static var food: [FoodModel] = [
        FoodModel(name: .breakfast, image: "Breakfast.png", color: .darkText),
        FoodModel(name: .dinner, image: "Lunch.png", color: .darkText),
        FoodModel(name: .lunch, image: "Dinner.png", color: .darkText),
        FoodModel(name: .snack, image: "Snack.png", color: .darkText)
    ]
}
