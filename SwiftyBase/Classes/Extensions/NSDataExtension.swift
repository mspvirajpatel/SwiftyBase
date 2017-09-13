//
//  NSDataExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

/// This extension add some useful functions to NSData
public extension NSData {
    // MARK: - Instance functions -
    
    /**
     Convert self to a UTF8 NSString
     
     - returns: Returns self as UTF8 NSString
     */
    public func convertToUTF8String() -> String {
        return NSData.convertToUTF8String(data: self)
    }
    
    /**
     Convert self to a ASCII NSString
     
     - returns: Returns self as ASCII NSString
     */
    public func convertToASCIIString() -> String {
        return NSData.convertToASCIIString(data: self)
    }
    
    
    
    // MARK: - Class functions -
    
    /**
     Convert the given NSData to UTF8 String
     
     - parameter data: The NSData to be converted
     
     - returns: Returns the converted NSData as UTF8 String
     */
    public static func convertToUTF8String(data: NSData) -> String {
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    /**
     Convert the given NSData to ASCII String
     
     - parameter data: The NSData to be converted
     
     - returns: Returns the converted NSData as ASCII String
     */
    public static func convertToASCIIString(data: NSData) -> String {
        return NSString(data: data as Data, encoding: String.Encoding.ascii.rawValue)! as String
    }
}
