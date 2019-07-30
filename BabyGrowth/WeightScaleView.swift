//
//  weightScaleViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 6/27/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import AVFoundation


class weightScaleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePicButton: UIButton!
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var images: UIImage?
    var user = User()
//    var userIdentificationArray: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        setUIToView()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        self.view.bringSubviewToFront(takePicButton)
        self.view.bringSubviewToFront(stepLabel)

    }
        

    /* Function: before starting taking a photo, set up the AVCaptureSession to take a photo during this view */
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    /* Function: before starting taking a photo, set up the device and check if the user want to have front camera or back camera */
    func setupDevice() {
        
        /* set up to find out the current device's camera and make it type as vide
         * Also, set the position unknown to set up later to find which camera user wants to use */
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        /* create the deviceDiscoverySession to get all the front and back camera */
        let devices = deviceDiscoverySession.devices
        
        
        /* check the camera's postion and set up the camera */
        for device in devices{
            if device.position == AVCaptureDevice.Position.back {
                print("back")
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
                print("front")
            }
        }
        
        /* For now, just using a back side of camera */
        currentCamera = backCamera
    }
    
    /* Function: before starting taking a photo, set up the Input (current using camera) and Output (how to make a image) */
    func setupInputOutput() {
        
        do{
            /* set the input as current camera, so the current camera would be in the current capture session
             * session is like a thread */
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            /* set the output as a jpeg format and the output would be in the current caputure session */
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch{
            print(error)
        }
        
    }
    
    /* Function: before starting taking a photo, set up the layer to get the camera view */
    func setupPreviewLayer() {
        
        /* create the AVcaptureVideoPreviewLayer which is the current camera view
         * it's gravity would be aspect fill with proper ratio and the orientation would be portrait
         * and add the camera view to its current view in the TakePictureViewController */
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        cameraView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    /* Function: if all the sessions, device, input, and output is ready, then begin the session that contains
     * all the information about the camera settings */
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    /* Function: before going to next view controller (WeightRecordViewController), pass the image to the
     * WeightRecordlViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "WeightScale_To_Results_Segue" {
            let previewVC = segue.destination as! WeightResultsRecordViewController
            previewVC.image = self.images
            previewVC.user = user
            
            
        }
        
    }
    
    /* From text field's delegate, whenever user click "return", then the keyboard will be dismiss from the view */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weightTextField.resignFirstResponder()
        return true
    }
    


    /* Function: when the user clicks the weight text field, then its information string would be gone */
    @IBAction func weightTextField_TouchDown(_ sender: Any) {
        
        weightTextField.text = ""

    }
    
    /* Function: when the user clicks the finish button, then user would go to the End View */
    @IBAction func finishButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: self)

    }
}

/* Delegate: using the AVCapturePhotoCaptureDelegate to prepare the image for the imageview in the WeightRecordlViewController */
extension weightScaleViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            images = UIImage(data: imageData)
            performSegue(withIdentifier: "WeightScale_To_Results_Segue", sender: nil)
        }
    }
}

