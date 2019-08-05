//
//  LoginViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 6/27/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseFirestore
import Firebase


class LoginViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var LoginImageView: UIImageView!
    @IBOutlet weak var lastCheckInLabel: UILabel!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var growthCurveButton: UIButton!
    @IBOutlet weak var sendTextMessage: UIButton!
    @IBOutlet weak var lastCheckInHeader: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var needHelpLabel: UILabel!
    
    var user = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            setUIToView()
            getData(user: user)

    }
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set background color: pink */
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        takePictureButton.layer.cornerRadius = 10
        takePictureButton.backgroundColor = helper.buttonEnabledColorToPurple()
        takePictureButton.setTitleColor(UIColor.white, for: .normal)
        
        growthCurveButton.layer.cornerRadius = 10
        growthCurveButton.backgroundColor = helper.buttonEnabledColorToPurple()
        growthCurveButton.setTitleColor(UIColor.white, for: .normal)
        
        logoutLabel.textColor = helper.buttonEnabledColorToPurple()
        needHelpLabel.textColor = helper.buttonEnabledColorToPurple()
        
    }

    /* Function: if the user clicks the take a picture button, then the user would go the camera view */
    @IBAction func takePictureButton_TouchUpInside(_ sender: Any) {
        
        let alertView = UIAlertController(title: "Device Orientation", message: "Please make sure your device is in landscape position", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            /*******************************/
            self.performSegue(withIdentifier: "Login_To_TakePicrue_Segue", sender: nil)

        }))
        
        self.present(alertView, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Login_To_TakePicrue_Segue" {
            let previewVC = segue.destination as! TakePictureViewController
            previewVC.user = user
        }
        
        if segue.identifier == "Login_To_GrowthCurve_Segue" {
            let previewVC = segue.destination as! GrowthCurveViewController
            previewVC.user = user
        }

    }

    func getData(user: User) {
        
        let userFilePath = helper.getUserFilePath(userName: user.name!, userLastDigit: user.lastDigit!)
        
        let cloudRef =  Firestore.firestore().collection("growthTrackerData").document("\(userFilePath)").collection("Dates")
        
        
        cloudRef.getDocuments { (querySnapshot, err) in
            if let err = err{
                print("error: \(err.localizedDescription)")
            }else{
                if querySnapshot!.documents.count == 0{

                     self.lastCheckInLabel.text =  "First time to use the App"
                }else{
                    let myData = querySnapshot!.documents[querySnapshot!.documents.count - 1].documentID

                    self.lastCheckInLabel.text = myData
                }
                
            }
        }
    }


    /* Function: if the user clicks the view growth curve button, then the user would go the growth curve view */
    @IBAction func viewGrowthCurveButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "Login_To_GrowthCurve_Segue", sender: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutButton_TouchUpInSide(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "Login_To_Main_Segue", sender: nil)

        }catch let error {
            print("Failed to sign out->\(error.localizedDescription)")
        }
    }
    
    @IBAction func sendTextMessage_TouchUpInSide(_ sender: Any) {
        
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = ["425-365-8616"]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = "Do you need any help? Please give us feedback"
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
        }

    }
    
}


