//
//  TakePictureViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class TakePictureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /*IBOutlet Field*/
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var camView: UIImageView!
    

    /* Device */
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
//    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var images: UIImage?
    
    /* Aruco Set up */
    private var captureSession: AVCaptureSession?
    private var trackerSetup = false
    private var arucoTracker: ArucoTracker?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTrackerIfNeeded()
        captureSession?.startRunning()

        self.view.bringSubviewToFront(takePictureButton)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
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
    
    /* Function: before starting taking a photo, set up the AVCaptureSession to take a photo during this view */
    func setupCaptureSession() {
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    
    
    
    
    /* Function: before going to next view controller (WeightRecordViewController), pass the image to the
     * WeightRecordlViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "takePicture_Results_Segue" {
            let previewVC = segue.destination as! ResultsRecordlViewController
            previewVC.image = self.images
        }
        
    }

    /* Function: call the WeightRecordView with the AVCapturePhotoSettings by calling AVCapturePhotoCaptureDelegate */
    @IBAction func takePicture_TouchUpInside(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: self)

    }
    
    func setupTrackerIfNeeded(){
        if trackerSetup {return}
        
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        let calibPath = "\(docsDir)/camera_parameters.yml"
        
        if !FileManager.default.fileExists(atPath: calibPath) {
//            warnUser()

        } else {
            
            arucoTracker = ArucoTracker(calibrationFile: calibPath, delegate: self)
            
            setupSession()
            trackerSetup = true
        }
    }
    
    func setupSession() {
        
        guard let tracker = arucoTracker
            else { fatalError("prepareSession() must be called after initializing the tracker") }
        
        currentCamera = AVCaptureDevice.default(for: .video)
        guard currentCamera != nil, let videoInput = try? AVCaptureDeviceInput(device: currentCamera!)
            else { fatalError("Device unavailable") }
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .iFrame960x540
        
        guard captureSession!.canAddInput(videoInput), captureSession!.canAddOutput(videoOutput)
            else { fatalError("Cannot add video I/O to capture session") }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession?.addOutput(photoOutput!)

        captureSession?.addInput(videoInput)
        captureSession?.addOutput(videoOutput)
        
        tracker.previewRotation = .cw90
        tracker.prepare(for: videoOutput, orientation: .landscapeRight)
    }

}

/* Delegate: using the AVCapturePhotoCaptureDelegate to prepare the image for the imageview in the WeightRecordlViewController */
extension TakePictureViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            images = UIImage(data: imageData)
            performSegue(withIdentifier: "takePicture_Results_Segue", sender: nil)
        }
    }
}

extension TakePictureViewController: ArucoTrackerDelegate {
    
    func arucoTracker(_ tracker: ArucoTracker, didDetect markers: [ArucoMarker], preview: UIImage?) {
        DispatchQueue.main.async { [unowned self] in
            
            self.camView.image = preview
        }
    }
}

