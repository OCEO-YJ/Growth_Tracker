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
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIToView()

        // Do any additional setup after loading the view.
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
        
        
    }
    
    /* From text field's delegate, whenever user click "return", then the keyboard will be dismiss from the view */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weightTextField.resignFirstResponder()
        return true
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
