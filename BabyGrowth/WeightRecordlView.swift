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
    
    
    func setUIToView() {
        
        
        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        
        uploadButton.layer.cornerRadius = 10
        uploadButton.backgroundColor = backgroundColor
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        
        finishButton.layer.cornerRadius = 10
        finishButton.backgroundColor = backgroundColor
        finishButton.setTitleColor(UIColor.white, for: .normal)
        
        
    }
    
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
