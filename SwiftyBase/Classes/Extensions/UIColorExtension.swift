//
//  UiColor.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation
import UIKit

public extension UIColor {
    
    public convenience init(rgbValue: Int, alpha: CGFloat) {
        
        self.init(red:   CGFloat( (rgbValue & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (rgbValue & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (rgbValue & 0x0000FF) >> 0 ) / 255.0,
                  alpha: alpha)
        
    }
    
    public convenience init(rgbValue: Int) {
        self.init(rgbValue: rgbValue, alpha: 1.0)
        
    }
    
    public func lighterColorForColor() -> UIColor? {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            
            return UIColor(red: min(r + 0.2, 1.0),
                           green: min(g + 0.2, 1.0),
                           blue: min(b + 0.2, 1.0),
                           alpha: a)
            
        }
        
        return nil
        
    }
    
    public func darkerColorForColor() -> UIColor? {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            
            return UIColor(red: max(r - 0.15, 0.0),
                           green: max(g - 0.15, 0.0),
                           blue: max(b - 0.15, 0.0),
                           alpha: a)
            
        }
        
        return nil
        
    }
    
}
