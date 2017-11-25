//
//  PulseClass.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 2/7/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class PulseClass: UIView {

    private var radius: CGFloat!
    private var fill: UIColor!
    
    public func setup(r: CGFloat, f: UIColor, c: CGPoint, b: CGFloat) {
        radius = r
        fill = f
        
        frame.size = CGSize(width: radius*2, height: radius*2)
        center = c
        layer.cornerRadius = radius
        layer.borderColor = fill.cgColor
        layer.borderWidth = b
    }
    
    public func animate() {    
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 7, y: 7)
            self.alpha = 0
        }) { (Bool) in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

}
