//
//  UINavigationControllerExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation

public extension UINavigationController {
    
      
    @discardableResult
    func replace(with controller: UIViewController, animated: Bool = true) -> UIViewController? {
        var controllers = viewControllers
        let current = controllers.popLast()
        controllers.append(controller)
        
        setViewControllers(controllers, animated: animated)
        
        return current
    }
    
    @discardableResult
    func popAllAndReplace(with controller: UIViewController) -> [UIViewController] {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(transition, forKey: nil)
        
        return replaceAll(with: controller, animated: false)
    }
    
    @discardableResult
    func replaceAll(with controller: UIViewController, animated: Bool = true) -> [UIViewController] {
        let currentControllers = viewControllers
        
        setViewControllers([controller], animated: animated)
        
        return currentControllers
    }
}
