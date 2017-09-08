//
//  UIViewControllerExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public enum PresentationDirection {
    case top, right, bottom, left
}

public extension UIViewController {
    
    public var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    public var navigationBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.height
        }
        return 0
    }
    
    public var isModal: Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    
    public func findChildViewControllerOfType(_ klass: AnyClass) -> UIViewController? {
        for child in childViewControllers {
            if child.isKind(of: klass) {
                return child
            }
        }
        return nil
    }
    
    // Touch View Hidden Keyboard
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    public func currentViewController() -> UIViewController {
        func findBestViewController(_ controller: UIViewController?) -> UIViewController? {
            if let presented = controller?.presentedViewController { // Presented
                return findBestViewController(presented)
            } else {
                switch controller {
                case is UISplitViewController: // Return right hand side
                    let split = controller as? UISplitViewController
                    guard split?.viewControllers.isEmpty ?? true else {
                        return findBestViewController(split?.viewControllers.last)
                    }
                case is UINavigationController: // Return top view
                    let navigation = controller as? UINavigationController
                    guard navigation?.viewControllers.isEmpty ?? true else {
                        return findBestViewController(navigation?.topViewController)
                    }
                case is UITabBarController: // Return visible view
                    let tab = controller as? UITabBarController
                    guard tab?.viewControllers?.isEmpty ?? true else {
                        return findBestViewController(tab?.selectedViewController)
                    }
                default: break
                }
            }
            return controller
        }
        return findBestViewController(UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    public func presentViewController(_ viewController: UIViewController, from: PresentationDirection, completion:  (() -> Void)?) {
        viewController.view.alpha = 0.0
        viewController.modalPresentationStyle = .overCurrentContext
        guard let windowFrame = self.view.window?.frame else {
            return
        }
        let viewFrame = viewController.view.frame
        let finalFrame = viewFrame
        self.present(viewController, animated: false) { () -> Void in
            switch from {
            case .top:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: -windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .right:
                viewController.view.frame = CGRect(x: windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            case .bottom:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .left:
                viewController.view.frame = CGRect(x: -windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            }
            viewController.view.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                viewController.view.frame = finalFrame
            }, completion: { (success) -> Void in
                if success && (completion != nil) {
                    completion!()
                }
            })
        }
    }
    
    func dismissViewController(to: PresentationDirection, completion:  (() -> Void)?) {
        let frame = self.view.frame
        guard let windowFrame = self.view.window?.frame else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            switch to {
            case .top:
                self.view.frame = CGRect(x: frame.origin.x, y: -windowFrame.height, width: frame.width, height: frame.height)
            case .right:
                self.view.frame = CGRect(x: windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            case .bottom:
                self.view.frame = CGRect(x: frame.origin.x, y: windowFrame.height, width: frame.width, height: frame.height)
            case .left:
                self.view.frame = CGRect(x: -windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }, completion: { (success) -> Void in
            if success == true {
                self.dismiss(animated: false, completion: {
                    if completion != nil {
                        completion!()
                    }
                })
            }
        })
    }
    
}
