//
//  NSObjectExtension.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

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
