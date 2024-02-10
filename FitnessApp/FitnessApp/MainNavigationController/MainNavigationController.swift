//
//  RootNavigationController.swift
//  FitnessApp
//
//  Created by David on 1/24/24.
//

import UIKit
import SwiftUI

protocol MainNavigationController {
    // MARK: - Properties
    var rootNavigationController: UINavigationController? { get }
    
    // MARK: - Methods
    func push(viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)

}

extension MainNavigationController where Self:View {
    
    // MARK: - Properties
    var rootNavigationController: UINavigationController? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene as? UIWindowScene,
              let rootNavigationController = sceneDelegate.windows.first?.rootViewController
                as? UINavigationController else { return nil }
        
        return rootNavigationController
    }
    
    // MARK: - Methods
    func push(viewController: UIViewController, animated: Bool) {
        rootNavigationController?.pushViewController(viewController, animated: animated)
    }
    
    func present(viewController: UIViewController, animated: Bool) {
        rootNavigationController?.present(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        rootNavigationController?.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool) {
        rootNavigationController?.dismiss(animated: animated)
    }
}
