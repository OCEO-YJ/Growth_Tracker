//
//  WeightResultsRecordViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 7/10/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WeightResultsRecordViewController: UIViewController {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var blurryButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var image: UIImage!
    var userIdentificationArray: [String] = []
    var docRefUser: DocumentReference!
    var docRefDate: DocumentReference!
    
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIToView()
        photo.image = self.image
        

        
        let userFilePath = getUserFilePath(userName: userIdentificationArray[0], userLastDigit: userIdentificationArray[1])

        
        docRefUser = Firestore.firestore().collection("growthTrackerData").document("\(userFilePath)")
 
        docRefDate = Firestore.firestore().collection("growthTrackerData").document("\(userFilePath)").collection("Dates").document("\(getCurrentDateAndTime())")

    }
    
    func setUIToView(){
        
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = buttonEnabledColorToPurple()
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        finishButton.layer.cornerRadius = 10
        finishButton.backgroundColor = backgroundColor
        finishButton.setTitleColor(UIColor.white, for: .normal)
        finishButton.isHidden = true
        
        blurryButton.layer.cornerRadius = 10
        blurryButton.backgroundColor = backgroundColor
        blurryButton.setTitleColor(UIColor.white, for: .normal)
        
        progressView.isHidden = true
        
        indicator.isHidden = true
        indicator.color = backgroundColor
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)

        
    
    /* set the weightTextField to have information string with the light gray color using a numberPad */
    weightTextField.text = "Input Baby's Weight (Kg)"
    weightTextField.textAlignment = NSTextAlignment.center
    weightTextField.textColor = UIColor.lightGray
    weightTextField.font =  UIFont(name: (weightTextField.font?.fontName)!, size: CGFloat(10.0))
    
    /* set the tool bar Items (Cancel - Space - Done) */
    let toolbar_LastDigit = UIToolbar();
    toolbar_LastDigit.sizeToFit()
    let doneButton_LastDigit = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_numberPad));
    let spaceButton_LastDigit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton_LastDigit = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel_numberPad));
    toolbar_LastDigit.setItems([cancelButton_LastDigit,spaceButton_LastDigit,doneButton_LastDigit], animated: false)
    
    /* connect the date picker to the weightTextField */
    weightTextField.keyboardType = UIKeyboardType.numberPad
    weightTextField.inputAccessoryView = toolbar_LastDigit
    
    }
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func done_numberPad(){
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
        
        if weightTextField.text?.isEmpty ?? true {
            finishButton.isHidden = true

        } else {
            finishButton.isHidden = false
        }
        self.view.endEditing(true)
    }

    
    @objc func cancel_numberPad(){
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
        weightTextField.text = ""
        
        if weightTextField.text?.isEmpty ?? true {
            finishButton.isHidden = true
        }

        self.view.endEditing(true)
    }


    @IBAction func textField_TouchDown(_ sender: Any) {
        weightTextField.text = ""
        
//        if ((userNameTextField.text!.isEmpty) && (lastDigitTextField.text!.isEmpty) && (babyDateTextField.text!.isEmpty)) {
//            print("empty")
//        }else{
//            print("X empty")
//
//        }


    }
    
    @IBAction func blurry_Button_TouchUpInside(_ sender: Any) {
        
        if blurryButton.title(for: .normal) == "RETAKE"{
            
            dismiss(animated: true, completion: nil)
            
        }
        
        blurryButton.setTitle("RETAKE", for: .normal)

        
    }
    
    func getCurrentDateAndTime() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getCurrentMonth() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Results_To_End_Segue" {
            let previewVC = segue.destination as! EndViewController
            previewVC.userIdentificationArray = userIdentificationArray
        }
        
    }

    

    @IBAction func finish_Button_TouchUpInside(_ sender: Any) {
        
//        progressView.isHidden = false

        indicator.isHidden = false
        
        finishButton.isEnabled = false
        finishButton.backgroundColor = buttonDisEnabledColorToPurple()
        
        blurryButton.isEnabled = false
        blurryButton.backgroundColor = buttonDisEnabledColorToPurple()
        
        if finishButton.title(for: .normal) == "UPLOAD"{
            
            
            let userBabyWeight = weightTextField.text!
            
            let userIdentificationToSave:[String: Any] = ["User Name": userIdentificationArray[0], "User Identification": getUserFilePath(userName: userIdentificationArray[0], userLastDigit: userIdentificationArray[1])]
            let userDataToSave:[String: Any] = ["Baby_Weight_(LB)": userBabyWeight, "Last Time Input Data": getCurrentMonth()]
            
            docRefUser.setData(userIdentificationToSave) { (error) in
                if let error = error {
                    print("Got an error: \(error.localizedDescription)")
                } else{
                    print("Success")
                }
            }
            
            docRefDate.setData(userDataToSave) { (error) in
                if let error = error {
                    print("Got an error: \(error.localizedDescription)")
                } else{

                    print("Success")
                }
            }
            
            
            let userFilePath = getUserFilePath(userName: userIdentificationArray[0], userLastDigit: userIdentificationArray[1])
            
            let reference = "\(userFilePath)/WeightScalePhoto/\(weightTextField.text!)kg ::: \(getCurrentDateAndTime()).jpg"
            let uploadRef = Storage.storage().reference(withPath: reference)
            guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            
            let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                print("Success")
            }
            
            taskReference.observe(.progress) { (snapshot) in
                self.indicator.startAnimating()
//                guard let pct = snapshot.progress?.fractionCompleted else { return }
//                self.progressView.progress = Float(pct)
//
//                print(self.progressView.progress)
//                if self.progressView.progress == 1.0 {
//
//                    self.finishButton.backgroundColor = self.buttonEnabledColorToPurple()
//                    self.finishButton.isEnabled = true
//                    self.finishButton.setTitle("FINISH", for: .normal)
//                }
                
            }
            taskReference.observe(.success) { (snapshot) in
                self.indicator.stopAnimating()
                self.finishButton.backgroundColor = self.buttonEnabledColorToPurple()
                self.finishButton.isEnabled = true
                self.finishButton.setTitle("NEXT", for: .normal)

            }
        }
        
        else{
                performSegue(withIdentifier: "Results_To_End_Segue", sender: nil)
        }
        
        
        
    }
    func buttonEnabledColorToPurple() -> UIColor {
        return UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
    }
    
    func buttonDisEnabledColorToPurple() -> UIColor {
        return UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 0.5)
    }

    
    func getUserFilePath(userName: String, userLastDigit: String) -> String {
        
        return "\(userName)\(userLastDigit)"
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
