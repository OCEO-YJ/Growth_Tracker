//
//  SignUpViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 7/27/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastDigitLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastDigitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backLabel: UILabel!
    
    let datePicker = UIDatePicker()
    let numberPad = UIKeyboardType.numberPad
    
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUIToView()

    }
    
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set background color: pink */
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
        let backgroundColorButton = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 0.5)

        /* set the all the label's texts have a bold and size to 10 and pink color*/
        userNameLabel.textColor = backgroundColor
        userNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        lastDigitLabel.textColor = backgroundColor
        lastDigitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        dateLabel.textColor = backgroundColor
        dateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = backgroundColorButton
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.isEnabled = false
        
        [userNameTextField, lastDigitTextField, dateTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingDidEnd) })
        
        lastDigitTextField.addTarget(self, action: #selector(checkdigit(_:)), for: .editingDidEnd)
        
        
        /* by using a helper swift file, set the all the text field to have a underline without border */
        userNameTextField.underlined()
        lastDigitTextField.underlined()
        dateTextField.underlined()
        
        /* set the tool bar Items (Cancel - Space - Done) */
        let toolbar_LastDigit = UIToolbar();
        toolbar_LastDigit.sizeToFit()
        let doneButton_LastDigit = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_numberPad));
        let spaceButton_LastDigit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton_LastDigit = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel_numberPad));
        toolbar_LastDigit.setItems([cancelButton_LastDigit,spaceButton_LastDigit,doneButton_LastDigit], animated: false)
        
        /* connect the date picker to the weightTextField */
        lastDigitTextField.keyboardType = UIKeyboardType.numberPad
        lastDigitTextField.inputAccessoryView = toolbar_LastDigit
        
        showDatePicker()
        
        backLabel.textColor = helper.buttonEnabledColorToPurple()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return true
    }

    /* Function that set the date picker */
    func showDatePicker(){
        
        /* set the datePick mode as a date*/
        datePicker.datePickerMode = .date
        
        /* create a tool bar that has two buttons, Done and Cancel.
         * the space button is the button that just to give a space between done button and cancel button */
        let toolbar_BabyDate = UIToolbar();
        toolbar_BabyDate.sizeToFit()
        let doneButton_BabyDate = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton_BabyDate = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton_BabyDate = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar_BabyDate.setItems([cancelButton_BabyDate,spaceButton_BabyDate,doneButton_BabyDate], animated: false)
        
        /* connect the date picker to the baby_date_textField */
        dateTextField.inputAccessoryView = toolbar_BabyDate
        dateTextField.inputView = datePicker
        
    }
    
    @objc func checkdigit (_ textfiled: UITextField) {
    
        if(lastDigitTextField.text!.count != 4){
            lastDigitLabel.textColor = .red
        }else{
            lastDigitLabel.textColor = helper.buttonEnabledColorToPurple()
        }
    
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        
        if ((!userNameTextField.text!.isEmpty) && (!lastDigitTextField.text!.isEmpty) && (!dateTextField.text!.isEmpty)) && (lastDigitTextField.text!.count == 4){
            
            let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
            signUpButton.backgroundColor = backgroundColor
            signUpButton.isEnabled = true
            
            
        }else{
            
            
            let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 0.5)
            signUpButton.backgroundColor = backgroundColor
            signUpButton.isEnabled = false
            
        }
    }

    
    @IBAction func logoutButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "signup_To_Main_Segue", sender: nil)
    }
    
    @IBAction func signUpButton_TouchUpInside(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            var userEmail = "\(userNameTextField.text!)@growthTracker.com"
            var userPW = "\(lastDigitTextField.text!)-\(dateTextField.text!)"
            
            self.user.name = userNameTextField.text!
            self.user.lastDigit = lastDigitTextField.text!
            self.user.babyBirth = dateTextField.text!
            
            print(self.user.name)
            print(self.user.lastDigit)
            print(self.user.babyBirth)
            
            Auth.auth().createUser(withEmail: userEmail, password: userPW) { (result, error) in
                if let error = error {
                    print("Failed to create a user", error.localizedDescription)
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                
                let values = ["email":userEmail, "username":self.userNameTextField.text!, "lastDigit": self.lastDigitTextField.text!, "babyDate":self.dateTextField.text!]
                Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print("Failed to update database values with error: ", error.localizedDescription)
                        return
                    }
                    print("Success")
                    self.performSegue(withIdentifier: "signUp_To_Login_Segue", sender: nil)
                })
                
                
            }

        }else {
            self.setAlertToExit()
        }
        
        
    }
    
     func setAlertToExit(){
        let alertView = UIAlertController(title: "Internet Connection Problem", message: "Please check you Internet Connection to run the App properly", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            /*******************************/
        }))
        
        self.present(alertView, animated: true)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp_To_Login_Segue" {
            let previewVC = segue.destination as! LoginViewController
            previewVC.user = self.user
            

//            previewVC.user = userIdentificationArray
        }

    }
    
    /* create an object function for the done button in the date picker tool bar */
    @objc func donedatePicker(){
        
        /* set the date picker has a specific date formant to be put in the baby_date_textField */
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /* create an object function for the cancel button in the date picker tool bar */
    @objc func cancelDatePicker(){
        
        /* when user clicked, then the date picker will be dismissed */
        dateTextField.text = ""
        self.view.endEditing(true)
    }
    
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func cancel_numberPad(){
        
        lastDigitTextField.text = ""
        self.view.endEditing(true)
    }
    
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func done_numberPad(){
        
        self.view.endEditing(true)
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
