//
//  MainView.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import UIKit
import SwiftUI

final class MainView: UIViewController {
    
    // MARK: - Private Properties
    
    private var mainDB = MainDB()
    private lazy var model: MainPageViewModel = MainPageViewModel(mainDB: mainDB)
    private var settingsModel = ProfileViewModel.shared
    private let spacing: CGFloat = 14.0
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [ProfileStackView, ProgressStackView, nutritionStackView, mealsLabel, mainCollectionView])
        stackView.setCustomSpacing(24, after: ProfileStackView)
        stackView.setCustomSpacing(24, after: ProgressStackView)
        stackView.setCustomSpacing(24, after: nutritionStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var ProfileStackView = {
        let stackView = UIStackView(arrangedSubviews: [settingsView, usernameStack, ActivityView, dummyDummy])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var dummyDummy = UIView()
    
    private var settingsView: UIView = {
        let lottieView = LottieView(animationName: "settings")
        let hostingController = UIHostingController(rootView: lottieView)
        let view = hostingController.view
        view?.backgroundColor = .clear
        return view!
    }()
    
    private var ActivityView: UIView = {
        let lottieView = LottieView(animationName: "Run")
        let hostingController = UIHostingController(rootView: lottieView)
        let view = hostingController.view
        view?.backgroundColor = .clear
        return view!
    }()
    
    private lazy var profileButton = {
        var configuration = UIButton.Configuration.plain()
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.present(UIHostingController(rootView: ProfileView()), animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .medium
        configuration.contentInsets = .zero
        configuration.baseForegroundColor = .black
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(UIHostingController(rootView: MainSportsView()), animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var usernameStack = {
        let stackView = UIStackView(arrangedSubviews: [helloLabel, usernameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let calendarDummy = UIView()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello,"
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = model.name
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
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let dummyProgressView = UIView()
    
    private lazy var progressView: CircularProgressView = {
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
        label.text = "\(self.model.calcNutrition(type: .Calories))"
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: true)
        //model.setupDateButton(button: calendarButton)
        setupUI()
        
        self.model.dataUpdated = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.configure()
            }
        }
        
        self.mainDB.dataUpdated = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.configure()
            }
        }
        
        self.settingsModel.settingsUpdated = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.updateColors()
                self?.updateSettingsLabels()
                self?.updateCalLimit()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.settingsModel.updateUserDefaults()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        self.calories.text = String((self.model.calcNutrition(type: .Calories)))
        self.progressView.progress = (self.model.calcProgress(type: .Calories))
        self.proteinProgress.setProgress(self.model.calcProgress(type: .Protein), animated: true)
        self.carbsProgress.setProgress(self.model.calcProgress(type: .Carbs), animated: true)
        self.fatsProgress.setProgress(self.model.calcProgress(type: .Fats), animated: true)
        updateSettingsLabels()
        self.mainCollectionView.reloadData()
    }
    
    private func updateColors() {
        self.view.backgroundColor = UIColor(settingsModel.backgroundColor)
        self.progressView.progressColor = UIColor(settingsModel.mainProgressColor)
        self.progressView.trackColor = UIColor(settingsModel.mainProgressTrackColor)
        self.proteinProgress.progressTintColor = UIColor(settingsModel.mainProgressColor)
        self.carbsProgress.progressTintColor = UIColor(settingsModel.mainProgressColor)
        self.fatsProgress.progressTintColor = UIColor(settingsModel.mainProgressColor)
    }
    
    private func updateSettingsLabels() {
        self.usernameLabel.text = settingsModel.nickname
        self.caloriesLimit.text = "of \(settingsModel.calories) kCal"
    }
    
    private func updateCalLimit() {
        self.model.fetchCaloriesLimit()
    }
    
    private func setupUI() {
        view.addSubview(mainStackView)
        ActivityView.addSubview(activityButton)
        settingsView.addSubview(profileButton)
        dummyProgressView.addSubview(progressView)
        setupConstraints()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(MainViewButtonCell.self, forCellWithReuseIdentifier: "cell")
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
            dummyDummy.widthAnchor.constraint(equalToConstant: 30),
            ProgressStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            activityButton.centerXAnchor.constraint(equalTo: ActivityView.centerXAnchor),
            activityButton.centerYAnchor.constraint(equalTo: ActivityView.centerYAnchor),
            activityButton.widthAnchor.constraint(equalToConstant: 44),
            activityButton.heightAnchor.constraint(equalToConstant: 56),
            
            profileButton.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
            profileButton.centerYAnchor.constraint(equalTo: settingsView.centerYAnchor),
            profileButton.widthAnchor.constraint(equalTo: settingsView.widthAnchor),
            profileButton.heightAnchor.constraint(equalTo: settingsView.heightAnchor),
            
            settingsView.widthAnchor.constraint(equalTo: ProfileStackView.widthAnchor, multiplier: 0.2),
            ActivityView.widthAnchor.constraint(equalTo: ProfileStackView.widthAnchor, multiplier: 0.1),
            
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

// MARK: - Extensions

extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FoodModel.food.count
    }
}

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainViewButtonCell else { return UICollectionViewCell() }
        let model = FoodModel.food[indexPath.row]
        let result = self.model.calcTypeCalories(type: model.name)
        cell.configure(model: model, result: result)
        return cell
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = spacing
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let width = (mainCollectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        let height = (mainCollectionView.bounds.height - totalSpacing) / numberOfItemsPerRow / 1.10
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductListView(mainDB: mainDB)
        let model = FoodModel.food[indexPath.row]
        vc.type = model.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
