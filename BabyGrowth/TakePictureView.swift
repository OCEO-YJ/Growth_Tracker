//
//  TakePictureViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class TakePictureViewController: UIViewController {
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePictureButton: UIButton!
    
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
        retakeButton.layer.cornerRadius = 10
        retakeButton.backgroundColor = backgroundColor
        retakeButton.setTitleColor(UIColor.white, for: .normal)
        
        takePictureButton.layer.cornerRadius = 10
        takePictureButton.backgroundColor = backgroundColor
        takePictureButton.setTitleColor(UIColor.white, for: .normal)

        
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
