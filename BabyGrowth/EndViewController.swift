//
//  EndViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 6/27/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var viewGrowthCurveButton: UIButton!
    
    var user = User()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUIToView()

    }
    
    /* Function: set all the UIs to the View */
    func setUIToView(){
        
        /* set background color: pink */
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = helper.buttonEnabledColorToPurple()

        homeButton.layer.cornerRadius = 10
        homeButton.backgroundColor = backgroundColor
        homeButton.setTitleColor(UIColor.white, for: .normal)
        
        viewGrowthCurveButton.layer.cornerRadius = 10
        viewGrowthCurveButton.backgroundColor = backgroundColor
        viewGrowthCurveButton.setTitleColor(UIColor.white, for: .normal)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "End_To_Login_Segue" {
            let previewVC = segue.destination as! LoginViewController
            previewVC.user = user
        }
        
        if segue.identifier == "End_To_GrowthCurve_Segue" {
            let previewVC = segue.destination as! GrowthCurveViewController
            previewVC.user = user
        }

        
    }

    /* Function: goes to login view */
    @IBAction func homeButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "End_To_Login_Segue", sender: nil)
    }
    
    /* Function: goes to growth curve view */
    @IBAction func viewGrowthCurveButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "End_To_GrowthCurve_Segue", sender: nil)
    }

}
