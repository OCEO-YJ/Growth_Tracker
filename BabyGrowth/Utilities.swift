//
//  Utilities.swift
//  GrowthTracker
//
//  Created by OCEO on 7/16/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit

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
