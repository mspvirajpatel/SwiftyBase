//
//  ButtonDemoController.swift
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

class BaseControlsDemoController: BaseViewController {

    // MARK: - Attributes -
    
    var buttonDemoView: BaseControlsDemoView!
    
    // MARK: - Lifecycle -
    
    required init() {
        buttonDemoView = BaseControlsDemoView(frame: CGRect.zero)
        super.init(iView: buttonDemoView, andNavigationTitle: "Base Controls")
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    required init(iView: BaseView) {
        buttonDemoView = BaseControlsDemoView(frame: CGRect.zero)
        super.init(iView: buttonDemoView, andNavigationTitle: "Base Controls")
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init(iView: BaseView, andNavigationTitle titleString: String) {
        buttonDemoView = BaseControlsDemoView(frame: CGRect.zero)
        super.init(iView: buttonDemoView, andNavigationTitle: "Base Controls")
        self.loadViewControls()
        self.setViewlayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    


}
