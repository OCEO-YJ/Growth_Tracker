//
//  WeightRecordlViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class WeightRecordlViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    
    var image: UIImage!
    
    @IBOutlet weak var photo: UIImageView!
    
    let numberPad = UIKeyboardType.numberPad

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* set the imageview with the image that user took a photo from the TakePicture View Controller */
        photo.image = self.image

        setUIToView()

    }
    
    /* Function: go back to previous view to retake a photo */
    @IBAction func retakeButton_Clicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
//        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)

        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        uploadButton.layer.cornerRadius = 10
        uploadButton.backgroundColor = backgroundColor
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        
        finishButton.layer.cornerRadius = 10
        finishButton.backgroundColor = backgroundColor
        finishButton.setTitleColor(UIColor.white, for: .normal)
        
        retakeButton.layer.cornerRadius = 10
        retakeButton.backgroundColor = backgroundColor
        retakeButton.setTitleColor(UIColor.white, for: .normal)
        
        /* set the weightTextField to have information string with the light gray color using a numberPad */
        weightTextField.text = "Input Baby's Weight (Kg)"
        weightTextField.textAlignment = NSTextAlignment.center
        weightTextField.textColor = UIColor.lightGray
        weightTextField.font =  UIFont(name: (weightTextField.font?.fontName)!, size: CGFloat(10.0))
        weightTextField.keyboardType = UIKeyboardType.numberPad
        
        /* create a tool bar that has two buttons, Done and Cancel.
         * the space button is the button that just to give a space between done button and cancel button */
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_cancel_numberPad));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(done_cancel_numberPad));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        /* connect the date picker to the weightTextField */
        weightTextField.inputAccessoryView = toolbar
        
    }
    
    /* From text field's delegate, whenever user click "return", then the keyboard will be dismiss from the view */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weightTextField.resignFirstResponder()
        return true
    }
    /* Function: when user click the text field, the information string of the inside would be gone */
    @IBAction func textField_Clicked(_ sender: Any) {
        weightTextField.text = ""
    }
    
    /* create an object function for the done and cancel button for the numberPad tool bar */
    @objc func done_cancel_numberPad(){
        
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
        self.view.endEditing(true)
    }
    
}
