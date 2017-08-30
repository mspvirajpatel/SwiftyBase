//
//  BaseNavigationController.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import UIKit

open class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate{
    
    // MARK: - Interface
    @IBInspectable open var clearBackTitle: Bool = true
    
    // MARK: - Lifecycle -
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setDefaultParameters()
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Layout -
    
    
    // MARK: - Public Interface -
    
    func setDefaultParameters(){
        
        self.navigationBar.isTranslucent = false
        
        if(self.responds(to: (#selector(getter: UINavigationController.interactivePopGestureRecognizer)))){
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        var navigationBarFont: UIFont? = UIFont(name: FontStyle.medium, size: 17.0)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationTitle.value,
                                                            NSFontAttributeName: navigationBarFont!] as [String : Any]
        
        self.navigationBar.tintColor = Color.navigationTitle.value
        self.navigationBar.barTintColor = Color.navigationBG.value
        self.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.setBottomBorder(Color.navigationBottomBorder.value, width: 1.0)
        
        
        // self.edgesForExtendedLayout = UIRectEdge.none
        
        //        //transperant Navigation Bar
        //        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationBar.shadowImage = UIImage()
        //        self.navigationBar.isTranslucent = true
        
        defer{
            navigationBarFont = nil
        }
    }
    
    
    // MARK: - User Interaction -
   
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        controlClearBackTitle()
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func show(_ vc: UIViewController, sender: Any?) {
        controlClearBackTitle()
        super.show(vc, sender: sender)
    }
    
    // MARK: - Internal Helpers -
}

extension BaseNavigationController {
    
    func controlClearBackTitle() {
        if self.clearBackTitle {
            topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
}
