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
        let stackView = UIStackView(arrangedSubviews: [ProfileStackView, otherStackView1, mealsLabel, mainCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private lazy var ProfileStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileDummy, usernameStack, signOutDummy])
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
            let vc = MainView()
            self?.navigationController?.pushViewController(vc, animated: true)
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
    
    let signOutDummy = UIView()
    
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
    
    private lazy var otherStackView1 = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .brown
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        model.setupDateButton(button: calendarButton)
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(mainStackView)
        signOutDummy.addSubview(calendarButton)
        profileDummy.addSubview(profileButton)
        
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
            
            mainCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.34),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            mealsLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 24),
            
            ProfileStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.08),
            ProfileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            otherStackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            calendarButton.centerXAnchor.constraint(equalTo: signOutDummy.centerXAnchor),
            calendarButton.centerYAnchor.constraint(equalTo: signOutDummy.centerYAnchor),
            calendarButton.widthAnchor.constraint(equalToConstant: 44),
            calendarButton.heightAnchor.constraint(equalToConstant: 56),
            
            profileButton.centerXAnchor.constraint(equalTo: profileDummy.centerXAnchor),
            profileButton.centerYAnchor.constraint(equalTo: profileDummy.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 50),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            
            profileDummy.widthAnchor.constraint(equalTo: ProfileStackView.widthAnchor, multiplier: 0.2),
            signOutDummy.widthAnchor.constraint(equalTo: ProfileStackView.widthAnchor, multiplier: 0.2),
            
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
        cell?.mainLabel.text = FoodModel.food[indexPath.row].name
        cell?.imageView.image = UIImage(named: FoodModel.food[indexPath.row].image)
        cell?.stackView.backgroundColor = FoodModel.food[indexPath.row].color
        
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
        let height = (mainCollectionView.bounds.height - totalSpacing) / numberOfItemsPerRow / 1.2
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //            let vc = MainView()
        //            vc.configure(with: FoodModel.food[indexPath.row])
        //            navigationController?.pushViewController(vc, animated: true)
        print(FoodModel.food[indexPath.row].name)
    }
}
