//
//  TakePictureViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AudioToolbox

class TakePictureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    

    /*IBOutlet Field*/
//    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var camView: UIImageView!
    
    @IBOutlet weak var stepLabel: UILabel!
    
    /* Device */
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    
    var images = [UIImage]()
    var imageCount = 0
    
    var user = User()
    
    /* Aruco Set up */
    private var captureSession: AVCaptureSession?
    private var trackerSetup = false
    private var arucoTracker: ArucoTracker?
    static var countDownForTakingPicture = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageCount = 0
        images.removeAll(keepingCapacity: false)
        
        setupTrackerIfNeeded()
        captureSession?.startRunning()
        
         setUIToView()

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
//        takePictureButton.layer.cornerRadius = 10
//        takePictureButton.backgroundColor = backgroundColor
//        takePictureButton.setTitleColor(UIColor.white, for: .normal)
        
        self.stepLabel.text = "STEP1: Taking Pictures of Baby"
        stepLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)

        self.stepLabel.textColor = UIColor.white
        self.stepLabel.transform = CGAffineTransform(rotationAngle: .pi/2)
        
//        self.view.bringSubviewToFront(takePictureButton)
        

        
    }
    
    /* Function: before starting taking a photo, set up the AVCaptureSession to take a photo during this view */
    func setupCaptureSession() {
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    /* Function: before going to next view controller (WeightRecordViewController), pass the image to the
     * WeightRecordlViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "takePic_To_ImageResult_Segue" {
            let previewVC = segue.destination as! ImageViewController
            previewVC.images = self.images
            previewVC.user = self.user
        }

    }

    /* Function: call the WeightRecordView with the AVCapturePhotoSettings by calling AVCapturePhotoCaptureDelegate */
//    @IBAction func takePicture_TouchUpInside(_ sender: Any) {
//
//        let settings = AVCapturePhotoSettings()
//        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [
//            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//            kCVPixelBufferWidthKey as String: 160,
//            kCVPixelBufferHeightKey as String: 160
//        ]
//        settings.previewPhotoFormat = previewFormat
//
//        photoOutput?.capturePhoto(with: settings, delegate: self)
//
//
//    }
    
    func takePicture() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        
        photoOutput?.capturePhoto(with: settings, delegate: self)

    }
    
    func setupTrackerIfNeeded(){
        if trackerSetup {return}
        
//        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//        let calibPath = "\(docsDir)/camera_parameters.yml"
        
        
        let stringPath = Bundle.main.path(forResource: "camera_parameters", ofType: "yml")!
 
        if !FileManager.default.fileExists(atPath: stringPath) {
            warnUser()

        } else {
            
            arucoTracker = ArucoTracker(calibrationFile: stringPath, delegate: self)
            setupSession()
            trackerSetup = true
        }
    }
    func showCalibrator(_ sender: Any) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let calibratorViewController = storyBoard.instantiateViewController(withIdentifier: "calibrator") as! CalibratorViewController
        self.present(calibratorViewController, animated: true, completion: nil)

    }

    
    func warnUser() {
        let alert = UIAlertController(
            title: "Warning",
            message: "Camera calibration file (camera_parameters.yml) not found in Documents folder; this is necessary for accurate pose detection.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Calibrate", style: .default, handler: showCalibrator))
        alert.addAction(UIAlertAction(title: "Ignore", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    func rotated() {
        
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            //do something
            print("1")
            break
        case .portraitUpsideDown:
            print("2")
            break
        case .landscapeLeft:
            print("3")
            break
        case .landscapeRight:
            print("4")
            break
        case .unknown:
            //default
            break
        }


    }

}

/* Delegate: using the AVCapturePhotoCaptureDelegate to prepare the image for the imageview in the WeightRecordlViewController */
extension TakePictureViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            
            imageCount += 1
            print(UIImage(data: imageData)?.size as Any)
            let image = UIImage(data: imageData)!
            self.images.append(image)
                        
            if(imageCount > 2){
                performSegue(withIdentifier: "takePic_To_ImageResult_Segue", sender: nil)
            }
        }
    }
}

extension TakePictureViewController: ArucoTrackerDelegate {
    
    func arucoTracker(_ tracker: ArucoTracker, didDetect markers: [ArucoMarker], preview: UIImage?, get: Bool) {
        DispatchQueue.main.async { [unowned self] in

            self.camView.image = preview
            if(get == true){
                
                self.stepLabel.text = "HOLD STILL YOUR PHONE FOR UNTIL TAKING A PICTURE"
                self.stepLabel.font = UIFont(name: "Helvetica" ,size: 10.0)
                self.stepLabel.textColor = UIColor.red
                TakePictureViewController.countDownForTakingPicture += 1

                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                if(TakePictureViewController.countDownForTakingPicture == 25){
//                    self.takePictureButton.sendActions(for: .touchUpInside)
                    self.takePicture()
                    TakePictureViewController.countDownForTakingPicture = 0

                }
                
            }else{
                self.stepLabel.text = "STEP1: Taking Pictures of Baby"
                self.stepLabel.font = UIFont(name: "Helvetica" ,size: 13.0)
                self.stepLabel.textColor = UIColor.white
                TakePictureViewController.countDownForTakingPicture = 0
            }

        }


    }

    

}


