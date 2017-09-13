//
//  NSMutableDictionaryExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

/// This extension adds some useful functions to NSMutableDictionary
public extension NSMutableDictionary {
    // MARK: - Instance functions -
    
    /**
     Set the object for a given key in safe mode (if not nil)
     
     - parameter anObject: The object
     - parameter forKey:   The key
     
     - returns: Returns true if has been setted, otherwise false
     */
    public func safeSetObject(anObject: AnyObject?, forKey: NSCopying) -> Bool {
        if anObject == nil {
            return false
        }
        
        self[forKey] = anObject!
        
        return true
    }
}
