//
//  EnemyClass.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 3/7/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class EnemyClass: UILabel {

    private var face: Int = 0
    private var faces = [["•_•", "•o•", "•O•"], // normal
                         ["-_-", "-o-", "-O-"], // still
                         ["^_^", "^o^", "^O^"], // random
                         ["`_`", "`o`", "`O`"], // dash
                         ["'_'", "'o'", "'O'"]]
    
    public var type: String = ""
    public var pathing: String = ""
    public var target: CGPoint!
    public var damage: Int = 0
    public var lives: Int = 0
    public var maxLives: Int = 0
    public var hit = false
    private var radius: CGFloat!
    public var speed: CGFloat!
    private var origin: CGPoint!
    private var fill: UIColor!
    
    private let barrier = UIView()

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: radius/4, bottom: 0, right: radius/4)))
    }
    
    public func setup(_ name: String, _ path: String, r: CGFloat, f: UIColor, o: CGPoint, d: Int, s: CGFloat, l: Int, size: CGFloat, _ fa: Int) {
        type = name
        pathing = path
        damage = d
        lives = l
        radius = r
        speed = s
        origin = o
        fill = f
        face = fa
        
        switch type {
        case "splitter":
            frame.size = CGSize(width: radius*4, height: radius*4)
            center = origin
            backgroundColor = .clear
            
            let cir1 = EnemyClass()
            cir1.setup("fast", "normal", r: radius, f: fill, o: CGPoint(x: radius, y: radius), d: 0, s: speed, l: lives, size: size, 0)
            addSubview(cir1)
            
            let cir2 = EnemyClass()
            cir2.setup("fast", "normal", r: radius, f: fill, o: CGPoint(x: radius*3, y: radius), d: 0, s: speed, l: lives, size: size, 0)
            addSubview(cir2)
            
            let cir3 = EnemyClass()
            cir3.setup("fast", "normal", r: radius, f: fill, o: CGPoint(x: radius, y: radius*3), d: 0, s: speed, l: lives, size: size, 0)
            addSubview(cir3)
            
            let cir4 = EnemyClass()
            cir4.setup("fast", "normal", r: radius, f: fill, o: CGPoint(x: radius*3, y: radius*3), d: 0, s: speed, l: lives, size: size, 0)
            addSubview(cir4)
        default:
            frame.size = CGSize(width: radius*2, height: radius*2)
            center = origin
            backgroundColor = fill
            layer.cornerRadius = radius
            clipsToBounds = true
            font = UIFont(name: "Helicopta", size: size)
            minimumScaleFactor = 0.1
            textAlignment = .center
            text = faces[face][Int(arc4random_uniform(UInt32(faces[face].count)))]
            
            if lives > 1 && type != "boss" {
                barrier.frame.size = CGSize(width: radius*4, height: radius*4)
                barrier.center = CGPoint(x: radius, y: radius)
                barrier.layer.cornerRadius = radius*2
                barrier.layer.borderWidth = 2
                barrier.layer.borderColor = fill.cgColor
                addSubview(barrier)
            }
        }
    }
    
    public func chase(point: CGPoint) {
        let base: CGFloat = point.x - center.x
        let height: CGFloat = point.y - center.y
        let hyp: CGFloat = sqrt(sqr(base) + sqr(height))
        
        center.x += ratio(speed, hyp, base)
        center.y += ratio(speed, hyp, height)
        
        if arc4random_uniform(1000) < 10 {
            text = faces[face][Int(arc4random_uniform(UInt32(faces[face].count)))]
            let x = arc4random_uniform(3)
            if  x == 0 { textAlignment = .left }
            else if x == 1 { textAlignment = .center }
            else if x == 2 { textAlignment = .right }
        }
    }
    
    public func checkCollision(point: CGPoint, radius: CGFloat) -> Bool {
        let base: CGFloat = point.x - center.x
        let height: CGFloat = point.y - center.y
        let hyp: CGFloat = sqrt(sqr(base) + sqr(height))
        
        if hyp < radius {
            return true
        }
        
        return false
    }
    
    public func destroy() {
        switch lives {
        case 0:
            text = "x x"
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }) { (Bool) in
                self.removeFromSuperview()
            }
        case 1:
            UIView.animate(withDuration: 0.25, animations: {
                self.barrier.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.barrier.alpha = 0
            }, completion: { (Bool) in
                self.barrier.removeFromSuperview()
            })
        default:
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = CGFloat(self.lives)/CGFloat(self.maxLives)
            })
        }
    }
    
    public func getRadius() -> CGFloat { return radius }
    
    private func sqr(_ x: CGFloat) -> CGFloat { return x*x }
    private func ratio(_ speed: CGFloat, _ hyp: CGFloat, _ x: CGFloat) -> CGFloat { return speed/hyp * x }
    
}
