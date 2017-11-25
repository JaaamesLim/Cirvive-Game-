//
//  ButttonClass.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 6/7/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class ButttonClass: UIButton {
    
    public func setup(_ text: String, _ f: CGRect, _ padding: CGFloat, n: CGFloat, font: String, h: CGFloat) {
        frame = CGRect(x: padding, y: f.height/8 * n, width: f.width - padding*2, height: h)
        setTitle(text, for: .normal)
        contentHorizontalAlignment = .left
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: font, size: 30)
    }

}
