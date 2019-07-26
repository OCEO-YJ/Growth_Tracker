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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private var insets: (dx: CGFloat, dy: CGFloat)?
    
    func setup(with subviews:[UIView], insets: (dx: CGFloat, dy: CGFloat)? = nil) {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.transform = CGAffineTransform(rotationAngle: .pi/2)
        self.addSubview(stackView)
        self.insets = insets
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.first?.frame = bounds.insetBy(dx: insets?.dx ?? 0, dy: insets?.dy ?? 0)
        subviews.first?.center = CGPoint(x: frame.width/2, y: frame.height/2)
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
