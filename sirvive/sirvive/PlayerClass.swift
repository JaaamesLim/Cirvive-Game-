//
//  PlayerClass.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 2/7/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class PlayerClass: UIView {

    public var healthPoints: Int = 0
    
    private var radius: CGFloat!
    private var fill: UIColor!
    private var ready: Bool = false
    
    private var pulsePrompt = PulseClass()
    private let pulse = PulseClass()
    public var pulsing: Bool = false
    public var pulseTimer = Timer()
    
    public func setup(r: CGFloat, f: UIColor, origin: CGPoint, h: Int) {
        healthPoints = h
        radius = r
        fill = f
        
        frame.size = CGSize(width: radius*2, height: radius*2)
        center = origin
        backgroundColor = fill
        layer.cornerRadius = radius
        
        pulsePrompt.setup(r: radius/2 * 3, f: fill, c: CGPoint(x: radius, y: radius), b: 2.5)
        pulsePrompt.alpha = 0
        pulsePrompt.isHidden = true
        addSubview(pulsePrompt)
        
        pulse.setup(r: radius, f: fill, c: CGPoint(x: radius, y: radius), b: 0.5)
        pulse.alpha = 0
        addSubview(pulse)
    }
    
    public func setReady() {
        pulse.alpha = 1
        ready = true
        prompting()
        pulsePrompt.isHidden = false
        pulseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.prompting), userInfo: nil, repeats: true)
    }
    
    @objc private func prompting() {
        if ready == true {
            for i in 0...2 {
                let prompt = PulseClass()
                prompt.setup(r: radius, f: fill, c: CGPoint(x: radius, y: radius), b: radius/20)
                addSubview(prompt)
                UIView.animate(withDuration: 0.25, delay: TimeInterval(i + 1)/10, options: [], animations: {
                    prompt.transform = CGAffineTransform(scaleX: 1.25 * 1.5, y: 1.25 * 1.5)
                    prompt.alpha = 0
                }, completion: { (Bool) in
                    prompt.removeFromSuperview()
                })
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.pulsePrompt.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                self.pulsePrompt.alpha = 0.5
            }) { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.pulsePrompt.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.pulsePrompt.alpha = 0
                }) { (Bool) in
                    
                }
            }
        } else {
            pulseTimer.invalidate()
        }
    }
    
    public func notRady() {
        ready = false
        pulseTimer.invalidate()
        pulsePrompt.alpha = 0
        pulsePrompt.isHidden = true
    }
    
    public func isReady() -> Bool { return ready }
    
    public func activatePower() {
        pulseTimer.invalidate()
        pulsePrompt.alpha = 0
        pulsePrompt.isHidden = true
        pulse.animate()
        for i in 0...2 {
            let prompt = PulseClass()
            prompt.setup(r: radius, f: fill, c: CGPoint(x: radius, y: radius), b: 1 + CGFloat(i)/5)
            addSubview(prompt)
            UIView.animate(withDuration: 0.25, delay: TimeInterval(i)/10, options: [], animations: {
                prompt.transform = CGAffineTransform(scaleX: 7, y: 7)
                prompt.alpha = 0
            }, completion: { (Bool) in
                prompt.removeFromSuperview()
            })
        }
        ready = false
    }

}
