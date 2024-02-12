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
    
    // MARK: - Properties
    
    var settingsModel = ProfileViewModel.shared
    
    var dataUpdated: (()->Void)?
    var reload: (()->Void)?
    
    lazy var mainData: [Model] = breakfastData + lunchData + dinnerData + snackData {
        didSet {
            self.dataUpdated?()
            self.reload?()
            print("Data Updated")
        }
    }
    
    lazy var breakfastData: [Model] = retrieveModelData(forKey: "breakfastData") ?? [] {
        didSet {
            print("breakfastData Updated")
            storeModelData(breakfastData, forKey: "breakfastData")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    lazy var lunchData: [Model] = retrieveModelData(forKey: "lunchData") ?? [] {
        didSet {
            print("lunchData Updated")
            storeModelData(lunchData, forKey: "lunchData")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    lazy var dinnerData: [Model] = retrieveModelData(forKey: "dinnerData") ?? [] {
        didSet {
            storeModelData(dinnerData, forKey: "dinnerData")
            print("dinnerData Updated")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    lazy var snackData: [Model] = retrieveModelData(forKey: "snackData") ?? [] {
        didSet {
            storeModelData(snackData, forKey: "snackData")
            print("snackData Updated")
            mainData = breakfastData + lunchData + dinnerData + snackData
        }
    }
    
    // MARK: - Methods
    
    func storeBreakfastData(_ data: [Model]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            UserDefaults.standard.set(encodedData, forKey: "breakfastData")
        }
    }
    
    func retrieveBreakfastData() -> [Model]? {
        if let storedData = UserDefaults.standard.data(forKey: "breakfastData") {
            let decoder = JSONDecoder()
            if let breakfastData = try? decoder.decode([Model].self, from: storedData) {
                return breakfastData
            }
        }
        return nil
    }
    
    func storeModelData(_ data: [Model], forKey: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            UserDefaults.standard.set(encodedData, forKey: forKey)
        }
    }
    
    func retrieveModelData(forKey: String) -> [Model]? {
        if let storedData = UserDefaults.standard.data(forKey: forKey) {
            let decoder = JSONDecoder()
            if let breakfastData = try? decoder.decode([Model].self, from: storedData) {
                return breakfastData
            }
        }
        return nil
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
