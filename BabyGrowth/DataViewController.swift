//
//  DataViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 7/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    

}
