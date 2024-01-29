//
//  MainView.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import UIKit

class MainView: UIViewController {
    
    private let spacing: CGFloat = 14.0
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [otherStackView, mainCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private lazy var otherStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemTeal
        return stackView
    }()
    
    lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        setupConstraints()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    private func setupConstraints() {
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
            
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
        let height = (mainCollectionView.bounds.height - totalSpacing) / numberOfItemsPerRow / 1.4
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //            let vc = MainView()
        //            vc.configure(with: FoodModel.food[indexPath.row])
        //            navigationController?.pushViewController(vc, animated: true)
        print(FoodModel.food[indexPath.row].name)
    }
}
