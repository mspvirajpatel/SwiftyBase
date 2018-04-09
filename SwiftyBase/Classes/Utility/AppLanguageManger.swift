//
//  AppLanguageManger.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation
import UIKit

var AssociatedObjectHandle: UInt8 = 0

open class AppLanguageManger: Bundle {

    public static let shared: AppLanguageManger = {
        object_setClass(Bundle.main, AppLanguageManger.self)
        return AppLanguageManger()
    }()

    // save/get seleccted language
    public var currentLang: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedLanguage") ?? NSLocale.preferredLanguages[0]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedLanguage")
        }
    }

    // overide localized string function
    override open func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }

    public func setLanguage(language: String) {
        // change current bundle path from main to selected language
        let value = Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj")!)
        objc_setAssociatedObject(Bundle.main, &AssociatedObjectHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        // change app language
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // set current language
        currentLang = language

        // used to get notification when language change (if you have somthing to do)
        NotificationCenter.default.post(name: NSNotification.Name.LanguageDidChange, object: nil)

    }

}

// MARK: NSNotification.Name extension
public extension NSNotification.Name {
    // used to get notification when language change (if you have somthing to do)
    public static var LanguageDidChange: NSNotification.Name {
        return NSNotification.Name.init("languageDidChange")
    }
}


// MARK: String extension
public extension String {

    // used to localize string from code
    public func localiz() -> String {
        guard let bundle = Bundle.main.path(forResource: AppLanguageManger.shared.currentLang, ofType: "lproj") else {
            return NSLocalizedString(self, comment: "")
        }

        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: "")
    }

}


// MARK: UIApplication extension
extension UIApplication {
    // used to get top view controller
    public static var topViewController: UIViewController? {
        get {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                return topController
            } else {
                return nil
            }
        }
    }

}
