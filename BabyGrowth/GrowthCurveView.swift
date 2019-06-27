//
//  GrowthCurveViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class GrowthCurveViewController: UIViewController {
    
    @IBOutlet weak var growthCurveLabel: UILabel!
    @IBOutlet weak var graphImageView: UIImageView!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUIToView()
        // Do any additional setup after loading the view.
    }
    
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set background color: pink */
//        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        homeButton.layer.cornerRadius = 10
        homeButton.backgroundColor = backgroundColor
        homeButton.setTitleColor(UIColor.white, for: .normal)

    }
}
