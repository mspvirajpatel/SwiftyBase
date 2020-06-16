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

class BaseControlsDemoView: BaseView,BaseRadioButtonDelegate,PGTransactionDelegate{

    // MARK: - Attributes -
    
    var scrollView : BaseScrollView!

    var containerView:UIView!
    
    var baseSegment : BaseSegment!
    
    var btnPrimary : BaseButton!
    
    var btnSecondary : BaseButton!
    var btnPaytmBuy : BaseButton!
    
    var male : BaseButton!
    
    var female : BaseButton!
    
    var editField: PartiallyEditField!
    
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
        
       
        editField = PartiallyEditField.init(frame: CGRect.init(x: 20, y: 20, width: 320, height: 40))
        containerView.addSubview(editField)
        editField.translatesAutoresizingMaskIntoConstraints = false
         editField.layer.setValue("editField", forKey: ControlConstant.name)
        editField.setup(withPreText: "@gmail.com", color: UIColor.red)
        editField.preTextSide = .kRight
        
        let baseTextView : BaseTextView = BaseTextView.init(iSuperView: containerView)
        baseTextView.layer.setValue("baseTextView", forKey: ControlConstant.name)
        baseTextView.placeholder = "Enter Your Details"
        
        btnPrimary = BaseButton.init(ibuttonType: .primary, iSuperView: containerView)
        btnPrimary.layer.setValue("btnPrimary", forKey: ControlConstant.name)
        btnPrimary.setTitle("Login", for: UIControl.State())
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
        btnSecondary.setTitle("SignUp", for: UIControl.State())
        btnSecondary.setButtonTouchUpInsideEvent { (sender, object) in
            BasePopOverMenu.showForSender(sender: (sender as!    UIButton),
                                              with: ["Facebook","Google","Outlook"],
                                              done: { (selectedIndex) -> () in
                                                
                                                let pick:BaseDatePicker = BaseDatePicker()
                                                pick.titleString = "Select Date"
                                                pick.buttonColor = AppColor.buttonPrimaryBG.value
                                                pick.pickerMode  = .date
                                                pick.block = { (date) in
                                                    print(date ?? "No Date")
                                                }
                                                pick.showPicker(viewController: self.getViewControllerFromSubView()!)
                                                
                        print("SelectedIndex :\(selectedIndex)")
                                                
            }) {
                
            }
        }
        
        btnPaytmBuy = BaseButton.init(ibuttonType: .secondary, iSuperView: containerView)
        btnPaytmBuy.layer.setValue("btnPaytmBuy", forKey: ControlConstant.name)
        btnPaytmBuy.setTitle("Paytm Buy Demo", for: UIControl.State())
        btnPaytmBuy.setButtonTouchUpInsideEvent { (sender, object) in
            
            
//            //Step 1: Create a default merchant config object
//            
//            let mc: PGMerchantConfiguration = PGMerchantConfiguration.default()
//            
//            //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
//            
//            mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
//            mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
//            
//            //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
//            var orderDict: [AnyHashable: Any] = NSMutableDictionary() as! [AnyHashable: Any]
//            
//            orderDict["MID"] = "WorldP64425807474247"
//            //Merchant configuration in the order object
//            orderDict["CHANNEL_ID"] = "WAP"
//            orderDict["INDUSTRY_TYPE_ID"] = "Retail"
//            orderDict["WEBSITE"] = "worldpressplg"
//            //Order configuration in the order object
//            orderDict["TXN_AMOUNT"] = "5"
//            orderDict["ORDER_ID"] = AppUtility.generateOrderIDWithPrefix("swiftybase")
//            orderDict["REQUEST_TYPE"] = "DEFAULT"
//            orderDict["CUST_ID"] = "1234567890"
//            
//            let order: PGOrder = PGOrder(params: orderDict)
//            
//            //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
//            //PGTransactionViewController and set the serverType to eServerTypeProduction
//            PGServerEnvironment.selectServerDialog(self, completionHandler: {(type: ServerType) -> Void in
//                
//                let txnController = PGTransactionViewController.init(transactionFor: order)
//                
//                if type != eServerTypeNone {
//                    txnController?.serverType = type
//                    txnController?.merchant = mc
//                    txnController?.delegate = self
//                    self.showController(txnController!)
//                }
//            })

        }

        
        self.addSubview(roundMenuButton)
        roundMenuButton.badge(text: nil)

