//
//  Scanner.swift
//  FitnessApp
//
//  Created by David on 2/7/24.
//

import UIKit
import AVFoundation
import Vision

class ScannerView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Properties
    
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    
    private var previewView: UIView!
    
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    var delegate: addViewDelegate?
    var productName: String = "Product" {
        didSet {
            button.setNeedsUpdateConfiguration()
        }
    }
    
    private lazy var addButtonDummyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return view
    }()
    
    lazy var button: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "add Product"
        configuration.cornerStyle = .capsule
        configuration.contentInsets = .zero
        configuration.baseBackgroundColor = .black
        configuration.baseForegroundColor = .white
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self]_ in
            let vc = AddProductView()
            vc.foodTextField.text = self?.productName
            vc.delegate = self?.delegate
            self?.navigationController?.present(vc, animated: true)
            self?.navigationController?.popViewController(animated: true)
            
        }), for: .touchUpInside)
        button.configurationUpdateHandler = { [unowned self] button in
            var configuration = button.configuration
            configuration?.title = self.productName
            button.configuration = configuration
        }
        return button
    }()
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView = view
        setupAVCapture()
        view.addSubview(addButtonDummyView)
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            addButtonDummyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButtonDummyView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            addButtonDummyView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            addButtonDummyView.heightAnchor.constraint(equalToConstant: 70),
            
            button.centerXAnchor.constraint(equalTo: addButtonDummyView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: addButtonDummyView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: addButtonDummyView.widthAnchor, multiplier: 0.9),
            button.heightAnchor.constraint(equalTo: addButtonDummyView.heightAnchor, multiplier: 0.7)
            
        ])
    }
    
    func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = previewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    func startCaptureSession() {
        session.startRunning()
    }
    
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:
            exifOrientation = .down
        case UIDeviceOrientation.portrait:
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}
