//
//  WeightRecordlViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class ResultsRecordlViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    
    var image: UIImage!
    
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* set the imageview with the image that user took a photo from the TakePicture View Controller */
        photo.image = self.image
        
        setUIToView()
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        finishButton.layer.cornerRadius = 10
        finishButton.backgroundColor = backgroundColor
        finishButton.setTitleColor(UIColor.white, for: .normal)
        
        retakeButton.layer.cornerRadius = 10
        retakeButton.backgroundColor = backgroundColor
        retakeButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    /* Function: go back to previous view to retake a photo */
    @IBAction func retakeButton_TouchUpInside(_ sender: Any) {
        
        if retakeButton.title(for: .normal) == "RETAKE"{
            
            dismiss(animated: true, completion: nil)
            
        }

        retakeButton.setTitle("RETAKE", for: .normal)
    }
    
    /* Function: go to weight scale view to take a photo of weight scale */
    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "Results_To_WeightScale_Segue", sender: nil)
    }
    
}