        roundMenuButton.setTitle("@", for: UIControl.State())
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
        male.setTitle("Male", for: UIControl.State())
        male.tag = 1
        male.layer.setValue("male", forKey: ControlConstant.name)
        radioButtonController?.addButton(male)
        
        female = BaseButton(ibuttonType:.radio,iSuperView: containerView)
        female.setTitle("Female", for: UIControl.State())
        female.tag = 2
        female.layer.setValue("female", forKey: ControlConstant.name)
        radioButtonController?.addButton(female)
        
        radioButtonController = BaseRadioButton(buttons: male,female)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController?.pressed(male)
        
        
    }
    
    func parse (apiKey: String, latitude: Double, longtitude: Double){
        
        
        let jsonUrlString = "https://api.darksky.net/forecast/\(apiKey)/\(latitude),\(longtitude)"
        
        guard let url = URL(string: jsonUrlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            guard data != nil else {
                return
            }
           
            
            }.resume()
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        baseLayout.expandView(scrollView, insideView: self, betweenSpace: 10)
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as? [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        let widthTextField = UIScreen.main.bounds.width - 60
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding,
                              "widthTextField" : widthTextField
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20@1000-[baseEmailTextField(widthTextField)]-20@1000-|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[baseEmailTextField]-controlTopBottomPadding-[baseTextField]-controlTopBottomPadding-[baseTextView(120)]-controlTopBottomPadding-[btnPrimary]-controlTopBottomPadding-[btnSecondary]-controlTopBottomPadding-[btnPaytmBuy]-controlTopBottomPadding-[baseSegment]-controlTopBottomPadding-[male][female]-60-[editField(40)]-|", options:[.alignAllLeading , .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
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
    func showController(_ controller: PGTransactionViewController) {
        
        if self.getViewControllerFromSubView()!.navigationController != nil {
            self.getViewControllerFromSubView()!.navigationController!.pushViewController(controller, animated: true)
        }
        else {
            self.getViewControllerFromSubView()!.present(controller, animated: true, completion: {() -> Void in
            })
        }
    }
    
    func removeController(_ controller: PGTransactionViewController) {
        if self.getViewControllerFromSubView()!.navigationController != nil {
            self.getViewControllerFromSubView()!.navigationController!.popViewController(animated: true)
        }
        else {
            controller.dismiss(animated: true, completion: {() -> Void in
            })
        }
    }
    
    // MARK: Delegate methods of Payment SDK.
    func didSucceedTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        
        // After Successful Payment
        
        print("ViewController::didSucceedTransactionresponse= %@", response)
        let _: String = "Your order was completed successfully.\n Rs. \(response["TXNAMOUNT"]!)"
        
        
        //        self.function.alert_for("Thank You for Payment", message: msg)
        self.removeController(controller)
        
        
    }
    
    func didFailTransaction(_ controller: PGTransactionViewController, error: Error, response: [AnyHashable: Any]) {
        // Called when Transation is Failed
        print("ViewController::didFailTransaction error = %@ response= %@", error, response)
        
        if response.count == 0 {
            
            //            self.function.alert_for(error.localizedDescription, message: response.description)
            
        }
//        else if error != nil {
//            
//            //            self.function.alert_for("Error", message: error.localizedDescription)
//            
//            
//        }
        
        self.removeController(controller)
        
    }
    
    func didCancelTransaction(_ controller: PGTransactionViewController, error: Error, response: [AnyHashable: Any]) {
        
        //Cal when Process is Canceled
//        var msg: String? = nil
//        
//        if error != nil {
//            
//            msg = String(format: "Successful")
//        }
//        else {
//            msg = String(format: "UnSuccessful")
//        }
        
        
//        self.function.alert_for("Transaction Cancel", message: msg!)
        
        self.removeController(controller)
        
    }
    
    func didFinishCASTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        
        print("ViewController::didFinishCASTransaction:response = %@", response);
        
    }
    // MARK: - Server Request -

}
