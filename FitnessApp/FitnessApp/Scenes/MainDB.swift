//
//  MainDB.swift
//  FitnessApp
//
//  Created by David on 2/10/24.
//

import Foundation
import NetworkManager2_0
import UIKit

final class MainDB {
    
    var settingsModel = ProfileViewModel.shared
    //static let shared = MainDB()
    
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
    
    func foodFetch(type: FoodType, food: String, weight: String? = "100") {
        let queryItem = weight! + "g" + " " + food
        let query = queryItem.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
}
