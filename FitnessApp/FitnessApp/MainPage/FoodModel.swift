//
//  FoodModel.swift
//  FitnessApp
//
//  Created by David on 1/29/24.
//

import UIKit

struct FoodModel {
    let name: String
    let image: String
    let color: UIColor
    
    static var food: [FoodModel] = [
        FoodModel(name: "Breakfast", image: "Breakfast.png", color: .darkText),
        FoodModel(name: "Lunch", image: "Lunch.png", color: .darkText),
        FoodModel(name: "Dinner", image: "Dinner.png", color: .darkText),
        FoodModel(name: "Snack", image: "Snack.png", color: .darkText)
    ]
}
