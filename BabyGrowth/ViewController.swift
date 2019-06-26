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
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUIToView()
        
    }
    
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set background color: pink */
        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        
        /* set the all the label's texts have a bold and size to 10 and pink color*/
        userNameLabel.textColor = backgroundColor
        userNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        passwordLabel.textColor = backgroundColor
        passwordLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = backgroundColor
        loginButton.setTitleColor(UIColor.white, for: .normal)
        
        /* by using a helper swift file, set the all the text field to have a underline without border */
        userNameTextField.underlined()
        passwordTextField.underlined()
        
        /* set the button (Sign_Up Button) text to have a black color with underline*/
        signUpButton.tintColor = UIColor.black
        signUpButton.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: UIControl.State.normal)

    }
    
    /* From text field's delegate, whenever user click "return", then the keyboard will be dismiss from the view */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    /* Function that moves to the Login View when user click the button */
    @IBAction func loginButton_Cliceked(_ sender: Any) {
        performSegue(withIdentifier: "LoginView", sender: self)
    }
    
    /* Function that moves to the Sign_Up View when user click the button */
    @IBAction func signUpButton_Clicked(_ sender: Any) {
        performSegue(withIdentifier: "SignUpView", sender: self)
        
    }
    
}


