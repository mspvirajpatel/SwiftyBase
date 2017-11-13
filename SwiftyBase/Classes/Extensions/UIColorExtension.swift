//
//  UiColor.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

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
   
    //**************************************/
    // Functions
    //**************************************/
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage)) ?? .white
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage)) ?? .black
    }
    
    /// Performs an equivalent to the .map({}) function, adjusting the current r, g, b value by the percentage
    ///
    /// - Parameter percentage: CGFloat
    /// - Returns: UIColor or nil if there was an error
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else{
            return nil
        }
    }
    
}
