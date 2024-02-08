//
//  MainView.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import UIKit

class MainView: UIViewController {
    
    private var model: MainPageViewModel = MainPageViewModel()
    private let spacing: CGFloat = 14.0
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [ProfileStackView, ProgressStackView, nutritionStackView, mealsLabel, mainCollectionView])
        stackView.setCustomSpacing(24, after: ProfileStackView)
        stackView.setCustomSpacing(24, after: ProgressStackView)
        stackView.setCustomSpacing(24, after: nutritionStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private lazy var ProfileStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileDummy, usernameStack, calendarDummy])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let profileDummy = UIView()
    
    private lazy var profileButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "person.crop.circle.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 40))
        configuration.cornerStyle = .capsule
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.model.foodFetch(type: .lunch, food: "apple")
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var calendarButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .medium
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.model.foodFetch(type: .breakfast, food: "orange")
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var usernameStack = {
        let stackView = UIStackView(arrangedSubviews: [helloLabel, usernameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let calendarDummy = UIView()
    
    let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello,"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Katherine"
        return label
    }()
    
    private lazy var ProgressStackView = {
        let stackView = UIStackView(arrangedSubviews: [dummyProgressView])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mealsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Meals"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let dummyProgressView = UIView()
    
    lazy var progressView: CircularProgressView = {
        let diameter = 250
        let progressView = CircularProgressView(frame: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter), lineWidth: 24, rounded: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressColor = .darkText
        progressView.trackColor = .lightGray
        progressView.progress = 0.0
        
        progressView.addSubview(calories)
        progressView.addSubview(caloriesLimit)
        return progressView
    }()
    
    private lazy var calories: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(self.model.calcCalories())"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var caloriesLimit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "of \(self.model.allowedCalories) kCal"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var nutritionStackView = {
        let stackView = UIStackView(arrangedSubviews: [proteinStackView, carbsStackView, fatsStackView])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var proteinStackView = {
        let stackView = UIStackView(arrangedSubviews: [protein, proteinDummy])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private var protein: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Protein"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var proteinProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .darkText
        return progressView
    }()
    
    private lazy var carbsStackView = {
        let stackView = UIStackView(arrangedSubviews: [carbs, carbDummy])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private var carbs: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "carbs"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private var carbsProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .darkText
        return progressView
    }()
    
    private lazy var fatsStackView = {
        let stackView = UIStackView(arrangedSubviews: [fats, fatDummy])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private var fats: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fats"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private var fatsProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .darkText
        return progressView
    }()
    
    private lazy var proteinDummy: UIView = {
        let view = UIView()
        view.addSubview(proteinProgress)
        return view
    }()
    
    private lazy var carbDummy: UIView = {
        let view = UIView()
        view.addSubview(carbsProgress)
        return view
    }()
    
    private lazy var fatDummy: UIView = {
        let view = UIView()
        view.addSubview(fatsProgress)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        model.setupDateButton(button: calendarButton)
        setupUI()
        
        self.model.dataUpdated = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.configure()
            }
        }
    }
    
    private func configure() {
        self.calories.text = String((self.model.calcCalories()))
        self.progressView.progress = (self.model.calcProgress(type: .Calories))
        self.proteinProgress.setProgress(self.model.calcProgress(type: .Protein), animated: true)
        self.carbsProgress.setProgress(self.model.calcProgress(type: .Carbs), animated: true)
        self.fatsProgress.setProgress(self.model.calcProgress(type: .Fats), animated: true)
        
        self.mainCollectionView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(mainStackView)
        calendarDummy.addSubview(calendarButton)
        profileDummy.addSubview(profileButton)
        dummyProgressView.addSubview(progressView)
        
        setupConstraints()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            mealsLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 24),
            
            ProfileStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.08),
            ProfileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            ProgressStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            calendarButton.centerXAnchor.constraint(equalTo: calendarDummy.centerXAnchor),
            calendarButton.centerYAnchor.constraint(equalTo: calendarDummy.centerYAnchor),
            calendarButton.widthAnchor.constraint(equalToConstant: 44),
            calendarButton.heightAnchor.constraint(equalToConstant: 56),
            
            profileButton.centerXAnchor.constraint(equalTo: profileDummy.centerXAnchor),
            profileButton.centerYAnchor.constraint(equalTo: profileDummy.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 50),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            
            profileDummy.widthAnchor.constraint(equalTo: ProfileStackView.widthAnchor, multiplier: 0.2),
            calendarDummy.widthAnchor.constraint(equalTo: ProfileStackView.widthAnchor, multiplier: 0.2),
            
            progressView.centerXAnchor.constraint(equalTo: dummyProgressView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: dummyProgressView.centerYAnchor),
            
            calories.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            calories.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: -10),
            
            caloriesLimit.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            caloriesLimit.topAnchor.constraint(equalTo: calories.bottomAnchor, constant: 10),
            
            proteinProgress.centerXAnchor.constraint(equalTo: proteinDummy.centerXAnchor),
            proteinProgress.centerYAnchor.constraint(equalTo: proteinDummy.centerYAnchor),
            proteinProgress.widthAnchor.constraint(equalToConstant: 70),
            proteinProgress.heightAnchor.constraint(equalToConstant: 10),
            
            carbsProgress.centerXAnchor.constraint(equalTo: carbDummy.centerXAnchor),
            carbsProgress.centerYAnchor.constraint(equalTo: carbDummy.centerYAnchor),
            carbsProgress.widthAnchor.constraint(equalToConstant: 70),
            carbsProgress.heightAnchor.constraint(equalToConstant: 10),
            
            fatsProgress.centerXAnchor.constraint(equalTo: fatDummy.centerXAnchor),
            fatsProgress.centerYAnchor.constraint(equalTo: fatDummy.centerYAnchor),
            fatsProgress.widthAnchor.constraint(equalToConstant: 70),
            fatsProgress.heightAnchor.constraint(equalToConstant: 10),
            
            nutritionStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.04),
            
        ])
    }
}

extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FoodModel.food.count
    }
}

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        cell?.mainLabel.text = FoodModel.food[indexPath.row].name.rawValue
        cell?.imageView.image = UIImage(named: FoodModel.food[indexPath.row].image)
        cell?.stackView.backgroundColor = FoodModel.food[indexPath.row].color
        switch FoodModel.food[indexPath.row].name {
        case .breakfast:
            cell?.calorieLabel.text = String(self.model.calcTypeCalories(type: .breakfast))
        case .lunch:
            cell?.calorieLabel.text = String(self.model.calcTypeCalories(type: .lunch))
        case .dinner:
            cell?.calorieLabel.text = String(self.model.calcTypeCalories(type: .dinner))
        case .snack:
            cell?.calorieLabel.text = String(self.model.calcTypeCalories(type: .snack))
        }
        
        return cell!
        //}
        //return UICollectionViewCell()
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = spacing
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        let width = (mainCollectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        let height = (mainCollectionView.bounds.height - totalSpacing) / numberOfItemsPerRow / 1.10
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //            let vc = MainView()
        //            vc.configure(with: FoodModel.food[indexPath.row])
        //            navigationController?.pushViewController(vc, animated: true)
        print(FoodModel.food[indexPath.row].name)
        
        let vc = ProductListView(model: model)
        //            vc.configure(with: FoodModel.food[indexPath.row])
        //navigationController?.pushViewController(vc, animated: true)
        switch FoodModel.food[indexPath.row].name {
        case .breakfast:
            //let vc = AddProduct(model: MainPageViewModel())
            
            //vc.data = model.breakfastData
            vc.type = .breakfast
            navigationController?.pushViewController(vc, animated: true)
        case .lunch:
            //vc.data = model.lunchData
            vc.type = .lunch
            navigationController?.pushViewController(vc, animated: true)
        case .dinner:
            vc.type = .dinner
            navigationController?.pushViewController(vc, animated: true)
        case .snack:
            vc.type = .snack
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
