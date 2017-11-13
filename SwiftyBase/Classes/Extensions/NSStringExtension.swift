//
//  NSStringExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation
import UIKit

/// This extension adds some useful functions to NSString
public extension NSString {
    
    // MARK: - Instance functions -
    
    /**
     Check if self has the given substring in case-sensitive
     
     - parameter string:        The substring to be searched
     - parameter caseSensitive: If the search has to be case-sensitive or not
     
     - returns: Returns true if founded, false if not
     */
    public func hasString(string: NSString, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return !(self.range(of: string as String).location == NSNotFound)
        } else {
            return !(self.range(of: string.lowercased as String).location == NSNotFound)
        }
    }
    
    /**
     Check if self is an email
     
     - returns: Returns true if it's an email, false if not
     */
    public func isEmail() -> Bool {
        return NSString.isEmail(email: self)
    }
    
    /**
     Encode the given string to Base64
     
     - returns: Returns the encoded string
     */
    public func encodeToBase64() -> NSString {
        return NSString.encodeToBase64(string: self)
    }
    
    /**
     Decode the given Base64 to string
     
     - returns: Returns the decoded string
     */
    public func decodeBase64() -> NSString {
        return NSString.decodeBase64(string: self)
    }
    
    /**
     Convert self to a NSData
     
     - returns: Returns self as NSData
     */
    public func convertToNSData() -> NSData {
        return NSString.convertToNSData(string: self)
    }
    
    /**
     Conver self to a capitalized string.
     Example: "This is a Test" will return "This is a test" and "this is a test" will return "This is a test"
     
     - returns: Returns the capitalized sentence string
     */
    public func sentenceCapitalizedString() -> NSString {
        if self.length == 0 {
            return ""
        }
        let uppercase: NSString = self.substring(to: 1).uppercased() as NSString
        let lowercase: NSString = self.substring(from: 1).lowercased() as NSString
        
        
        return uppercase.appending(lowercase as String) as NSString
    }
    
    /**
     Returns a human legible string from a timestamp
     
     - returns: Returns a human legible string from a timestamp
     */
    public func dateFromTimestamp() -> NSString {
        let year: NSString = self.substring(to: 4) as NSString
        var month: NSString = self.substring(from: 5) as NSString
        month = month.substring(to: 4) as NSString
        var day: NSString = self.substring(from: 8) as NSString
        day =
            day.substring(to: 2) as NSString
        var hours: NSString = self.substring(from: 11) as NSString
        hours = hours.substring(to: 2) as NSString
        var minutes: NSString = self.substring(from: 14) as NSString
        minutes = minutes.substring(to: 2) as NSString
        
        return "\(day)/\(month)/\(year) \(hours):\(minutes)" as NSString
    }
    
    public func convertToAPNSUUID() -> NSString {
        
        return self.trimmingCharacters(in: NSCharacterSet(charactersIn: "<>") as CharacterSet).replacingOccurrences(of: "", with: "").replacingOccurrences(of:"-", with: "") as NSString
    }
    
    /**
     Encode self to an encoded url string
     
     - returns: Returns the encoded NSString
     */
    public func URLEncode() -> NSString {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)! as NSString
    }
    
    /**
     Returns a new string containing matching regular expressions replaced with the template string
     
     - parameter regexString: The regex string
     - parameter replacement: The replacement string
     
     - returns: Returns a new string containing matching regular expressions replaced with the template string
     */
    public func stringByReplacingWithRegex(regexString: NSString, withString replacement: NSString) throws -> NSString {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regexString as String, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:NSMakeRange(0, self.length), withTemplate: "") as NSString
    }
    
    /**
     Returns if self is a valid UUID or not
     
     - returns: Returns if self is a valid UUID or not
     */
    public func isUUID() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.length))
            return matches == 1
        } catch {
            return false
        }
    }
    
    /**
     Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     
     - returns: Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     */
    public func isUUIDForAPNS() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{32}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.length))
            return matches == 1
        } catch {
            return false
        }
    }
    
    
    /**
     Used to calculate text height for max width and font
     
     - parameter width: Max width to fit text
     - parameter font:  Font used in text
     
     - returns: Returns the calculated height of string within width using given font
     */
    public func heightForWidth(width: CGFloat, font: UIFont) -> CGFloat {
        var size: CGSize = CGSize.zero
        if self.length > 0 {
            let frame: CGRect = self.boundingRect(with:CGSize.init(width: width, height: 999999), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
            size = CGSize.init(width: frame.size.width, height: frame.size.height + 1)
            
        }
        return size.height
    }
    
    // MARK: - Class functions -
    
    
    
    /**
     Check if the given string is an email
     
     - parameter email: The string to be checked
     
     - returns: Returns true if it's an email, false if not
     */
    public static func isEmail(email: NSString) -> Bool {
        let emailRegEx: NSString = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let regExPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return regExPredicate.evaluate(with: email.lowercased)
    }
    
    
    /**
     Encode the given string to Base64
     
     - parameter string: String to encode
     
     - returns: Returns the encoded string
     */
    public static func encodeToBase64(string: NSString) -> NSString {
        let data: NSData = string.convertToNSData()
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString
    }
    
    /**
     Decode the given Base64 to string
     
     - parameter string: String to decode
     
     - returns: Returns the decoded string
     */
    public static func decodeBase64(string: NSString) -> NSString {
        let data: NSData = NSData(base64Encoded: string as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        return data.convertToUTF8String() as NSString
    }
    
    /**
     Convert the given NSString to NSData
     
     - parameter string: The NSString to be converted
     
     - returns: Returns the converted NSString as NSData
     */
    public static func convertToNSData(string: NSString) -> NSData {
        return string.data(using: String.Encoding.utf8.rawValue)! as NSData
    }
    
    /**
     Remove double or more duplicated spaces
     
     - returns: String without additional spaces
     */
    //    public func removeExtraSpaces() -> NSString {
    //        let squashed = self.stringByReplacingOccurrencesOfString("[ ]+", withString: " ", options: .RegularExpressionSearch, range: NSMakeRange(0, self.length))
    //        return squashed.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    //    }
    
    
    public func removeExtraSpaces() -> NSString {
        return components(separatedBy: .whitespaces).joined(separator: "") as NSString
    }
    /**
     Returns a new string containing matching regular expressions replaced with the template string
     
     - parameter regexString: The regex string
     - parameter replacement: The replacement string
     
     - returns: Returns a new string containing matching regular expressions replaced with the template string
     */
    public func stringByReplacingWithRegex(regexString: NSString, replacement: NSString) -> NSString? {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regexString as String, options: .caseInsensitive)
            return regex.stringByReplacingMatches(in: self as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length), withTemplate: "") as NSString?
        } catch {
            
        }
        
        return nil
    }
    
    
    /**
     Used to create an UUID as String
     
     - returns: Returns the created UUID string
     */
    public static func generateUUID() -> NSString {
        let theUUID: CFUUID? = CFUUIDCreate(kCFAllocatorDefault)
        let string: CFString? = CFUUIDCreateString(kCFAllocatorDefault, theUUID)
        return string!
    }
}
