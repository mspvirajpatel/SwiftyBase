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
    
    public func convert(to color: UIColor, multiplier _multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(_multiplier, 0), 1)
        
        let components = cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []
        
        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }
        
        let results = (0...3).map { (toComponents[$0] - components[$0]) * abs(multiplier) + components[$0] }
        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
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
    
    func isDarker(than color: UIColor) -> Bool {
        return self.luminance < color.luminance
    }
    
    func isLighter(than color: UIColor) -> Bool {
        return !self.isDarker(than: color)
    }
    
    //**************************************/
    // Extended Variables
    //**************************************/
    
    var RGBA: [CGFloat] {
        var RGBA: [CGFloat] = [0,0,0,0]
        self.getRed(&RGBA[0], green: &RGBA[1], blue: &RGBA[2], alpha: &RGBA[3])
        return RGBA
    }
    
    var luminance: CGFloat {
        
        let RGBA = self.RGBA
        
        func lumHelper(c: CGFloat) -> CGFloat {
            return (c < 0.03928) ? (c/12.92): pow((c+0.055)/1.055, 2.4)
        }
        
        return 0.2126 * lumHelper(c: RGBA[0]) + 0.7152 * lumHelper(c: RGBA[1]) + 0.0722 * lumHelper(c: RGBA[2])
    }
    
    var isDark: Bool {
        return self.luminance < 0.5
    }
    
    var isLight: Bool {
        return !self.isDark
    }
    
    var isBlackOrWhite: Bool {
        let RGBA = self.RGBA
        let isBlack = RGBA[0] < 0.09 && RGBA[1] < 0.09 && RGBA[2] < 0.09
        let isWhite = RGBA[0] > 0.91 && RGBA[1] > 0.91 && RGBA[2] > 0.91
        
        return isBlack || isWhite
    }
    
}
