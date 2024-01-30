//
//  MainPageViewModel.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import Foundation
import UIKit

final class MainPageViewModel {
    
    func setupDateButton(button: UIButton) {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let nameOfMonth = dateFormatter.string(from: now)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "LLL"
        let nameOfMonth1 = dateFormatter1.string(from: now)
        
        button.configuration?.title = nameOfMonth
        button.configuration?.subtitle = nameOfMonth1
    }
}
