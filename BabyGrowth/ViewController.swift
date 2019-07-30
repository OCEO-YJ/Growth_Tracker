//
//  ViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/24/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate{
    
    /*IBOutlet Field*/
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastDigitLabel: UILabel!
    @IBOutlet weak var babyDateLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastDigitTextField: UITextField!
    @IBOutlet weak var babyDateTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let datePicker = UIDatePicker()
    let numberPad = UIKeyboardType.numberPad
    
//    var handle: AuthStateDidChangeListenerHandle?
    let dispatchgroup = DispatchGroup()
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIToBeforeStart(set: true)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticationUserAndConfigureView()

        
    }
    
    func setAlertToLogin(){
        let alertView = UIAlertController(title: "Wrong Username or Password", message: "Please check your Username or Password again", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        }))
        
        self.present(alertView, animated: true)
        
    }


    /* Function: set all the UIs to the View */
    func setUIToView() {
        
//        babyDateLabel.isHidden = true
//        babyDateTextField.isHidden = true
        
        /* set background color: pink */
//        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
        let backgroundColorButton = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 0.5)

        /* set the all the label's texts have a bold and size to 10 and pink color*/
        userNameLabel.textColor = backgroundColor
        userNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        lastDigitLabel.textColor = backgroundColor
        lastDigitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        babyDateLabel.textColor = backgroundColor
        babyDateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = backgroundColorButton
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.isEnabled = false
        
        [userNameTextField, lastDigitTextField, babyDateTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingDidEnd) })

        signUpButton.setTitleColor(backgroundColor, for: .normal)

        /* by using a helper swift file, set the all the text field to have a underline without border */
        userNameTextField.underlined()
        lastDigitTextField.underlined()
        babyDateTextField.underlined()
        
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

    }
    
    /* From text field's delegate, whenever user click "return", then the keyboard will be dismiss from the view */
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
        babyDateTextField.inputAccessoryView = toolbar_BabyDate
        babyDateTextField.inputView = datePicker
        
    }
    
    /* create an object function for the done button in the date picker tool bar */
    @objc func donedatePicker(){
        
        /* set the date picker has a specific date formant to be put in the baby_date_textField */
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        babyDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /* create an object function for the cancel button in the date picker tool bar */
    @objc func cancelDatePicker(){
        
        /* when user clicked, then the date picker will be dismissed */
        babyDateTextField.text = ""
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

    @IBAction func signUpButton_TouchUpInside(_ sender: Any) {
        
        performSegue(withIdentifier: "Main_To_SignUp_Segue", sender: self)
    }
    
    /* Function that moves to the Login View when user click the button */
    @IBAction func loginButton_TouchUpInside(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            let userEmail = "\(self.userNameTextField.text!)@growthTracker.com"
            let userPW = "\(self.lastDigitTextField.text!)-\(babyDateTextField.text!)"
            
            Auth.auth().signIn(withEmail: userEmail, password: userPW) { (result, error) in
                if let error = error {
                    self.setAlertToLogin()
                    print("Failed to login in with an error:", error.localizedDescription)
                    return
                }
                self.user.name = self.userNameTextField.text!
                self.user.lastDigit = self.lastDigitTextField.text!
                self.user.babyBirth = self.babyDateTextField.text!
                print("Successfully logged in ")
                self.performSegue(withIdentifier: "Main_To_Login_Segue", sender: self)
                
                
            }

        }else {
            setAlertToExit()
        }

    }
    
     func setAlertToExit(){
        let alertView = UIAlertController(title: "Internet Connection Problem", message: "Please check you Internet Connection to run the App properly", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            /*******************************/
        }))
        
        self.present(alertView, animated: true)
        
    }

    func setUIToBeforeStart(set: Bool){
        userNameLabel.isHidden = set
        userNameTextField.isHidden = set
        
        lastDigitLabel.isHidden = set
        lastDigitTextField.isHidden = set
        
        babyDateLabel.isHidden = set
        babyDateTextField.isHidden = set
        
        accountLabel.isHidden = set
        signUpButton.isHidden = set
        
        loginButton.isHidden = set
        
    }
    
    
    func authenticationUserAndConfigureView() {
        
        if Reachability.isConnectedToNetwork() {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    print("logged in ")
                    self.dispatchgroup.enter()
                    getUser(with: user.uid, completion: { (user) in
                        self.user = user
                        self.dispatchgroup.leave()
                        
                    })
                    self.dispatchgroup.notify(queue: .main, execute: {
                        
                        self.performSegue(withIdentifier: "Main_To_Login_Segue", sender: self)
                    })
                } else {
                    self.setUIToView()
                    self.setUIToBeforeStart(set: false)
                    print("not logged in ")
                }
            }

        }else {
            let message = UILabel()
            message.text = "There is an Internet Connection Problem. \n Please check your Wi-Fi or Cellular Data again :)"
            message.translatesAutoresizingMaskIntoConstraints = false
            message.lineBreakMode = .byWordWrapping
            message.numberOfLines = 0
            message.textAlignment = .center
            
            self.view.addSubview(message)
            
            message.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.setUIToBeforeStart(set: true)

        }
        
    }
    
    
    @objc func editingChanged(_ textField: UITextField) {
        
        if ((!userNameTextField.text!.isEmpty) && (!lastDigitTextField.text!.isEmpty) && (!babyDateTextField.text!.isEmpty)) && (lastDigitTextField.text!.count == 4){
            
            let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
            loginButton.backgroundColor = backgroundColor
            loginButton.isEnabled = true
            
        }else{
            
            let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 0.5)
            loginButton.backgroundColor = backgroundColor
            loginButton.isEnabled = false

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Main_To_Login_Segue" {

            let previewVC = segue.destination as! LoginViewController
            
            previewVC.user = self.user
        }
        
    }

    
}



func getUser(with userID: String, completion: @escaping ((_ user: User) -> Void)) {
    Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
        // Get user value
        let value = snapshot.value as? [String: Any]
        let username = value?["username"] as? String ?? ""
        let userDigit = value?["lastDigit"] as? String ?? ""
        let userDate = value?["babyDate"] as? String ?? ""
        
        var user = User()
        user.name = username
        user.lastDigit = userDigit
        user.babyBirth = userDate
        
        DispatchQueue.main.async {
            completion(user)
        }
    }
}


