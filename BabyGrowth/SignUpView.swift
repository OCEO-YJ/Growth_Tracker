//
//  SignUpView.swift
//  BabyGrowth
//
//  Created by OCEO on 6/24/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    /*IBOutlet & Global Variable Field*/
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var babyNameLabel: UILabel!
    @IBOutlet weak var babyDateLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var babyNameTextField: UITextField!
    @IBOutlet weak var babyDateTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUIToView()

    }
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set background color: pink */
//        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)

        /* set the all the label's texts have a bold and size to 10 and pink color*/
        userNameLabel.textColor = backgroundColor
        userNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        passwordLabel.textColor = backgroundColor
        passwordLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        babyNameLabel.textColor = backgroundColor
        babyNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        babyDateLabel.textColor = backgroundColor
        babyDateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        /* by using a helper swift file, set the all the text field to have a underline without border */
        userNameTextField.underlined()
        passwordTextField.underlined()
        babyNameTextField.underlined()
        babyDateTextField.underlined()
        
        /* set the button (Sign_Up Button) text to have a black color with underline*/
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = backgroundColor
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    /* From text field's delegate, whenever user click "return", then the keyboard will be dismiss from the view */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        babyNameTextField.resignFirstResponder()
        babyDateTextField.resignFirstResponder()
        return true
    }

    /* Function is called when the baby_date_textField is clicked to show date picker */
    @IBAction func babyDateClicked(_ sender: Any) {
        showDatePicker()
    }
    
    /* Function that set the date picker */
    func showDatePicker(){
        
        /* set the datePick mode as a date*/
        datePicker.datePickerMode = .date
        
        /* create a tool bar that has two buttons, Done and Cancel.
         * the space button is the button that just to give a space between done button and cancel button */
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        /* connect the date picker to the baby_date_textField */
        babyDateTextField.inputAccessoryView = toolbar
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
        self.view.endEditing(true)
    }
    
    /* Function that passes all the information to the database (AWS)  */
    @IBAction func signUpButton_Clicked(_ sender: Any) {
    }
}
    

