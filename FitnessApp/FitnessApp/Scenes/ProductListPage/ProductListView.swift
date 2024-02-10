//
//  AddProduct.swift
//  FitnessApp
//
//  Created by David on 2/1/24.
//

import UIKit

class ProductListView: UIViewController {
    var mainDB: MainDB
    var type: FoodType?
    private var settingsModel = ProfileViewModel.shared
    
    init(mainDB: MainDB) {
        
        self.mainDB = mainDB
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
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var buttonStackView = {
        let stackView = UIStackView(arrangedSubviews: [dummyViews])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var menuButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.viewfinder")!
            .applyingSymbolConfiguration(.init(pointSize: 20))
        configuration.contentInsets = .zero
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.menu = UIMenu(children: [
            UIAction(title: "add manually", image: UIImage(systemName: "plus"), handler: { [weak self] _ in
                let vc = AddProductView()
                vc.delegate = self
                self?.navigationController?.present(vc, animated: true)
            }),
            UIAction(title: "Photo detection", image: UIImage(systemName: "camera.viewfinder"), handler: { [weak self] _ in
                let vc = ScanPhotoView()
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
            }),
            UIAction(title: "Live detection", image: UIImage(systemName: "dot.circle.viewfinder"), handler: { [weak self] _ in
                let vc = ScanViewPage()
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        ])
        button.showsMenuAsPrimaryAction = true
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.subtitle = "add"
        return button
    }()
    
    private var dummyViews = UIView()
    
    private lazy var tableViewStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainTableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private var mainTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMainView()
    }
    
    func setupMainView() {
        view.addSubview(mainStackView)
        view.backgroundColor = UIColor(settingsModel.backgroundColor)
        dummyViews.addSubview(menuButton)
        
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
            menuButton.trailingAnchor.constraint(equalTo: dummyViews.trailingAnchor, constant: -40),
            menuButton.centerYAnchor.constraint(equalTo: dummyViews.centerYAnchor),
        ])
    }
    
}

extension ProductListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case.breakfast:
            return mainDB.breakfastData.count
        case.dinner:
            return mainDB.dinnerData.count
        case.lunch:
            return mainDB.lunchData.count
        case.snack:
            return mainDB.snackData.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        switch type {
        case.breakfast:
            cell.model = mainDB.breakfastData[indexPath.row]
        case.dinner:
            cell.model = mainDB.dinnerData[indexPath.row]
        case.lunch:
            cell.model = mainDB.lunchData[indexPath.row]
        case.snack:
            cell.model = mainDB.snackData[indexPath.row]
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
                mainDB.breakfastData.remove(at: indexPath.row)
            case.dinner:
                mainDB.dinnerData.remove(at: indexPath.row)
            case.lunch:
                mainDB.lunchData.remove(at: indexPath.row)
            case.snack:
                mainDB.snackData.remove(at: indexPath.row)
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
        tableView.reloadRows(at: [indexPath], with: .fade)
        switch type {
        case.breakfast:
            let vc = ProductDetailsView(model: mainDB.breakfastData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case.dinner:
            let vc = ProductDetailsView(model: mainDB.dinnerData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case.lunch:
            let vc = ProductDetailsView(model: mainDB.lunchData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case.snack:
            let vc = ProductDetailsView(model: mainDB.snackData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case .none:
            print("ERROR")
        }
    }
        
}

extension ProductListView: addViewDelegate {
    func fetchData(food: String, weight: String) {
        self.mainDB.foodFetch(type: self.type ?? .breakfast, food: food, weight: weight)
        self.mainDB.reload = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.mainTableView.reloadData()
            }
        }
    }
}

protocol addViewDelegate: AnyObject {
    func fetchData(food: String, weight: String)
}
