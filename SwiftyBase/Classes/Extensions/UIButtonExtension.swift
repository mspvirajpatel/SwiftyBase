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
    func applyCornerRadius(_ mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    //  Set background color for state
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    //  Set title text for all state
    func textForAllState(_ titleText : String) {
        self.setTitle(titleText, for: UIControl.State())
        self.setTitle(titleText, for: .selected)
        self.setTitle(titleText, for: .highlighted)
        self.setTitle(titleText, for: .disabled)
    }
    
    //  Set title text for only normal state
    func textForNormal(_ titleText : String) {
        self.setTitle(titleText, for: UIControl.State())
    }
    
    //  Set title text for only selected state
    func textForSelected(_ titleText : String) {
        self.setTitle(titleText, for: .selected)
    }
    
    //  Set title text for only highlight state
    func textForHighlighted(_ titleText : String) {
        self.setTitle(titleText, for: .highlighted)
    }
    
    //  Set image for all state
    func imageForAllState(_ image : UIImage) {
        self.setImage(image, for: UIControl.State())
        self.setImage(image, for: .selected)
        self.setImage(image, for: .highlighted)
        self.setImage(image, for: .disabled)
    }
    
    //  Set image for only normal state
    func imageForNormal(_ image : UIImage) {
        self.setImage(image, for: UIControl.State())
    }
    
    //  Set image for only selected state
    func imageForSelected(_ image : UIImage) {
        self.setImage(image, for: .selected)
    }
    
    //  Set image for only highlighted state
    func imageForHighlighted(_ image : UIImage) {
        self.setImage(image, for: .highlighted)
    }
    
    //  Set title color for all state
    func colorOfTitleLabelForAllState(_ color : UIColor) {
        self.setTitleColor(color, for: UIControl.State())
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .disabled)
    }
    
    //  Set title color for normal state
    func colorOfTitleLabelForNormal(_ color : UIColor) {
        self.setTitleColor(color, for: UIControl.State())
    }
    
    //  Set title color for selected state
    func colorOfTitleLabelForSelected(_ color : UIColor) {
        self.setTitleColor(color, for: .selected)
    }
    
    //  Set title color for highkighted state
    func colorForHighlighted(_ color : UIColor) {
        self.setTitleColor(color, for: .highlighted)
    }
    
    //  Set image behind the text in button
    func setImageBehindTextWithCenterAlignment(_ imageWidth : CGFloat, buttonWidth : CGFloat, space : CGFloat) {
        let titleLabelWidth:CGFloat = 50.0
        let buttonMiddlePoint = buttonWidth/2
        let fullLenght = titleLabelWidth + space + imageWidth
        
        let imageInset = buttonMiddlePoint + fullLenght/2 - imageWidth + space
        let buttonInset = buttonMiddlePoint - fullLenght/2 - imageWidth
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonInset, bottom: 0, right: 0)
    }
    
    //  Set image behind text in left alignment
    func setImageBehindTextWithLeftAlignment(_ imageWidth : CGFloat, buttonWidth : CGFloat) {
        let titleLabelWidth:CGFloat = 40.0
        let fullLenght = titleLabelWidth + 5 + imageWidth
        
        let imageInset = fullLenght - imageWidth + 5
        let buttonInset = CGFloat(-10.0)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonInset, bottom: 0, right: 0)
    }
    
    //  Set image behind text in right alignment
    func setImageOnRightAndTitleOnLeft(_ imageWidth : CGFloat, buttonWidth : CGFloat)  {
        let imageInset = CGFloat(buttonWidth - imageWidth - 10)
        
        let buttonInset = CGFloat(-10.0)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonInset, bottom: 0, right: 0)
    }
}

public extension UIButton {
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, title: String, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        titleLabel?.contentMode = .center
        setTitle(title, for: state)
    }
    
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: UIView.ContentMode, width spacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        adjust(title: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    
    // MARK: Private Methods
    
    private func adjust(title: NSAttributedString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = title.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func adjust(title: NSString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: UIView.ContentMode, withSpacing spacing: CGFloat) {
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position) {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 15, left: -5, bottom: 15, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.imageView?.contentMode = .scaleAspectFit
        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }
}

