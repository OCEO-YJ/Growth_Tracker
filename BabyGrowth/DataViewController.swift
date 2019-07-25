//
//  DataViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 7/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

//    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
//        progressView.isHidden = true
        
        imageView.image = image

//        display.text = displayText
        // Do any additional setup after loading the view.
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
