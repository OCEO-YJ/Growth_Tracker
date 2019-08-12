//
//  ImageViewController.swift
//  GrowthTracker
//
//  Created by OCEO on 7/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import Firebase


class ImageViewController: UIViewController {

//    @IBOutlet weak var contentView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var images =  [UIImage]()
    @IBOutlet weak var blurryButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentViewControllerIndex = 0
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePage()
        setUIToView()
        
    }
    
    func setUIToView() {
        
        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
        let backgroundColor = helper.buttonEnabledColorToPurple()
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        nextButton.layer.cornerRadius = 10
        nextButton.backgroundColor = backgroundColor
        nextButton.setTitleColor(UIColor.white, for: .normal)
        
        blurryButton.layer.cornerRadius = 10
        blurryButton.backgroundColor = backgroundColor
        blurryButton.setTitleColor(UIColor.white, for: .normal)
        
        indicator.isHidden = true
        indicator.color = .yellow
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            
    }

    
    func configurePage() {
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: ResultsRecordViewController.self)) as? ResultsRecordViewController else{
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
//        pageViewController.view.backgroundColor = UIColor.green
        contentView.addSubview(pageViewController.view)
        contentView.bringSubviewToFront(indicator)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        
        guard let startingViewController = detail(index: currentViewControllerIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    func detail(index: Int) -> DataViewController? {
        
        if index >= images.count || images.count == 0 {
            return nil
        }
        
        guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else {
            return nil
            
        }
        
        dataViewController.index = index
        dataViewController.image = images[index]
        
        return dataViewController
    }
    
    @IBAction func blurryButton_TouchUpInside(_ sender: Any) {
        
        if blurryButton.title(for: .normal) == "RETAKE"{
            //            self.images.removeAll(keepingCapacity: false)
            
            dismiss(animated: true, completion: nil)
        }
        
        blurryButton.setTitle("RETAKE", for: .normal)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Results_To_Weight_Segue" {
            let previewVC = segue.destination as! weightScaleViewController
            previewVC.user = user
        }
    }


    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
        
        indicator.isHidden = false
        
        nextButton.backgroundColor = helper.buttonDisEnabledColorToPurple()
        nextButton.isEnabled = false
        
        blurryButton.isEnabled = false
        blurryButton.backgroundColor = helper.buttonDisEnabledColorToPurple()
        
        if nextButton.title(for: .normal) == "UPLOAD"{
            
            let userFilePath = helper.getUserFilePath(userName: user.name!, userLastDigit: user.lastDigit!)
            
            let userIdentification = helper.getUserIdentification(userName: user.name!, userLastDigit: user.lastDigit!, babyBirth: user.babyBirth!)
            
            let getTime = helper.getCurrentDateAndTime()
            
            for index in 0..<images.count{
                
                let reference = "\(userFilePath)/\(userIdentification):::\(getTime)[\(index)].jpg"
                let uploadRef = Storage.storage().reference(withPath: reference)
                
                guard let imageData = images[index].jpegData(compressionQuality: 0.75) else {return}
                let uploadMetadata = StorageMetadata.init()
                uploadMetadata.contentType = "image/jpeg"
                
                let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    print("success ")
                    
                }
                
                taskReference.observe(.progress) { (snapshot) in
                    self.indicator.startAnimating()
                }
                
                taskReference.observe(.success) { (snapshot) in
                    print("Sucess")
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                    self.nextButton.backgroundColor = helper.buttonEnabledColorToPurple()
                    self.nextButton.isEnabled = true
                    self.nextButton.setTitle("NEXT", for: .normal)
                }
            }
            
        }else{

                performSegue(withIdentifier: "Results_To_Weight_Segue", sender: nil)

        }
        

    }
    
}

extension ImageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
         currentViewControllerIndex = currentIndex
        
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detail(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        if currentIndex == images .count {
            return nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        
        return detail(index: currentIndex)

    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    
    
}
