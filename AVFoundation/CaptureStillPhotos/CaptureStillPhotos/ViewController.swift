//
//  ViewController.swift
//  CaptureStillPhotos
//
//  Created by Ikmal Azman on 24/12/2021.
// https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var flipCameraBtn: UIBarButtonItem!
    @IBOutlet weak var capturedImageView: UIImageView! {
        didSet {
            capturedImageView.layer.cornerRadius = 15
        }
    }
    
    //MARK: - Variables
    private var captureSession : AVCaptureSession!
    
    private var backCameraDevice : AVCaptureDevice!
    private var frontCaptureDevice : AVCaptureDevice!
    private var backCameraInput : AVCaptureInput!
    private var frontCameraInput : AVCaptureInput!
    
    private var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    private var videoCameraDataOutput : AVCaptureVideoDataOutput!
    
    var isTakePicture = false
    var isBackCameraOn = true
    
      //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        checkPermission()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    //MARK: - Actions
    @IBAction func takePictureTap(_ sender: UIButton) {
        isTakePicture = true
    }
    @IBAction func flipCameraTap(_ sender: UIBarButtonItem) {
        flipCameraInput()
    }
    
    private func setupCamera() {
        // Execute config in bg thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Init capture session
            self?.captureSession = AVCaptureSession()
            // Start configure capture session
            self?.captureSession.beginConfiguration()
            // Set quality level of the output
            self?.captureSession.sessionPreset = .photo
            // Enable wide color of photo for output
            self?.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            // Setup camera device inputs(AVCaptureInput)
            self?.setupCameraInputs()
            
            // Set the preview is in UI, so it need to run on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.setupVideoPreviewLayer()
            }
            // Setup camera device output (Data that retrieved from capture device via its mediator, CaptureSession)
            self?.setupCameraOutputs()
            // Commit configuration that had been made
            self?.captureSession.commitConfiguration()
            // Start running the capture session
            self?.captureSession.startRunning()
        }
        
        
    }
    
    private func setupCameraInputs() {
        // Get back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {fatalError()}
        backCameraDevice = backCamera
        // Get front camera
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {fatalError()}
        frontCaptureDevice = frontCamera
        
        // Create input object from specified device
        guard let backInput = try? AVCaptureDeviceInput(device: backCameraDevice), let frontInput = try? AVCaptureDeviceInput(device: frontCaptureDevice) else {
            fatalError("There's some error when create input for back/front camera")
        }
        
        backCameraInput = backInput
        frontCameraInput = frontInput
        
        // Add input to cpature session
        if captureSession.canAddInput(frontCameraInput) == false {
            fatalError()
        }
        
        captureSession.addInput(backCameraInput)
        
        print("Input Connected")
    }
    
    private func setupVideoPreviewLayer() {
        // Layer diplay video captured from input
        videoPreviewLayer = AVCaptureVideoPreviewLayer()
        // Connect video layer to capture session
        videoPreviewLayer.session = captureSession
        // Add preview layer to current view layer and place it behind image view
        view.layer.insertSublayer(videoPreviewLayer, below: capturedImageView.layer)
        videoPreviewLayer.frame = self.view.layer.frame
    }
    
    private func setupCameraOutputs() {
        // Init output, allow to get data recorded from video and access the frame rates for processing
        videoCameraDataOutput = AVCaptureVideoDataOutput()
        // Create new dispatch queue, object manage execution task, allow to be call at the frame-rate of the camera, expect to process data background thread
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInitiated)
        // Set sampleBufferDelegate and initialise the queue for system to call the function back
        videoCameraDataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        // Determine if output can be added to capture session
        if captureSession.canAddOutput(videoCameraDataOutput) {
            captureSession.addOutput(videoCameraDataOutput)
        } else {
            fatalError("Could not add video output")
        }
        // Make the preview image orientation in portrait, correct video orientation when take a picture
        videoCameraDataOutput.connections.first?.videoOrientation = .portrait
    }
    
    private func flipCameraInput() {
        // Prevent user spam the button, which can drop the app performace bcs of the capture session configuration
        flipCameraBtn.isEnabled = false
        
        // Begin configuration
        captureSession.beginConfiguration()
        
        // Determine if backCamera is active, the session will replace it input to front camera and vice versa
        if isBackCameraOn {
            captureSession.removeInput(backCameraInput)
            captureSession.addInput(frontCameraInput)
            isBackCameraOn = false
        } else {
            captureSession.removeInput(frontCameraInput)
            captureSession.addInput(backCameraInput)
            isBackCameraOn = true
        }
        
        // Make the orientation of data output is in portrait mode
        videoCameraDataOutput.connections.first?.videoOrientation = .portrait
        // Mirror the preview layer for front camera
        videoCameraDataOutput.connections.first?.isVideoMirrored = !isBackCameraOn
        
        // Commit the configuration that we set
        captureSession.commitConfiguration()
        
        // Enable back the flip camera button when config is done
        flipCameraBtn.isEnabled = true
    }
    
    private func checkPermission() {
        // Return value that the app has permission to access specific mediaType
        let checkCameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch checkCameraAuthStatus {
        case .notDetermined:
            // Request user permission if access not yet determine
            AVCaptureDevice.requestAccess(for: .video) { allowAccess in
                if !allowAccess {
                    abort()
                }
            }
        case .restricted:
            abort()
        case .denied:
            abort()
        case .authorized:
            return
        @unknown default:
            fatalError("There some error when request camera permission from user")
        }
    }
    
    
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
// Method to receive samppleBuffer, monitor status, video data output
extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    // Notify delegate that new video frame was written
    // Output - specify which output device is came from, if has multiple AVCapture output at same delegate
    // SampleBuffer - houses for video frame data, object contain sample of media type, move media sample data through media pipeline
    // Connection - specify which connection object that the data came(Probably will help if have multiple output)
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Determine that if user is take a picture
        if isTakePicture == false {
            return
        }
        // Try and get CVImageBuffer from sample buffer,image buffer is a type representing Core Video buffers that hold images
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        // Get CIImage from CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        // Convert CIImage to UIImage
        let uiImage = UIImage(ciImage: ciImage)
        
        
        DispatchQueue.main.async { [weak self] in
            // Set image to capturedImage with converted UIImage
            self?.capturedImageView.image = uiImage
            // Set the take picture to false, enable user to take picture
            self?.isTakePicture = false
        }
    }
}
