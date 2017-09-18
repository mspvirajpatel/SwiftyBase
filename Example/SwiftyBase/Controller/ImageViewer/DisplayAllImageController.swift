//
//  DisplayAllImageController.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 18/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBase

class DisplayAllImageController: BaseViewController {
    
    var displayImageView : DisplayAllImageView?
    
    // MARK: - Lifecycle -
    required init()
    {
        var subView : DisplayAllImageView? = DisplayAllImageView(frame: CGRect.zero)
        
        super.init(iView: subView!, andNavigationTitle: "Display All Image")
        displayImageView = subView!
        
        self.loadViewControls()
        self.setViewControlsLayout()
        
        subView = nil
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required init(iView: BaseView, andNavigationTitle titleString: String) {
        fatalError("init(iView:andNavigationTitle:) has not been implemented")
    }
    
    required init(iView: BaseView) {
        fatalError("init(iView:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Layout -
    internal override func loadViewControls() -> Void
    {
        super.loadViewControls()
      
        
    }
    
    private func setViewControlsLayout() -> Void
    {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
