//
//  DownloadingController.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 11/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyBase

class DownloadingController: BaseViewController {
    
    // MARK: - Attributes -
    var downloadingView : DownloadingView!
    
    // MARK: - Lifecycle -
    required init()
    {
        downloadingView = DownloadingView(frame: CGRect.zero)
        super.init(iView: downloadingView, andNavigationTitle: "Downloading")
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    required init(iView: BaseView, andNavigationTitle titleString: String) {
        fatalError("init(iView:andNavigationTitle:) has not been implemented")
    }
    
    required init(iView: BaseView) {
        fatalError("init(iView:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    deinit{
        print("DownloadingController deinit called")
        NotificationCenter.default.removeObserver(self)
        
        if downloadingView != nil && downloadingView.superview != nil{
            downloadingView.removeFromSuperview()
            downloadingView = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
}
