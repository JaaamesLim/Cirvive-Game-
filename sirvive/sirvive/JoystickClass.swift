//
//  JoystickClass.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 4/7/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class JoystickClass: UIView {

    private var radius: CGFloat!
    private var fill: UIColor!
    private var position: CGPoint!
    private var pointer = UIView()
    
    public func setup(r: CGFloat, f: UIColor) {
        radius = r
        fill = f
        
        frame.size = CGSize(width: radius*2, height: radius*2)
        backgroundColor = .clear
        alpha = 0.25
        layer.cornerRadius = radius
        layer.borderColor = fill.cgColor
        layer.borderWidth = 1
        
        pointer.frame.size = CGSize(width: radius/2, height: radius/2)
        pointer.backgroundColor = fill
        pointer.layer.cornerRadius = radius/4
        addSubview(pointer)
    }
    
    public func locate(_ c: CGPoint) {
        position = c
        center = position
    }
    
    public func movePlayer(_ c: CGPoint, _ j: CGPoint, _ p: CGPoint, viewFrame: CGRect, r: CGFloat, speed: CGFloat) -> CGPoint {
        let base: CGFloat = j.x - c.x
        let height: CGFloat = j.y - c.y
        
        let hyp: CGFloat = sqrt(sqr(base) + sqr(height))
        
        let x = ratio(speed, hyp, base)
        let y = ratio(speed, hyp, height)
        
        let pointerX = ratio(radius, hyp, base)
        let pointerY = ratio(radius, hyp, height)
        
        pointer.center = CGPoint(x: radius + pointerX, y: radius + pointerY)
        
        var finalX: CGFloat!
        var finalY: CGFloat!
        
        finalX = p.x + x
        finalY = p.y + y
        
        if finalX > viewFrame.width - r { finalX = viewFrame.width - r - 1 }
        if finalX < r { finalX = r + 1 }
        if finalY > viewFrame.height - r { finalY = viewFrame.height - r - 1 }
        if finalY < r { finalY = r + 1 }
        
        return CGPoint(x: finalX, y: finalY)
    }
    
    private func sqr(_ x: CGFloat) -> CGFloat { return x*x }
    private func ratio(_ speed: CGFloat, _ hyp: CGFloat, _ x: CGFloat) -> CGFloat { return (speed/hyp) * x }
}
