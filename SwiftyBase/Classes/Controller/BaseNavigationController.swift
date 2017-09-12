//
//  BaseNavigationController.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

@IBDesignable
open class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate, CAAnimationDelegate{
    
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
        
        var navigationBarFont: UIFont? = UIFont(name: FontStyle.medium, size: 17.0)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationBG.value,
                                                            NSFontAttributeName: navigationBarFont!] as [String : Any]
        
        self.navigationBar.tintColor = Color.navigationBG.value
        self.navigationBar.barTintColor = Color.appPrimaryBG.value
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = Color.appPrimaryBG.value
     
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
   
    open func animation()
    {
        // logo mask
        self.view.layer.mask = CALayer()
        self.view.layer.mask?.contents = UIImage(named: "logo.png")!.cgImage
        self.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.layer.mask?.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        
        // logo mask background view
        let maskBgView = UIView(frame: self.view.frame)
        maskBgView.backgroundColor = UIColor.white
        self.view.addSubview(maskBgView)
        self.view.bringSubview(toFront: maskBgView)
        
        // logo mask animation
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue.init(cgRect: (self.view.layer.mask?.bounds)!)
        let secondBounds = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        let finalBounds = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards
        self.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
        
        // logo mask background view animation
        UIView.animate(withDuration: 0.1,
                       delay: 1.35,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        maskBgView.alpha = 0.0
        },
                       completion: { finished in
                        maskBgView.removeFromSuperview()
        })
        
        // root view animation
        UIView.animate(withDuration: 0.25,
                       delay: 1.3,
                       options: UIViewAnimationOptions.transitionCrossDissolve,
                       animations: {
                        (AppUtility.getDelegate() as! UIApplicationDelegate).window!!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions.curveEaseInOut,
                                       animations: {
                                        (AppUtility.getDelegate() as! UIApplicationDelegate).window!!.rootViewController!.view.transform = CGAffineTransform.identity
                        },
                                       completion: nil
                        )
        })
        
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
    
    open func controlClearBackTitle() {
        if self.clearBackTitle {
            topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
}
