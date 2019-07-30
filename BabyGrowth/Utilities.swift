//
//  Utilities.swift
//  GrowthTracker
//
//  Created by OCEO on 7/16/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import SystemConfiguration

class RotatedBar: UIView {

    private var insets: (dx: CGFloat, dy: CGFloat)?
    
    func setup(with subviews:[UIView], insets: (dx: CGFloat, dy: CGFloat)? = nil) {
        
        
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.transform = CGAffineTransform(rotationAngle: .pi/2)
        stackView.center = self.center
        self.addSubview(stackView)
        self.insets = insets
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        subviews.first?.frame = bounds.insetBy(dx: insets?.dx ?? 0, dy: insets?.dy ?? 0)
//        subviews.first?.center = CGPoint(x: frame.width/2, y: frame.height/2)
//    }

}

public class helper {
    
    class func getUserFilePath(userName: String, userLastDigit: String) -> String {
        
        return "\(userName)\(userLastDigit)"
        
    }
    
    class func getCurrentDateAndTime() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func getCurrentMonth() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func buttonEnabledColorToPurple() -> UIColor {
        return UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 1.0)
    }
    
    class func buttonDisEnabledColorToPurple() -> UIColor {
        return UIColor(red: 80/255.0, green: 24/255.0, blue: 133/255.0, alpha: 0.5)
    }
    
    class func getUserIdentification(userName: String, userLastDigit: String, babyBirth: String) -> String {
        
        return "\(userName)-\(userLastDigit)-\(babyBirth)"
        
    }

}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
}

