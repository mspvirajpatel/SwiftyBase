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

class BaseControlsDemoView: BaseView,BaseRadioButtonDelegate{

    // MARK: - Attributes -
    
    var scrollView : BaseScrollView!

    var containerView:UIView!
    
    var baseSegment : BaseSegment!
    
    var btnPrimary : BaseButton!
    
    var btnSecondary : BaseButton!
  
    var male : BaseButton!
    
    var female : BaseButton!
    
    //For radiobutton
    var radioButtonController: BaseRadioButton?
    
    let roundMenuButton : BaseRoundMenu! = BaseRoundMenu(withPosition: .bottomRight, size: 50.0, numberOfPetals: 4, images:["user","user","user","user"])
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        self.addNotification()
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
      
        /*  scrollView Allocation   */
        scrollView = BaseScrollView.init(scrollType: .both, superView: self)
        scrollView.layer.setValue("scrollView", forKey: ControlConstant.name)
        
        containerView  = scrollView.container
        containerView.layer.setValue("containerView", forKey: ControlConstant.name)
        
        baseSegment = BaseSegment.init(titleArray: ["Sign In", "Sign Up", "Forgot"], iSuperView: containerView)
        baseSegment.layer.setValue("baseSegment", forKey: ControlConstant.name)
        baseSegment.setSegmentTabbedEvent { (selectedIndex) in
            print("SelectedIndex Segment:\(selectedIndex)")
        }
        
        let baseEmailTextField : BaseTextField = BaseTextField.init(iSuperView: containerView, TextFieldType: .primary)
        baseEmailTextField.layer.setValue("baseEmailTextField", forKey: ControlConstant.name)
        baseEmailTextField.placeholder = "Enter EmailId"
        
        let baseTextField : BaseTextField = BaseTextField.init(iSuperView: containerView, TextFieldType: .showPassword)
        baseTextField.layer.setValue("baseTextField", forKey: ControlConstant.name)
        baseTextField.placeholder = "Enter Password"
        
        
        let baseTextView : BaseTextView = BaseTextView.init(iSuperView: containerView)
        baseTextView.layer.setValue("baseTextView", forKey: ControlConstant.name)
        baseTextView.placeholder = "Enter Your Details"
        
        btnPrimary = BaseButton.init(ibuttonType: .primary, iSuperView: containerView)
        btnPrimary.layer.setValue("btnPrimary", forKey: ControlConstant.name)
        btnPrimary.setTitle("Login", for: UIControlState())
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
        
        
        btnSecondary = BaseButton.init(ibuttonType: .secondary, iSuperView: containerView)
        btnSecondary.layer.setValue("btnSecondary", forKey: ControlConstant.name)
        btnSecondary.setTitle("SignUp", for: UIControlState())
        btnSecondary.setButtonTouchUpInsideEvent { (sender, object) in
            BasePopOverMenu.showForSender(sender: (sender as!    UIButton),
                                              with: ["Facebook","Google","Outlook"],
                                              done: { (selectedIndex) -> () in
                        print("SelectedIndex :\(selectedIndex)")
            }) {
                
            }
        }
        
        
        self.addSubview(roundMenuButton)
        roundMenuButton.badge(text: nil)

        roundMenuButton.setTitle("@", for: UIControlState())
        roundMenuButton.buttonActionDidSelected = { (indexSelected) in
            
            switch indexSelected {
            case 0 :
                do{
                    try AppPreferencesExplorer.open(.about)
                }
                catch let error{
                    print(error.localizedDescription)
                }
                self.roundMenuButton.closeButtons()
                break
            case 1 :
                do{
                    try AppPreferencesExplorer.open(.wifi)
                }
                catch let error{
                    print(error.localizedDescription)
                }
                self.roundMenuButton.closeButtons()

                break
            case 2 :
                do{
                    try AppPreferencesExplorer.open(.network)
                }
                catch let error{
                    print(error.localizedDescription)
                }
                self.roundMenuButton.closeButtons()

            default:
                break
            }
            
           
            
            print("Selected Index: \(indexSelected)")
        }
        
        male = BaseButton(ibuttonType:.radio,iSuperView: containerView)
        male.setTitle("Male", for: UIControlState())
        male.tag = 1
        male.layer.setValue("male", forKey: ControlConstant.name)
        radioButtonController?.addButton(male)
        
        female = BaseButton(ibuttonType:.radio,iSuperView: containerView)
        female.setTitle("Female", for: UIControlState())
        female.tag = 2
        female.layer.setValue("female", forKey: ControlConstant.name)
        radioButtonController?.addButton(female)
        
        radioButtonController = BaseRadioButton(buttons: male,female)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController?.pressed(male)
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        baseLayout.expandView(scrollView, insideView: self, betweenSpace: 10)
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        let widthTextField = UIScreen.main.bounds.width - 60
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding,
                              "widthTextField" : widthTextField
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20@1000-[baseEmailTextField(widthTextField)]-20@1000-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[baseEmailTextField]-controlTopBottomPadding-[baseTextField]-controlTopBottomPadding-[baseTextView(120)]-controlTopBottomPadding-[btnPrimary]-controlTopBottomPadding-[btnSecondary]-controlTopBottomPadding-[baseSegment]-controlTopBottomPadding-[male][female]-60-|", options:[.alignAllLeading , .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints(baseLayout.control_V)
        self.layoutSubviews()
        
    }

    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived), name: NSNotification.Name(rawValue: "DownloadUpdates"), object: nil)
    }
    
    @objc func notificationReceived()
    {
        if DownloadManager.shared.vdDownloader.downloadingArray.count == 0{
            roundMenuButton.badge(text: nil)
        }
        else{
            roundMenuButton.badge(text: String(DownloadManager.shared.vdDownloader.downloadingArray.count))
        }
    }

    // MARK: - Public Interface -
    func didSelectButton(_ aButton: BaseButton?) {
        let currentButton = radioButtonController!.selectedButton()!
        print("\(currentButton.tag)")
        
        if currentButton.tag == 1 {
            self.makeToast(message: "Click Male")
        }
        
        if currentButton.tag == 2 {
            self.makeToast(message: "Click Female")
        }
    }
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -

}
