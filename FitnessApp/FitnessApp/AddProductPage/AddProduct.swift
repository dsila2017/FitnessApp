//
//  AddProduct.swift
//  FitnessApp
//
//  Created by David on 2/1/24.
//

import UIKit

class AddProduct: UIViewController {
    
    private var data: [Model] = []
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonStackView, tableViewStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var buttonStackView = {
        let stackView = UIStackView(arrangedSubviews: [dummyViews])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private lazy var addButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus")!
            .applyingSymbolConfiguration(.init(pointSize: 20))
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            print("add Button Pressed")
        }), for: .touchUpInside)
        button.configuration?.subtitle = "add"
        return button
    }()
    
    private lazy var scanButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "viewfinder")!
            .applyingSymbolConfiguration(.init(pointSize: 20))
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            print("add Button Pressed")
        }), for: .touchUpInside)
        button.configuration?.subtitle = "scan"
        return button
    }()
    
    private var dummyViews = UIView()
    
    private lazy var tableViewStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainTableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        return stackView
    }()
    
    private var mainTableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMainView()
    }
    
    func setupMainView() {
        view.addSubview(mainStackView)
        dummyViews.addSubview(addButton)
        dummyViews.addSubview(scanButton)
        
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            buttonStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.05),
            scanButton.trailingAnchor.constraint(equalTo: dummyViews.trailingAnchor, constant: -20),
            scanButton.centerYAnchor.constraint(equalTo: dummyViews.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: scanButton.leadingAnchor, constant: -10),
            addButton.centerYAnchor.constraint(equalTo: dummyViews.centerYAnchor),
        ])
    }
    
}

extension AddProduct: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell 
        //{
            //cell.textLabel?.text = "Product"
            //cell.label.text = "Product"
            return cell
        }
        //return UITableViewCell()
    //}
    
    
}

extension AddProduct: UITableViewDelegate {
    
}
