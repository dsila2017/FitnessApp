//
//  MainModel.swift
//  FitnessApp
//
//  Created by David on 1/31/24.
//

import Foundation

struct Model: Codable {
    var name: String
    let calories, servingSizeG, fatTotalG, fatSaturatedG: Double
    let proteinG: Double
    let sodiumMg, potassiumMg, cholesterolMg: Int
    let carbohydratesTotalG, fiberG, sugarG: Double

    enum CodingKeys: String, CodingKey {
        case name, calories
        case servingSizeG = "serving_size_g"
        case fatTotalG = "fat_total_g"
        case fatSaturatedG = "fat_saturated_g"
        case proteinG = "protein_g"
        case sodiumMg = "sodium_mg"
        case potassiumMg = "potassium_mg"
        case cholesterolMg = "cholesterol_mg"
        case carbohydratesTotalG = "carbohydrates_total_g"
        case fiberG = "fiber_g"
        case sugarG = "sugar_g"
    }
}
