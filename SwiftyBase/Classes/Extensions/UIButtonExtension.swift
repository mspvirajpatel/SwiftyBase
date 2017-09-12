//
//  UIButtonExtension.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

// MARK: - Button Extension -

public extension UIButton {
    
    //  Apply corner radius
    public func applyCornerRadius(_ mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    //  Set background color for state
    public func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    //  Set title text for all state
    public func textForAllState(_ titleText : String) {
        self.setTitle(titleText, for: UIControlState())
        self.setTitle(titleText, for: .selected)
        self.setTitle(titleText, for: .highlighted)
        self.setTitle(titleText, for: .disabled)
    }
    
    //  Set title text for only normal state
    public func textForNormal(_ titleText : String) {
        self.setTitle(titleText, for: UIControlState())
    }
    
    //  Set title text for only selected state
    public func textForSelected(_ titleText : String) {
        self.setTitle(titleText, for: .selected)
    }
    
    //  Set title text for only highlight state
    public func textForHighlighted(_ titleText : String) {
        self.setTitle(titleText, for: .highlighted)
    }
    
    //  Set image for all state
    public func imageForAllState(_ image : UIImage) {
        self.setImage(image, for: UIControlState())
        self.setImage(image, for: .selected)
        self.setImage(image, for: .highlighted)
        self.setImage(image, for: .disabled)
    }
    
    //  Set image for only normal state
    public func imageForNormal(_ image : UIImage) {
        self.setImage(image, for: UIControlState())
    }
    
    //  Set image for only selected state
    public func imageForSelected(_ image : UIImage) {
        self.setImage(image, for: .selected)
    }
    
    //  Set image for only highlighted state
    public func imageForHighlighted(_ image : UIImage) {
        self.setImage(image, for: .highlighted)
    }
    
    //  Set title color for all state
    public func colorOfTitleLabelForAllState(_ color : UIColor) {
        self.setTitleColor(color, for: UIControlState())
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .disabled)
    }
    
    //  Set title color for normal state
    public func colorOfTitleLabelForNormal(_ color : UIColor) {
        self.setTitleColor(color, for: UIControlState())
    }
    
    //  Set title color for selected state
    public func colorOfTitleLabelForSelected(_ color : UIColor) {
        self.setTitleColor(color, for: .selected)
    }
    
    //  Set title color for highkighted state
    public func colorForHighlighted(_ color : UIColor) {
        self.setTitleColor(color, for: .highlighted)
    }
    
    //  Set image behind the text in button
    public func setImageBehindTextWithCenterAlignment(_ imageWidth : CGFloat, buttonWidth : CGFloat, space : CGFloat) {
        let titleLabelWidth:CGFloat = 50.0
        let buttonMiddlePoint = buttonWidth/2
        let fullLenght = titleLabelWidth + space + imageWidth
        
        let imageInset = buttonMiddlePoint + fullLenght/2 - imageWidth + space
        let buttonInset = buttonMiddlePoint - fullLenght/2 - imageWidth
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, buttonInset, 0, 0)
    }
    
    //  Set image behind text in left alignment
    public func setImageBehindTextWithLeftAlignment(_ imageWidth : CGFloat, buttonWidth : CGFloat) {
        let titleLabelWidth:CGFloat = 40.0
        let fullLenght = titleLabelWidth + 5 + imageWidth
        
        let imageInset = fullLenght - imageWidth + 5
        let buttonInset = CGFloat(-10.0)
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, buttonInset, 0, 0)
    }
    
    //  Set image behind text in right alignment
    public func setImageOnRightAndTitleOnLeft(_ imageWidth : CGFloat, buttonWidth : CGFloat)  {
        let imageInset = CGFloat(buttonWidth - imageWidth - 10)
        
        let buttonInset = CGFloat(-10.0)
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, buttonInset, 0, 0)
    }
}
