//
//  WeightResultsRecordViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 7/10/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class WeightResultsRecordViewController: UIViewController {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var blurryButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    var image: UIImage!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIToView()
        photo.image = self.image

        // Do any additional setup after loading the view.
    }
    
    func setUIToView(){
        
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        finishButton.layer.cornerRadius = 10
        finishButton.backgroundColor = backgroundColor
        finishButton.setTitleColor(UIColor.white, for: .normal)
        
        blurryButton.layer.cornerRadius = 10
        blurryButton.backgroundColor = backgroundColor
        blurryButton.setTitleColor(UIColor.white, for: .normal)
        
        uploadButton.layer.cornerRadius = 10
        uploadButton.backgroundColor = backgroundColor
        uploadButton.setTitleColor(UIColor.white, for: .normal)

    
    /* set the weightTextField to have information string with the light gray color using a numberPad */
    weightTextField.text = "Input Baby's Weight (Kg)"
    weightTextField.textAlignment = NSTextAlignment.center
    weightTextField.textColor = UIColor.lightGray
    weightTextField.font =  UIFont(name: (weightTextField.font?.fontName)!, size: CGFloat(10.0))
    
    /* set the tool bar Items (Cancel - Space - Done) */
    let toolbar_LastDigit = UIToolbar();
    toolbar_LastDigit.sizeToFit()
    let doneButton_LastDigit = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done_cancel_numberPad));
    let spaceButton_LastDigit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton_LastDigit = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(done_cancel_numberPad));
    toolbar_LastDigit.setItems([cancelButton_LastDigit,spaceButton_LastDigit,doneButton_LastDigit], animated: false)
    
    /* connect the date picker to the weightTextField */
    weightTextField.keyboardType = UIKeyboardType.numberPad
    weightTextField.inputAccessoryView = toolbar_LastDigit
    
    }
    
    /* create an object function for the cancel and done button in the number pad tool bar */
    @objc func done_cancel_numberPad(){
        /* set the numberPad has a specific weight formant to be put in the weightTextField */
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
    @IBAction func finish_Button_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "Results_To_End_Segue", sender: nil)
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
