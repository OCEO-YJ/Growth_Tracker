////
////  ResultsViewController.swift
////  GrowthTracker
////
////  Created by OCEO on 7/19/19.
////  Copyright © 2019 OCEO. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//
//
//class ResultsViewController: UIViewController, UIScrollViewDelegate {
//
//    @IBOutlet weak var blurryButton: UIButton!
//
//    @IBOutlet weak var nextButton: UIButton!
//    @IBOutlet weak var pageControl: UIPageControl!
//    @IBOutlet weak var scrollView: UIScrollView!
//    var images =  [UIImage]()
//    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//    var userIdentificationArray: [String] = []
//    var successCount = 0
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setUIToView()
//
//        pageControl.numberOfPages = images.count
//
//        for index in 0..<images.count {
//        frame.origin.x = scrollView.frame.size.width * CGFloat(index)
//
//            frame.size = scrollView.frame.size
//
//            let imgView = UIImageView(frame: frame)
//            imgView.image = self.images[index]
//            self.scrollView.addSubview(imgView)
//        }
//
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count) , height: scrollView.frame.size.height)
//
//        scrollView.delegate = self
//
//
//        // Do any additional setup after loading the view.
//
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
//        pageControl.currentPage = Int(pageNumber)
//
//    }
//
//    func setUIToView() {
//
//        //        let backgroundColor = UIColor(red: 255.0/255.0, green: 90/255.0, blue: 101/255.0, alpha: 1.0)
//        let backgroundColor = UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
//
//        /* set the button (Login Button) to have a round border with the pink color.
//         * Also, set its text color to the white color */
//        nextButton.layer.cornerRadius = 10
//        nextButton.backgroundColor = backgroundColor
//        nextButton.setTitleColor(UIColor.white, for: .normal)
//
//        blurryButton.layer.cornerRadius = 10
//        blurryButton.backgroundColor = backgroundColor
//        blurryButton.setTitleColor(UIColor.white, for: .normal)
//
//    }
//
//
//
//    @IBAction func retakeButton_TouchUpInside(_ sender: Any) {
//
//        if blurryButton.title(for: .normal) == "RETAKE"{
////            self.images.removeAll(keepingCapacity: false)
//
//            dismiss(animated: true, completion: nil)
//
//
//        }
//
//        blurryButton.setTitle("RETAKE", for: .normal)
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "Results_To_Weight_Segue" {
//            let previewVC = segue.destination as! weightScaleViewController
//            previewVC.userIdentificationArray = userIdentificationArray
//        }
//    }
//
//    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
//
//
//    }
//
//    func getUserFilePath(userName: String, userLastDigit: String) -> String {
//
//        return "\(userName)\(userLastDigit)"
//
//    }
//
//    func getUserIdentification(userName: String, userLastDigit: String, babyBirth: String) -> String {
//
//        return "\(userName)-\(userLastDigit)-\(babyBirth)"
//
//    }
//
//    func getCurrentDateAndTime() -> String {
//
//        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = Date()
//        let dateString = dateFormatter.string(from: date)
//        return dateString
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
