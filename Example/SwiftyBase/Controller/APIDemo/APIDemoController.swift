//
//  APIDemoController.swift
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

class APIDemoController: BaseViewController {

    // MARK: - Attributes -
    
    var aPIDemoView: APIDemoView!
    
    // MARK: - Lifecycle -
    
    required init() {
        aPIDemoView = APIDemoView(frame: CGRect.zero)
        super.init(iView: aPIDemoView, andNavigationTitle: "API DEMO")
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton(image: UIImage(named: "menu"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    required init(iView: BaseView) {
        aPIDemoView = APIDemoView(frame: CGRect.zero)
        super.init(iView: aPIDemoView, andNavigationTitle: "API DEMO")
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init(iView: BaseView, andNavigationTitle titleString: String) {
        aPIDemoView = APIDemoView(frame: CGRect.zero)
        super.init(iView: aPIDemoView, andNavigationTitle: "API DEMO")
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
