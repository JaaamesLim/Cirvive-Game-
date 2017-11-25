//
//  ColorExtension.swift
//  InDot
//
//  Created by JAMES GOT GAME 07 on 29/6/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//
// http://flatcolors.net/palette/872-modern-vintage#

import UIKit

extension UIColor {
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
