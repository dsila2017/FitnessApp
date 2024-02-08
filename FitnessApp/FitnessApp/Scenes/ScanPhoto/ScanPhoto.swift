//
//  ScanPhoto.swift
//  FitnessApp
//
//  Created by David on 2/8/24.
//

import UIKit
import CoreML
import Vision

class ScanPhotoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: addViewDelegate?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageDummy, labelDummy, chooseButtonDummy, labelButtonDummy])
        stackView.setCustomSpacing(40, after: labelDummy)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private var imagePicker = UIImagePickerController()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 10)
        imageView.image = UIImage(systemName: "photo.stack.fill", withConfiguration: configuration)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imageDummy: UIView = {
       let view = UIView()
        view.addSubview(imageView)
        return view
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private var nameLabelText: String = "Product" {
        didSet {
            nameLabel.text = "Product:" + " " + nameLabelText
            labelButton.setNeedsUpdateConfiguration()
        }
    }
    
    private lazy var labelDummy: UIView = {
       let view = UIView()
        view.addSubview(nameLabel)
        view.addSubview(confidenceLabel)
        return view
    }()
    
    private var confidenceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private var confidenceLabelText: String = "Product" {
        didSet {
            confidenceLabel.text = "Accuracy:" + " " + confidenceLabelText
        }
    }
    
    private lazy var chooseButton = createButton(label: "Choose Photo", action: UIAction(handler: { [weak self] _ in
        self?.present((self?.imagePicker)!, animated: true)
        
    }))
    
    private lazy var chooseButtonDummy: UIView = {
       let view = UIView()
        view.addSubview(chooseButton)
        return view
    }()
    
    private lazy var labelButton: UIButton = {
       var button = createButton(label: "Choose Photo", action: UIAction(handler: { [weak self] _ in
           let vc = AddProductView()
           vc.foodTextField.text = self?.nameLabelText
           vc.delegate = self?.delegate
           self?.navigationController?.present(vc, animated: true)
           self?.navigationController?.popViewController(animated: true)
       }))
        button.configurationUpdateHandler = { [unowned self] button in
            var configuration = button.configuration
            configuration?.title = self.nameLabelText
            button.configuration = configuration
        }
        return button
    }()
    
    private lazy var labelButtonDummy: UIView = {
       let view = UIView()
        view.addSubview(labelButton)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(mainStackView)
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            imageDummy.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.64),
            
            imageView.centerXAnchor.constraint(equalTo: imageDummy.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageDummy.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageDummy.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageDummy.heightAnchor, multiplier: 0.7),
            
            
            //chooseButton.centerYAnchor.constraint(equalTo: imageDummy.centerYAnchor),
            //chooseButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.4),
            
            chooseButtonDummy.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.1),
            chooseButton.widthAnchor.constraint(equalTo: chooseButtonDummy.widthAnchor, multiplier: 0.4),
            chooseButton.heightAnchor.constraint(equalToConstant: 46),
            chooseButton.centerXAnchor.constraint(equalTo: chooseButtonDummy.centerXAnchor),
            chooseButton.centerYAnchor.constraint(equalTo: chooseButtonDummy.centerYAnchor),
            
            labelButtonDummy.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.1),
            labelButton.widthAnchor.constraint(equalTo: labelButtonDummy.widthAnchor, multiplier: 0.4),
            labelButton.heightAnchor.constraint(equalToConstant: 46),
            labelButton.centerXAnchor.constraint(equalTo: labelButtonDummy.centerXAnchor),
            labelButton.centerYAnchor.constraint(equalTo: labelButtonDummy.centerYAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: labelDummy.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: labelDummy.centerYAnchor, constant: -20),
            
            confidenceLabel.centerXAnchor.constraint(equalTo: labelDummy.centerXAnchor),
            confidenceLabel.centerYAnchor.constraint(equalTo: labelDummy.centerYAnchor, constant: 20),
            
            
        ])
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imagePicker.dismiss(animated: true)
        identifyModel(image: image!)
    }
    
    private func identifyModel(image: UIImage) {
        guard let model = try? VNCoreMLModel(for: Resnet50FP16().model) else {
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let firstResult = results.first else {
                return
            }
            
            DispatchQueue.main.async {
                self?.nameLabelText = String(firstResult.identifier)
                self?.confidenceLabelText = String(Int(firstResult.confidence * 100)) + "%"
            }
        }
            
            guard let ciImage = CIImage(image: image) else {
                return
            }
            
            let imageHandler = VNImageRequestHandler(ciImage: ciImage)
            
            DispatchQueue.global().async {
                do{
                    try imageHandler.perform([request])
                } catch {
                    return
                }
            }
        
    }
    
    private func createButton(label: String, action: UIAction) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .zero
        config.title = "Choose Photo"
        config.baseBackgroundColor = .black
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }

}
