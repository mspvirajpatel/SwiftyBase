//
//  NSObjectExtension.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

fileprivate var cpkObjectAssociatedObject: UInt8 = 0

public extension NSObject
{
    public func setValueFromDictionary(_ dicResponse : NSDictionary)
    {
        let mirror = Mirror(reflecting: self)
        let allKey : [String] = mirror.proparty()
        
        for key in allKey
        {
            if let value = dicResponse.value(forKey: key)
            {
                if value is Int
                {
                    self.setValue(String(value as! Int), forKey: key)
                }
                else if value is String
                {
                    self.setValue(value, forKey: key)
                }
                else if value is NSDictionary
                {
                    self.setValue(value, forKey: key)
                }
            }
        }
    }
    
    /**
     Check if the object is valid (not nil or null)
     
     - returns: Returns if the object is valid
     */
    public func isValid() -> Bool {
        return !self.isKind(of: NSNull.self)
    }
    
    
    @discardableResult
    public static func cpk_swizzle(method1: Any, method2: Any) -> Bool {
        var s1 = method1 as? Selector
        var s2 = method2 as? Selector
        
        if s1 == nil, let name = method1 as? String {
            s1 = NSSelectorFromString(name)
        }
        
        if s2 == nil, let name = method2 as? String {
            s2 = NSSelectorFromString(name)
        }
        
        if s1 == nil || s2 == nil {
            return false
        }
        
        var m1 = class_getInstanceMethod(self, s1!)
        var m2 = class_getInstanceMethod(self, s2!)
        
        if m1 == nil || m2 == nil {
            return false
        }
        
        class_addMethod(self, s1!, method_getImplementation(m1!), method_getTypeEncoding(m1!))
        class_addMethod(self, s2!, method_getImplementation(m2!), method_getTypeEncoding(m2!))
        
        m1 = class_getInstanceMethod(self, s1!)
        m2 = class_getInstanceMethod(self, s2!)
        method_exchangeImplementations(m1!, m2!)
        
        return true
    }
    
    //    @discardableResult
    //    public static func cpk_swizzleClass(method1: Any, method2: Any) -> Bool {
    //        return object_getClass(self).cpk_swizzle(method1: method1, method2: method2)
    //    }
    
    @discardableResult
    public func cpk_safePerform(selector: Selector) -> Any? {
        if self.responds(to: selector) {
            return self.perform(selector).takeRetainedValue()
        } else {
            return nil
        }
    }
    
    @discardableResult
    public static func cpk_safePerform(selector: Selector) -> Any? {
        if self.responds(to: selector) {
            return self.perform(selector).takeRetainedValue()
        } else {
            return nil
        }
    }
    
    public func cpk_associatedObjectFor(key: String) -> Any? {
        if let dict = objc_getAssociatedObject(self, &cpkObjectAssociatedObject) as? NSMutableDictionary {
            return dict[key]
        } else {
            return nil
        }
    }
    
    public func cpk_setAssociated(object: Any?, forKey key: String) {
        var dict = objc_getAssociatedObject(self, &cpkObjectAssociatedObject) as? NSMutableDictionary
        
        if dict == nil {
            dict = NSMutableDictionary()
            objc_setAssociatedObject(self, &cpkObjectAssociatedObject, dict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        dict![key] = object
    }
    
    
}

// MARK:  - Mirro Extension -

public extension Mirror
{
    public func proparty() -> [String]
    {
        var arrPropary : [String] = []
        
        for item in self.children
        {
            arrPropary.append(item.label!)
        }
        return arrPropary
    }
}
