//
//  AddProduct.swift
//  FitnessApp
//
//  Created by David on 2/1/24.
//

import UIKit

class ProductListView: UIViewController {
    
    var model: MainPageViewModel
    var type: FoodType?
    
    init(model: MainPageViewModel) {
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        setupMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonStackView, tableViewStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
            
            let vc = AddProductView()
            vc.delegate = self
            self?.navigationController?.present(vc, animated: true)
            
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
            
            let vc = ScanViewPage()
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
            
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
        view.backgroundColor = .white
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

extension ProductListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case.breakfast:
            return model.breakfastData.count
        case.dinner:
            return model.dinnerData.count
        case.lunch:
            return model.lunchData.count
        case.snack:
            return model.snackData.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        switch type {
        case.breakfast:
            cell.model = model.breakfastData[indexPath.row]
        case.dinner:
            cell.model = model.dinnerData[indexPath.row]
        case.lunch:
            cell.model = model.lunchData[indexPath.row]
        case.snack:
            cell.model = model.snackData[indexPath.row]
        case .none:
            print("ERROR")
        }
        cell.updateUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch type {
            case.breakfast:
                model.breakfastData.remove(at: indexPath.row)
            case.dinner:
                model.dinnerData.remove(at: indexPath.row)
            case.lunch:
                model.lunchData.remove(at: indexPath.row)
            case.snack:
                model.snackData.remove(at: indexPath.row)
            case .none:
                print("ERROR")
            }
            mainTableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    
}

extension ProductListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case.breakfast:
            let vc = ProductDetailsView(model: model.breakfastData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case.dinner:
            let vc = ProductDetailsView(model: model.dinnerData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case.lunch:
            let vc = ProductDetailsView(model: model.lunchData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case.snack:
            let vc = ProductDetailsView(model: model.snackData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case .none:
            print("ERROR")
        }
    }
    
}

extension ProductListView: addViewDelegate {
    func fetchData(food: String, weight: String) {
        self.model.foodFetch(type: self.type ?? .breakfast, food: food, weight: weight)
        self.model.reload = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.mainTableView.reloadData()
            }
        }
    }
}

protocol addViewDelegate: AnyObject {
    func fetchData(food: String, weight: String)
}
