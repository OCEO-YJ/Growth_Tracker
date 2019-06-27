//
//  LoginViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/24/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var LoginImageView: UIImageView!
    @IBOutlet weak var lastCheckInLabel: UILabel!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var growthCurveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIToView()
    }
    

    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set background color: pink */
//        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)

        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        takePictureButton.layer.cornerRadius = 10
        takePictureButton.backgroundColor = backgroundColor
        takePictureButton.setTitleColor(UIColor.white, for: .normal)
        
        growthCurveButton.layer.cornerRadius = 10
        growthCurveButton.backgroundColor = backgroundColor
        growthCurveButton.setTitleColor(UIColor.white, for: .normal)

    }
}
