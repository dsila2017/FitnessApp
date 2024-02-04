//
//  ProductDetailsVC.swift
//  FitnessApp
//
//  Created by David on 2/3/24.
//

import UIKit

class ProductDetailsView: UIViewController {

    var model: Model = Model(name: "Apple", calories: 1.0, servingSizeG: 1.0, fatTotalG: 17.0, fatSaturatedG: 1.0, proteinG: 19.0, sodiumMg: 1, potassiumMg: 1, cholesterolMg: 1, carbohydratesTotalG: 24.0, fiberG: 1.0, sugarG: 1.0)
    
//    init(model: Model) {
//            self.model = model
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
    
    //Model(name: "Apple", calories: 1.0, servingSizeG: 1.0, fatTotalG: 17.0, fatSaturatedG: 1.0, proteinG: 19.0, sodiumMg: 1, potassiumMg: 1, cholesterolMg: 1, carbohydratesTotalG: 24.0, fiberG: 1.0, sugarG: 1.0)
    
    var proteinColor: UIColor = .proteinColor
    var carbsColor: UIColor = .carbsColor
    var fatsColor: UIColor = .fatsColor
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productName, progressView, nutritionStackView, nutritionalName, bottomStackView])
        stackView.setCustomSpacing(20, after: productName)
        stackView.setCustomSpacing(20, after: progressView)
        stackView.setCustomSpacing(30, after: nutritionStackView)
        stackView.setCustomSpacing(20, after: nutritionalName)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(proteinProgressView)
        view.addSubview(carbProgressView)
        view.addSubview(fatProgressView)
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [caloriesStack, servingSizeStack, sodiumStack, potassiumStack, cholesterolStack, fiberSizeStack, sugarStack, saturatedStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var proteinProgressView: CircularProgressView = {
        let diameter = 250
        let progressView = CircularProgressView(frame: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter), lineWidth: 24, rounded: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressColor = proteinColor
        progressView.trackColor = .lightGray
        progressView.progress = Float(model.proteinG) / Float(model.proteinG + model.carbohydratesTotalG + model.fatTotalG)
        //progressView.trackLayer.lineWidth = 20.0
        return progressView
    }()
    
    private lazy var carbProgressView: CircularProgressView = {
        let diameter = 180
        let progressView = CircularProgressView(frame: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter), lineWidth: 24, rounded: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressColor = carbsColor
        progressView.trackColor = .lightGray
        progressView.progress = Float(model.carbohydratesTotalG) / Float(model.proteinG + model.carbohydratesTotalG + model.fatTotalG)
        //progressView.trackLayer.lineWidth = 20.0
        return progressView
    }()
    
    lazy var fatProgressView: CircularProgressView = {
        let diameter = 100
        let progressView = CircularProgressView(frame: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter), lineWidth: 24, rounded: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressColor = fatsColor
        progressView.trackColor = .lightGray
        progressView.progress = Float(model.fatTotalG) / Float(model.proteinG + model.carbohydratesTotalG + model.fatTotalG)
        //progressView.trackLayer.lineWidth = 20.0
        return progressView
    }()
    
    private lazy var nutritionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [proteinStackView, carbsStackView, fatStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var proteinStackView = {
        var protein = Int(model.proteinG )
        var stack = createStackView(imageName: "circle.fill", imageColor: proteinColor, labelName: "Protein", gram: model.proteinG)
        return stack
    }()
    
    lazy var carbsStackView = {
        let carbs = Int(model.proteinG )
        let stack = createStackView(imageName: "circle.fill", imageColor: carbsColor, labelName: "Carbs", gram: model.carbohydratesTotalG)
        return stack
    }()
    
    lazy var fatStackView = {
        let fats = Int(model.proteinG )
        let stack = createStackView(imageName: "circle.fill", imageColor: fatsColor, labelName: "Fats", gram: model.fatTotalG)
        return stack
    }()
    
    lazy var button = {
        let button = UIButton()
        button.addAction(UIAction(handler: { _ in
            print("x")
        }), for: .touchUpInside)
        return button
    }()
    
    
    
//    private lazy var nutritionInfoStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [caloriesStack, servingSizeStack])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .gray
//        return stackView
//    }()
    
    lazy var caloriesStack = {
        let stack = createNutri(nutriName: "Calories:", value: model.calories)
        return stack
    }()
    
    lazy var servingSizeStack = {
        let stack = createNutri(nutriName: "Serving Size:", value: model.servingSizeG)
        return stack
    }()
    
    lazy var sodiumStack = {
        let stack = createNutri(nutriName: "Sodium:", value: Double(model.sodiumMg))
        return stack
    }()
    
    lazy var potassiumStack = {
        let stack = createNutri(nutriName: "Potassium:", value: Double(model.potassiumMg))
        return stack
    }()
    
    lazy var cholesterolStack = {
        let stack = createNutri(nutriName: "Cholesterol:", value: Double(model.cholesterolMg))
        return stack
    }()
    
    lazy var fiberSizeStack = {
        let stack = createNutri(nutriName: "Fiber:", value: model.fiberG)
        return stack
    }()
    
    lazy var sugarStack = {
        let stack = createNutri(nutriName: "Sugar:", value: model.sugarG)
        return stack
    }()
    
    lazy var saturatedStack = {
        let stack = createNutri(nutriName: "Saturated Fat:", value: model.fatSaturatedG)
        return stack
    }()
    
    lazy var productName = {
        let label = UILabel()
        label.text = model.name
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    lazy var nutritionalName = {
        let label = UILabel()
        label.text = "Nutritional Information"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            progressView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.34),
            
            proteinProgressView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            proteinProgressView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            
            carbProgressView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            carbProgressView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            
            fatProgressView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            fatProgressView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            
            nutritionStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.03),
            
            
            
        ])
    }
    
    private func createStackView(imageName: String, imageColor: UIColor, labelName: String, gram: Double) -> UIStackView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: imageName)?.applyingSymbolConfiguration(.init(pointSize: 10))
        imageView.tintColor = imageColor
        
        let view = UIView()
        view.addSubview(imageView)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let label = UILabel()
        label.text = labelName + " " + String(gram) + "g"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        lazy var stackView = UIStackView(arrangedSubviews: [view, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        view.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2).isActive = true
        
        return stackView
    }
    
    private func createNutri(nutriName: String, value: Double) -> UIStackView {
        let nutriLabel = UILabel()
        nutriLabel.translatesAutoresizingMaskIntoConstraints = false
        nutriLabel.text = nutriName
        nutriLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let nutriView = UIView()
        nutriView.addSubview(nutriLabel)
        //nutriLabel.centerXAnchor.constraint(equalTo: nutriView.centerXAnchor).isActive = true
        nutriLabel.centerYAnchor.constraint(equalTo: nutriView.centerYAnchor).isActive = true
        nutriLabel.leadingAnchor.constraint(equalTo: nutriView.leadingAnchor, constant: 20).isActive = true
        
        let values = UILabel()
        values.translatesAutoresizingMaskIntoConstraints = false
        values.text = String(value)
        values.font = UIFont.boldSystemFont(ofSize: 16)
        
        let valuesView = UIView()
        valuesView.addSubview(values)
        //values.centerXAnchor.constraint(equalTo: valuesView.centerXAnchor).isActive = true
        values.centerYAnchor.constraint(equalTo: valuesView.centerYAnchor).isActive = true
        values.trailingAnchor.constraint(equalTo: valuesView.trailingAnchor, constant: -20).isActive = true
        
        lazy var stackView = UIStackView(arrangedSubviews: [nutriView, valuesView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
}