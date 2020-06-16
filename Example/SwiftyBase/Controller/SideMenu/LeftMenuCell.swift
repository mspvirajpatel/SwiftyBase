//
//  LeftMenuCell.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 06/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBase

class LeftMenuCell : UITableViewCell {
    
    // MARK: - Attributes -
    
    var baseLayout : AppBaseLayout!
    var innerView : UIView!
    var imgIcon : BaseImageView!
    var lblMenuText : BaseLabel!
    
    
    // MARK: - Lifecycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    deinit {
        print("Leftmenu cell deinit")
        
        if baseLayout != nil
        {
            baseLayout = nil
        }
        
        if innerView != nil && innerView.superview != nil{
            innerView.removeFromSuperview()
            innerView = nil
        }
        
        if imgIcon != nil && imgIcon.superview != nil{
            imgIcon.removeFromSuperview()
            imgIcon = nil
        }
        
        if lblMenuText != nil && lblMenuText.superview != nil{
            lblMenuText.removeFromSuperview()
            lblMenuText = nil
        }
        
    }
    
    // MARK: - Layout -
    
    func loadViewControls(){
        
        baseLayout = AppBaseLayout()
        
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = false
        
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
        
        innerView = UIView(frame: CGRect.zero)
        innerView.backgroundColor = UIColor.clear
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(innerView)
        
        imgIcon = BaseImageView(type:.unknown, superView: innerView)
        imgIcon.contentMode = .scaleAspectFit
        imgIcon.tintColor = AppColor.activityText.value
        
        //imgIcon.backgroundColor = UIColor.red
        
        lblMenuText = BaseLabel(labelType: .large, superView: innerView)
        lblMenuText.textColor = AppColor.activityText.value
        
        lblMenuText.numberOfLines = 1
        
    }
    
    func setViewlayout(){
        
        baseLayout.viewDictionary = ["innerView" : innerView,
                                     "imgIcon" : imgIcon,
                                     "lblMenuText" : lblMenuText]
        
        let KleftCellImgWidthheight : CGFloat = 25
        let KleftcellTopbotoompading : CGFloat = 30
        let kleftcellleftrightpadding : CGFloat = 15
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[innerView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views: baseLayout.viewDictionary)
        self.contentView.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[innerView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views: baseLayout.viewDictionary)
        self.contentView.addConstraints(baseLayout.control_V)
        
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant:KleftCellImgWidthheight))
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant:KleftCellImgWidthheight))
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1.0, constant:KleftcellTopbotoompading))
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .centerY, relatedBy: .equal, toItem: innerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        innerView.addConstraint(NSLayoutConstraint(item: lblMenuText, attribute: .leading, relatedBy: .equal, toItem: imgIcon, attribute: .trailing, multiplier: 1.0, constant:kleftcellleftrightpadding))
        
        innerView.addConstraint(NSLayoutConstraint(item: lblMenuText, attribute: .centerY, relatedBy: .equal, toItem: imgIcon, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        self.layoutIfNeeded()
        
    }
    
    
    //MARK: - Internal Helpers -
}
