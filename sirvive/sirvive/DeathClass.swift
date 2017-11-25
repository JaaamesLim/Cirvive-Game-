//
//  DeathClass.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 15/9/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class DeathClass: UIView {
    
    private var radius: CGFloat = 0
    private var fill = UIColor()
    
    public func setup(r: CGFloat, c: CGPoint, f: UIColor, b: CGColor) {
        radius = r
        fill = f
        
        frame.size  = CGSize(width: radius*2, height: radius*2)
        center = c
        backgroundColor = fill
        layer.cornerRadius = radius
        layer.borderWidth = r/10
        layer.borderColor = b
    }

}
