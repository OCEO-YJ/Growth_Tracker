//
//  TakePictureViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import AVFoundation

class TakePictureViewController: UIViewController {
    
    /*IBOutlet Field*/
    @IBOutlet weak var takePictureButton: UIButton!
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var images: UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        setUIToView()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
    }
    
    /* Function: set all the UIs to the View */
    func setUIToView() {
        /* set background color: pink */
//        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */        
        takePictureButton.layer.cornerRadius = 10
        takePictureButton.backgroundColor = backgroundColor
        takePictureButton.setTitleColor(UIColor.white, for: .normal)
    }

    /* Function: call the WeightRecordView with the AVCapturePhotoSettings by calling AVCapturePhotoCaptureDelegate */
    @IBAction func takePicture_Clicked(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: self)

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
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    /* Function: if all the sessions, device, input, and output is ready, then begin the session that contains
     * all the information about the camera settings */
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    /* Function: before going to next view controller (WeightRecordViewController), pass the image to the
     * WeightRecordlViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "takePhoto" {
            let previewVC = segue.destination as! WeightRecordlViewController
            previewVC.image = self.images
        }
        
    }

}

/* Delegate: using the AVCapturePhotoCaptureDelegate to prepare the image for the imageview in the WeightRecordlViewController */
extension TakePictureViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            images = UIImage(data: imageData)
            performSegue(withIdentifier: "takePhoto", sender: nil)
        }
    }
}
