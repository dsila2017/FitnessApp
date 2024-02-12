//
//  AddProduct.swift
//  FitnessApp
//
//  Created by David on 2/1/24.
//

import Foundation
import UIKit
import SwiftUI

final class ProductListView: UIViewController {
    
    // MARK: - Properties
    
    var mainDB: MainDB
    var type: FoodType?
    
    // MARK: - Private Properties
    
    private var settingsModel = ProfileViewModel.shared
    private var array: [Model] {
        get {
            switch self.type {
            case .breakfast:
                return mainDB.breakfastData
            case .dinner:
                return mainDB.dinnerData
            case .lunch:
                return mainDB.lunchData
            case .snack:
                return mainDB.snackData
            case .none:
                return [Model]()
            }
        }
        set {
            switch self.type {
            case .breakfast:
                mainDB.breakfastData = newValue
            case .dinner:
                mainDB.dinnerData = newValue
            case .lunch:
                mainDB.lunchData = newValue
            case .snack:
                mainDB.snackData = newValue
            case .none:
                break
            }
        }
    }
    
    // MARK: - Int
    
    init(mainDB: MainDB) {
        self.mainDB = mainDB
        super.init(nibName: nil, bundle: nil)
        setupMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
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
        let view = UIView()
        tableView.backgroundView = view
        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkEmptyTableView()
    }
    
    // MARK: - Private Methods
    
    private func setupMainView() {
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
    
    private func checkEmptyTableView() {
        let emptyView = UIHostingController(rootView: EmptyView())
        emptyView.view.backgroundColor = .clear
        if array.isEmpty {
            UIView.transition(with: mainTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.mainTableView.backgroundView = emptyView.view
            }, completion: nil)
        } else {
            UIView.transition(with: mainTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.mainTableView.backgroundView = nil
            }, completion: nil)
        }
    }
    
    private func setupConstraints() {
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

// MARK: - Extensions

extension ProductListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.model = array[indexPath.row]
        cell.updateUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            array.remove(at: indexPath.row)
            checkEmptyTableView()
            mainTableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension ProductListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        let vc = ProductDetailsView(model: array[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductListView: addViewDelegate {
    func fetchData(food: String, weight: String) {
        self.mainDB.foodFetch(type: self.type ?? .breakfast, food: food, weight: weight)
        self.mainDB.reload = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.checkEmptyTableView()
                self?.mainTableView.reloadData()
            }
        }
    }
}

// MARK: - Delegate

protocol addViewDelegate: AnyObject {
    func fetchData(food: String, weight: String)
}
