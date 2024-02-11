//
//  AddView.swift
//  FitnessApp
//
//  Created by David on 2/1/24.
//

import Foundation
import UIKit
import SwiftUI

class AddProductView: UIViewController {
    
    private var settingsModel = ProfileViewModel.shared

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [foodLabel, mainImageView, foodNameLabel, foodNameDummyView, scaleImageView, foodWeightLabel, foodWeightDummyView, addButtonDummyView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(16, after: foodNameDummyView)
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let foodLabel: UILabel = {
        let label = UILabel()
        label.text = "Track Food"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var foodNameDummyView: UIView = {
        let view = UIView()
        view.addSubview(foodTextField)
        return view
    }()
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let foodTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Food Name"
        textField.layer.cornerRadius = 24
        textField.backgroundColor = UIColor.tertiaryLabel.withAlphaComponent(0.1)
        textField.returnKeyType = .done
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.heightAnchor.hashValue))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var foodWeightDummyView: UIView = {
        let view = UIView()
        view.addSubview(WeightTextField)
        return view
    }()
    
    private let foodWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Weight (g)"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let WeightTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Food Weight"
        textField.layer.cornerRadius = 24
        textField.backgroundColor = UIColor.tertiaryLabel.withAlphaComponent(0.1)
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.heightAnchor.hashValue))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var addButtonDummyView: UIView = {
        let view = UIView()
        view.addSubview(button)
        return view
    }()
    
    private lazy var button: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Save"
        configuration.cornerStyle = .capsule
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self]_ in
            guard let foodNameString = self?.foodTextField.text, let weight = self?.WeightTextField.text  else { return }
            guard foodNameString.count > 0 else { return }
            self?.delegate?.fetchData(food: foodNameString, weight: weight)
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private var mainImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 25
        image.image = UIImage(named: "Track")
        return image
    }()
    
    private var scaleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 25
        image.image = UIImage(named: "Weight")
        return image
    }()
    
    var delegate: addViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(mainStackView)
        view.backgroundColor = UIColor(settingsModel.backgroundColor)
        foodTextField.delegate = self
        WeightTextField.delegate = self
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            foodLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14),
            
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            scaleImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            foodTextField.centerXAnchor.constraint(equalTo: foodNameDummyView.centerXAnchor),
            foodTextField.centerYAnchor.constraint(equalTo: foodNameDummyView.centerYAnchor),
            foodTextField.widthAnchor.constraint(equalTo: foodNameDummyView.widthAnchor, multiplier: 0.9),
            foodTextField.heightAnchor.constraint(equalTo: foodNameDummyView.heightAnchor, multiplier: 0.6),
            
            WeightTextField.centerXAnchor.constraint(equalTo: foodWeightDummyView.centerXAnchor),
            WeightTextField.centerYAnchor.constraint(equalTo: foodWeightDummyView.centerYAnchor),
            WeightTextField.widthAnchor.constraint(equalTo: foodWeightDummyView.widthAnchor, multiplier: 0.9),
            WeightTextField.heightAnchor.constraint(equalTo: foodWeightDummyView.heightAnchor, multiplier: 0.6),
            
            foodNameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            foodWeightLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            foodNameDummyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            foodWeightDummyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            button.centerXAnchor.constraint(equalTo: addButtonDummyView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: addButtonDummyView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: addButtonDummyView.widthAnchor, multiplier: 0.4),
            button.heightAnchor.constraint(equalToConstant: 56.0)
            
        ])
    }
}

extension AddProductView: UITextFieldDelegate {
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
