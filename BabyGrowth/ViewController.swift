//
//  ViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/24/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate{
    
    /*IBOutlet Field*/
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastDigitLabel: UILabel!
    @IBOutlet weak var babyDateLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastDigitTextField: UITextField!
    @IBOutlet weak var babyDateTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let datePicker = UIDatePicker()
    
    let numberPad = UIKeyboardType.numberPad


    
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
        lastDigitLabel.textColor = backgroundColor
        lastDigitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        babyDateLabel.textColor = backgroundColor
        babyDateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)

        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = backgroundColor
        loginButton.setTitleColor(UIColor.white, for: .normal)
        
        /* by using a helper swift file, set the all the text field to have a underline without border */
        userNameTextField.underlined()
        lastDigitTextField.underlined()
        babyDateTextField.underlined()
        
        /* set the tool bar Items (Cancel - Space - Done) */
        let toolbar_LastDigit = UIToolbar();
        toolbar_LastDigit.sizeToFit()
        let doneButton_LastDigit = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_cancel_numberPad));
        let spaceButton_LastDigit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton_LastDigit = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(done_cancel_numberPad));
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
        self.view.endEditing(true)
    }
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func done_cancel_numberPad(){
        
        self.view.endEditing(true)
    }


    /* Function that moves to the Login View when user click the button */
    @IBAction func loginButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "Main_To_Login_Segue", sender: self)
    }
    
}


