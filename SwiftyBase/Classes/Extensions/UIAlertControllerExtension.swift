//
//  UIAlertControllerExtension.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

public extension UIAlertController {
    public func showAlert(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        var forefrontVC = rootVC
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        forefrontVC.present(self, animated: animated, completion: completionHandler)
    }
}
