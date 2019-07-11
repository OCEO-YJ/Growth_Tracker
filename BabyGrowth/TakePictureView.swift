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
    
    @IBOutlet weak var stepLabel: UILabel!
    
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
    static var count = 0
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTrackerIfNeeded()
        captureSession?.startRunning()
        self.stepLabel.text = "STEP1: Taking Pictures of Baby"
        self.stepLabel.textColor = UIColor.white
        self.view.bringSubviewToFront(takePictureButton)
        self.view.bringSubviewToFront(stepLabel)

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
    
    func arucoTracker(_ tracker: ArucoTracker, didDetect markers: [ArucoMarker], preview: UIImage?, get: Bool) {
        DispatchQueue.main.async { [unowned self] in
            
            self.camView.image = preview
            
            if(get == true){
                
                self.stepLabel.text = "HOLD STILL YOUR PHONE FOR UNTIL TAKING A PICTURE"
                self.stepLabel.font = UIFont(name: "Helvetica" ,size: 10.0)
                self.stepLabel.textColor = UIColor.red
                TakePictureViewController.count += 1

                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                if(TakePictureViewController.count == 25){
                    self.takePictureButton.sendActions(for: .touchUpInside)
                }
                
            }else{
                self.stepLabel.text = "STEP1: Taking Pictures of Baby"
                self.stepLabel.font = UIFont(name: "Helvetica" ,size: 13.0)
                self.stepLabel.textColor = UIColor.white
                TakePictureViewController.count = 0
            }
            
            print(TakePictureViewController.count)

            }
        

    }

    

    }
//    func arucoTracker(_ tracker: ArucoTracker, didDetect markers: [ArucoMarker], preview: UIImage?) {
//        DispatchQueue.main.async { [unowned self] in
//
//            self.camView.image = preview
//        }
//    }





class TimerModel: NSObject {
    static let sharedTimer: TimerModel = {
        let timer = TimerModel()
        return timer
    }()
    
    var internalTimer: Timer?
    var jobs = [() -> Void]()
    
    func startTimer(withInterval interval: Double, andJob job: @escaping () -> Void) {
        if internalTimer != nil {
            internalTimer?.invalidate()
        }
        jobs.append(job)
        internalTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(doJob), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
    }
    
    func stopTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        jobs = [()->()]()
        internalTimer?.invalidate()
    }
    
    @objc func doJob() {
        guard jobs.count > 0 else { return }
        for job in jobs {
            job()
        }
    }
    
}

class MyGlobalTimer: NSObject {
    
    
    static let sharedTimer: MyGlobalTimer = {
        let timer = MyGlobalTimer()
        return timer
    }()

    var internalTimer: Timer?
    
    func startTimer(){
        guard self.internalTimer != nil else {
            fatalError("Timer already intialized, how did we get here with a singleton?!")
        }
        self.internalTimer = Timer.scheduledTimer(timeInterval: 1.0 /*seconds*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        guard self.internalTimer != nil else {
            fatalError("No timer active, start the timer before you stop it.")
        }
        self.internalTimer?.invalidate()
    }
    
    @objc func fireTimerAction(sender: AnyObject?){
        debugPrint("Timer Fired! \(String(describing: sender))")
    }
    
}
