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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var image: UIImage!
    
    var user = User()
    
    var docRefUser: DocumentReference!
    var docRefDate: DocumentReference!
    
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUIToView()
        photo.image = self.image
        

        

    }
    
    func setUIToView(){
        
        
        
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = helper.buttonEnabledColorToPurple()
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        finishButton.layer.cornerRadius = 10
        finishButton.backgroundColor = helper.buttonDisEnabledColorToPurple()
        finishButton.isEnabled = false
        finishButton.setTitleColor(UIColor.white, for: .normal)
        
        
        blurryButton.layer.cornerRadius = 10
        blurryButton.backgroundColor = backgroundColor
        blurryButton.setTitleColor(UIColor.white, for: .normal)
        
        indicator.isHidden = true
        indicator.color = .yellow
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        /* set the weightTextField to have information string with the light gray color using a numberPad */
        weightTextField.text = "Input Baby's Weight (LB)"
        weightTextField.textAlignment = NSTextAlignment.center
        weightTextField.textColor = UIColor.red
        weightTextField.font =  UIFont(name: (weightTextField.font?.fontName)!, size: CGFloat(10.0))

        /* set the tool bar Items (Cancel - Space - Done) */
        let toolbar_LastDigit = UIToolbar();
        toolbar_LastDigit.sizeToFit()
        let doneButton_LastDigit = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_numberPad));
        let spaceButton_LastDigit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton_LastDigit = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel_numberPad));
        toolbar_LastDigit.setItems([cancelButton_LastDigit,spaceButton_LastDigit,doneButton_LastDigit], animated: false)

        /* connect the date picker to the weightTextField */
        weightTextField.keyboardType = UIKeyboardType.decimalPad
        weightTextField.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        weightTextField.inputAccessoryView = toolbar_LastDigit
//        weightTextField.addTarget(self, action: #selector(checkInput(_:)), for: .editingDidEnd)

        let userFilePath = helper.getUserFilePath(userName: user.name!, userLastDigit: user.lastDigit!)
        
        docRefUser = Firestore.firestore().collection("growthTrackerData").document("\(userFilePath)")
        docRefDate = Firestore.firestore().collection("growthTrackerData").document("\(userFilePath)").collection("Dates").document("\(helper.getCurrentDateAndTime())")
        

    }
    
    @objc func checkInput(_ textfiled: UITextField){
        if weightTextField.text!.count != 0 {
            weightTextField.textColor = .black
            finishButton.backgroundColor = helper.buttonEnabledColorToPurple()
            finishButton.isEnabled = true
        }else {
            weightTextField.textColor = .red
        }
    }
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func done_numberPad(){
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
        
        if weightTextField.text?.isEmpty ?? true {
            finishButton.isEnabled = false
            finishButton.backgroundColor = helper.buttonDisEnabledColorToPurple()
            weightTextField.text = "Input Baby's Weight (LB)"
            weightTextField.textColor = .red

            
        } else {
            finishButton.isEnabled = true
            weightTextField.textColor = .black
            finishButton.backgroundColor = helper.buttonEnabledColorToPurple()
        }
        self.view.endEditing(true)
    }

    
    @objc func cancel_numberPad(){
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
        weightTextField.text = "Input Baby's Weight (LB)"
        weightTextField.textColor = .red
        
        if weightTextField.text?.isEmpty ?? true {
            finishButton.isEnabled = false
            finishButton.backgroundColor = helper.buttonDisEnabledColorToPurple()

        }

        self.view.endEditing(true)
    }


    @IBAction func textField_TouchDown(_ sender: Any) {
        weightTextField.text = ""
    }
    
    @IBAction func blurry_Button_TouchUpInside(_ sender: Any) {
        
        if blurryButton.title(for: .normal) == "RETAKE"{
            
            dismiss(animated: true, completion: nil)
            
        }
        
        blurryButton.setTitle("RETAKE", for: .normal)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Results_To_End_Segue" {
            let previewVC = segue.destination as! EndViewController
            previewVC.user = user
        }
        
    }

    

    @IBAction func finish_Button_TouchUpInside(_ sender: Any) {
        

        indicator.isHidden = false
        
        finishButton.isEnabled = false
        finishButton.backgroundColor = helper.buttonDisEnabledColorToPurple()
        
        blurryButton.isEnabled = false
        blurryButton.backgroundColor = helper.buttonDisEnabledColorToPurple()
        
        if finishButton.title(for: .normal) == "UPLOAD"{
            
            
            let userBabyWeight = weightTextField.text!
            
            let userIdentificationToSave:[String: Any] = ["User Name": user.name!, "User Identification": helper.getUserFilePath(userName: user.name!, userLastDigit: user.lastDigit!)]
            let userDataToSave:[String: Any] = ["Baby_Weight_(LB)": userBabyWeight, "Last Time Input Data": helper.getCurrentMonth()]
            
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
            
            
            let userFilePath = helper.getUserFilePath(userName: user.name!, userLastDigit: user.lastDigit!)
            
            let reference = "\(userFilePath)/WeightScalePhoto/\(weightTextField.text!)LB ::: \(helper.getCurrentDateAndTime()).jpg"
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
            }
            
            taskReference.observe(.success) { (snapshot) in
                
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                self.finishButton.backgroundColor = helper.buttonEnabledColorToPurple()
                self.finishButton.isEnabled = true
                self.finishButton.setTitle("NEXT", for: .normal)

            }
        }
        
        else{
                performSegue(withIdentifier: "Results_To_End_Segue", sender: nil)
        }
        
    }
}
