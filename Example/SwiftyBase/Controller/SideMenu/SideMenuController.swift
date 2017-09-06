//
//  SideMenuController.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 06/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBase

public enum Menu : Int{
    case api = 0
    case button = 1
}

class SideMenuController: BaseViewController {
    
    // MARK: - Attributes -
    var sideMenuView : SideMenuView!
    var currentSelectedMenu : Int = Menu.api.rawValue
  
    // MARK: - Lifecycle -
    required init()
    {
        sideMenuView = SideMenuView()
        super.init(iView: sideMenuView, andNavigationTitle: "")
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    required init(iView: BaseView) {
        fatalError("init(iView:) has not been implemented")
    }
    
    required init(iView: BaseView, andNavigationTitle titleString: String) {
        fatalError("init(iView:andNavigationTitle:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.sideMenuView != nil{
            self.sideMenuView.updateUI()
        }
    }
    
    deinit{
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        sideMenuView.cellSelectedEvent { [weak self] (sendor, object) in
            if self == nil{
                return
            }
            self!.displaySelectedView(type: object as! Int)
        }
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    // MARK: - User Interaction -
    // MARK: - Internal Helpers -
    
    
    private func displaySelectedView(type : Int)
    {
        if currentSelectedMenu != type  {
            var controller : BaseViewController? = self.setSelectedMenuObject(menuType: type)
            
            if controller != nil{
                
                AppUtility.executeTaskInMainQueueWithCompletion {
                    
                    self.dismiss(animated: true, completion: {
                        
                    })
                }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.navigation.viewControllers = [controller!]
                
            }
            
            defer {
                controller = nil
            }
        }
        else{
            AppUtility.executeTaskInMainQueueWithCompletion {
                self.dismiss(animated: true, completion: {
                    
                })
                
            }
        }
        sideMenuView.setSelectedMenu(type: currentSelectedMenu)
    }
    
    private func setSelectedMenuObject(menuType : Int) -> BaseViewController?{
        
        var controller : BaseViewController?
        
        switch menuType {
        case Menu.api.rawValue:
            
            controller = APIDemoController()
            
            break
            
        case Menu.button.rawValue:
            
            controller = BaseControlsDemoController()
            break
       
        default:
            break
        }
        
        currentSelectedMenu = menuType
        
        defer {
            controller = nil
        }
        
        return controller
    }
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
   
}
