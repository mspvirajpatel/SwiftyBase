//
//  BaseLabel.swift
//  Pods
//
//  Created by MacMini-2 on 06/09/17.
//
//

import Foundation
import UIKit

/**
 This is list of label type which are supported in Baselabel class. we can add new here and need to handle it in BaseLabel
 */
public enum BaseLabelType : Int {
    
    case unknown = 0
    case large = 1
    case medium
    case small
    case primaryTitle
    case secondaryTitle
}

/**
 This is Base Class of UILable Control, Which is used in Whole Application. Useing this class we can globalize our label theme,font in whole application from signle place.
 */
open class BaseLabel: UILabel {
    
    // MARK: - Attributes -
    
    /// Its is type of the Label. Default is unknown
    public var type : BaseLabelType = .unknown
    
    /// This for set the Edge Insets of Text in label
    public var edgeInsets : UIEdgeInsets!
    
    
    // MARK: - Lifecycle -
    /**
     Initialize method of Baselabel
     
     - parameter labelType: its type of Label. Default is unknown.
     - parameter superView: its object of label's superView. Its can be null. When it's not null than label will added as subview in SuperView object
     */
    public init(labelType : BaseLabelType, superView: UIView?) {
        super.init(frame: CGRect.zero)
        
        type = labelType
        self.setCommonProperties()
        self.setlayout()
        
        if(superView != nil){
            superView?.addSubview(self)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
    }
    
    override open func layoutSubviews(){
        super.layoutSubviews()
    }
    
    override open var canBecomeFocused : Bool {
        return false
    }
    
    override open func draw(_ rect: CGRect) {
        super.drawText(in: rect)
        
        //super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets!))
    }
    
    override open var intrinsicContentSize : CGSize {
        return super.intrinsicContentSize
    }
    
    override open var text: String? {
        didSet {
            
        }
    }
    
    override open var isHidden: Bool {
        didSet {
            
        }
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit{
        edgeInsets = nil
    }
    
    // MARK: - Layout -
    /// This method is used to Set the Common proparty of ImageView as per Type like ContentMode,Border,tag,Backgroud color etc...
    func setCommonProperties(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
            
        case .large:
            
            self.font = UIFont(name: FontStyle.bold, size: SystemConstants.IS_IPAD ? 24.0 : 18.0)
            self.textColor = Color.labelText.value
            self.textAlignment = .left
            break
            
        case .medium:
            
            self.font = UIFont(name: FontStyle.medium, size: SystemConstants.IS_IPAD ? 20.0 : 15.0)
            self.textColor = Color.labelText.value
            self.textAlignment = .left
            break
            
        case .small:
            
            self.font = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 17.0 : 13.0)
            self.textColor = Color.labelText.value
            self.textAlignment = .center
            break
            
        case .primaryTitle:
            self.font = UIFont(name: FontStyle.medium, size: SystemConstants.IS_IPAD ? 22.0 : 16.0)
            self.textColor = Color.labelText.value
            
            break
            
        case .secondaryTitle:
            self.textColor =  Color.labelText.value //UIColor(rgbValue: ColorStyle.btnSecondText, alpha: 1.0)
            self.font = UIFont(name: FontStyle.medium, size: SystemConstants.IS_IPAD ? 44.0 : 40.0)
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset  = CGSize(width: 2.5, height: 2.5)
            self.layer.shadowOpacity = 0.5
            self.textAlignment = .center
            break
            
        default:
            break
        }
    }
    
    func setlayout(){
        
        
    }
    
    // MARK: - Public Interface -
    
    func setTextEdgeInsets(_ iEdgeInsets : UIEdgeInsets){
        edgeInsets = iEdgeInsets
    }
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}
