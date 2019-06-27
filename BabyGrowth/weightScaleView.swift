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
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var images: UIImage?

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUIToView()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    /* Function: set all the UIs to the View */
    func setUIToView(){
        
        /* set the weightTextField to have information string with the light gray color using a numberPad */
        weightTextField.text = "Input Baby's Weight (Kg)"
        weightTextField.textAlignment = NSTextAlignment.center
        weightTextField.textColor = UIColor.lightGray
        weightTextField.font =  UIFont(name: (weightTextField.font?.fontName)!, size: CGFloat(10.0))

        /* set the tool bar Items (Cancel - Space - Done) */
        let toolbar_LastDigit = UIToolbar();
        toolbar_LastDigit.sizeToFit()
        let doneButton_LastDigit = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_cancel_numberPad));
        let spaceButton_LastDigit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton_LastDigit = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(done_cancel_numberPad));
        toolbar_LastDigit.setItems([cancelButton_LastDigit,spaceButton_LastDigit,doneButton_LastDigit], animated: false)
        
        /* connect the date picker to the weightTextField */
        weightTextField.keyboardType = UIKeyboardType.numberPad
        weightTextField.inputAccessoryView = toolbar_LastDigit
        
    }
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func done_cancel_numberPad(){
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
        self.view.endEditing(true)
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
        
//        if segue.identifier == "takePhoto" {
//            let previewVC = segue.destination as! ResultsRecordlViewController
//            previewVC.image = self.images
//        }
        
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
        performSegue(withIdentifier: "WeightScale_To_End_Segue", sender: nil)
    }
}

/* Delegate: using the AVCapturePhotoCaptureDelegate to prepare the image for the imageview in the WeightRecordlViewController */
extension weightScaleViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            images = UIImage(data: imageData)
//            performSegue(withIdentifier: "takePhoto", sender: nil)
        }
    }
}

