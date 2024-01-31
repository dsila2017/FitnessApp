//
//  ButtonCell.swift
//  FitnessApp
//
//  Created by David on 1/28/24.
//

import UIKit

final class ButtonCell: UICollectionViewCell {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelDummyView, calorieStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 20
        stackView.backgroundColor = .red
        return stackView
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var calorieStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [dummyView, calorieLabel, calorieUnit])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    var calorieLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "240"
        label.textAlignment = .center
        return label
    }()
    
    var calorieUnit: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "kcal"
        return label
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 25
        return image
    }()
    
    var dummyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var labelDummyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    private func setupCell() {
        addSubview(stackView)
        labelDummyView.addSubview(mainLabel)
        dummyView.addSubview(imageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            
            mainLabel.leadingAnchor.constraint(equalTo: labelDummyView.leadingAnchor, constant: 16),
            mainLabel.bottomAnchor.constraint(equalTo: labelDummyView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            calorieLabel.widthAnchor.constraint(equalTo: calorieStackView.widthAnchor, multiplier: 0.3),
            calorieUnit.widthAnchor.constraint(equalTo: calorieStackView.widthAnchor, multiplier: 0.3),
            
            calorieStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7),
            
            imageView.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor),
        ])
    }
    
}
