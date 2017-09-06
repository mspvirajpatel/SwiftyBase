//
//  ButtonDemoView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 05/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import SwiftyBase

class BaseControlsDemoView: BaseView {

    // MARK: - Attributes -
    
    var btnPrimary : BaseButton!
    
    var btnSecondary : BaseButton!
    
    let roundMenuButton : BaseRoundMenu! = BaseRoundMenu(withPosition: .bottomRight, size: 50.0, numberOfPetals: 4, images:[])
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
        btnPrimary = BaseButton.init(ibuttonType: .primary, iSuperView: self)
        btnPrimary.layer.setValue("btnPrimary", forKey: ControlConstant.name)
        btnPrimary.setTitle("Primary Button", for: UIControlState())
        btnPrimary.setButtonTouchUpInsideEvent { (sender, object) in
           
            //Create Custome Body Paramenters
            let dicParameter : NSMutableDictionary! = NSMutableDictionary()
            dicParameter .setValue("1", forKey: "status")
            
            //For set Body Paramenters
            AppImageUploadManager.shared.dicBodyParameter = dicParameter
            
            //For set sub Domail address of Image Upload URl
            AppImageUploadManager.shared.setImageUrl = "https://imgbb.com/json"
          
            //Add UIImages array into this funation
            _ = AppImageUploadManager.shared.addImageForUpload(arrImage: [UIImage.init(named: "user")!])
        }
        
        btnSecondary = BaseButton.init(ibuttonType: .secondary, iSuperView: self)
        btnSecondary.layer.setValue("btnSecondary", forKey: ControlConstant.name)
        btnSecondary.setTitle("Secondary Button", for: UIControlState())
        
        let baseEmailTextField : BaseTextField = BaseTextField.init(iSuperView: self, TextFieldType: .primary)
        baseEmailTextField.layer.setValue("baseEmailTextField", forKey: ControlConstant.name)
      
        let baseTextField : BaseTextField = BaseTextField.init(iSuperView: self, TextFieldType: .showPassword)
        baseTextField.layer.setValue("baseTextField", forKey: ControlConstant.name)
        
//        // If you Change icons of Show & Hide
//        baseTextField.setShowPasswordImage = UIImage.init(named: "ShowPassword")!
//        baseTextField.setHidePasswordImage = UIImage.init(named: "HidePassword")!

        self.addSubview(roundMenuButton)
        
        roundMenuButton.buttonActionDidSelected = { (indexSelected) in
            print("Selected Index: \(indexSelected)")
        }
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnPrimary]-20-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[btnPrimary]-5-[btnSecondary]-5-[baseEmailTextField]-5-[baseTextField]", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        self.layoutSubviews()
        
    }
    
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -

}
