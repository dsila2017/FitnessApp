//
//  MainTableViewCell.swift
//  FitnessApp
//
//  Created by David on 2/1/24.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    var model: Model = Model(name: "Apple", calories: 449.0, servingSizeG: 1.0, fatTotalG: 42.0, fatSaturatedG: 1.0, proteinG: 27.0, sodiumMg: 1, potassiumMg: 1, cholesterolMg: 1, carbohydratesTotalG: 32.0, fiberG: 1.0, sugarG: 1.0)
    private var textColor: UIColor = .black
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.tertiaryLabel.withAlphaComponent(0.1)
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, caloriesStackView])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [proteinStackView, carbsStackView, fatsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var caloriesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weightLabel, kCalLabel])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var kCalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "100g"
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var proteinStackView = {
        let stackView = UIStackView(arrangedSubviews: [proteinDummy, proteinLabelStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var proteinLabelStackView = {
        let stackView = UIStackView(arrangedSubviews: [proteinQuantity, protein])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var protein: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Protein"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var proteinQuantity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var proteinProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.7, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .darkText
        return progressView
    }()
    
    private lazy var proteinDummy: UIView = {
        let view = UIView()
        view.addSubview(proteinProgress)
        return view
    }()
    
    private lazy var carbsStackView = {
        let stackView = UIStackView(arrangedSubviews: [carbDummy, carbsLabelStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var carbsLabelStackView = {
        let stackView = UIStackView(arrangedSubviews: [carbsQuantity, carbs])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var carbs: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carbs"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var carbsQuantity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private var carbsProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.4, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .darkText
        return progressView
    }()
    
    private lazy var carbDummy: UIView = {
        let view = UIView()
        view.addSubview(carbsProgress)
        return view
    }()
    
    private lazy var fatsStackView = {
        let stackView = UIStackView(arrangedSubviews: [fatsDummy, fatsLabelStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var fatsLabelStackView = {
        let stackView = UIStackView(arrangedSubviews: [fatsQuantity, fats])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var fats: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fats"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private lazy var fatsQuantity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }()
    
    private var fatsProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(1.0, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .darkText
        return progressView
    }()
    
    private lazy var fatsDummy: UIView = {
        let view = UIView()
        view.addSubview(fatsProgress)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = ""
        self.weightLabel.text = ""
        self.kCalLabel.text = ""
        self.proteinQuantity.text = ""
        self.carbsQuantity.text = ""
        self.fatsQuantity.text = ""
        
        self.proteinProgress.progress = 0.0
        self.carbsProgress.progress = 0.0
        self.fatsProgress.progress = 0.0
    }
    
    func updateUI() {
        self.label.text = model.name
        self.weightLabel.text = "\(model.servingSizeG.description) g"
        self.kCalLabel.text = "\(model.calories.description) kCal"
        self.proteinQuantity.text = model.proteinG.description
        self.carbsQuantity.text = model.carbohydratesTotalG.description
        self.fatsQuantity.text = model.fatTotalG.description
        
        self.proteinProgress.progress = Float(model.proteinG) / Float(model.proteinG + model.carbohydratesTotalG + model.fatTotalG)
        self.carbsProgress.progress = Float(model.carbohydratesTotalG) / Float(model.proteinG + model.carbohydratesTotalG + model.fatTotalG)
        self.fatsProgress.progress = Float(model.fatTotalG) / Float(model.proteinG + model.carbohydratesTotalG + model.fatTotalG)
    }
    
    private func setupUI() {
        addSubview(mainView)
        setupConstraints()
        backgroundColor = .clear
        selectedBackgroundView?.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
            
            proteinProgress.centerXAnchor.constraint(equalTo: proteinDummy.centerXAnchor),
            proteinProgress.centerYAnchor.constraint(equalTo: proteinDummy.centerYAnchor),
            proteinProgress.widthAnchor.constraint(equalTo: proteinDummy.heightAnchor, multiplier: 0.7),
            proteinDummy.widthAnchor.constraint(equalTo: proteinStackView.widthAnchor, multiplier: 0.3),
            
            carbsProgress.centerXAnchor.constraint(equalTo: carbDummy.centerXAnchor),
            carbsProgress.centerYAnchor.constraint(equalTo: carbDummy.centerYAnchor),
            carbsProgress.widthAnchor.constraint(equalTo: carbDummy.heightAnchor, multiplier: 0.7),
            carbDummy.widthAnchor.constraint(equalTo: carbsStackView.widthAnchor, multiplier: 0.3),
            
            fatsProgress.centerXAnchor.constraint(equalTo: fatsDummy.centerXAnchor),
            fatsProgress.centerYAnchor.constraint(equalTo: fatsDummy.centerYAnchor),
            fatsProgress.widthAnchor.constraint(equalTo: fatsDummy.heightAnchor, multiplier: 0.7),
            fatsDummy.widthAnchor.constraint(equalTo: fatsStackView.widthAnchor, multiplier: 0.3),
            
        ])
        
        proteinProgress.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        carbsProgress.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        fatsProgress.transform = CGAffineTransform(rotationAngle: -.pi / 2)
    }
    
}
