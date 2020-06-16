//
//  NSDictionaryExtension.swift
//  Pods
//
//  Created by MacMini-2 on 01/09/17.
//
//

import Foundation
/// This extension adds some useful functions to NSDictionary
public extension NSDictionary {
    // MARK: - Instance functions -
    
    /**
     Convert self to JSON as String
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    func dictionaryToJSON() -> String {
        do {
            return try NSDictionary.dictionaryToJSON(dictionary: self)
        } catch {
            return ""
        }
    }
    
    /**
     Returns an object if key exists or nil if not
     
     - parameter key: Key to get value of
     
     - returns: Value for the key Or nil
     */
    func safeObjectForKey(key: String) -> AnyObject? {
        if let value = self[key] {
            return value as AnyObject?
        } else {
            return nil
        }
    }
    
    // MARK: - Class functions -
    
    /**
     Convert the given dictionary to JSON as String
     
     - parameter dictionary: The dictionary to be converted
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    static func dictionaryToJson(dictionary: NSDictionary) throws -> String {
        return try self.dictionaryToJSON(dictionary: dictionary)
    }
    
    /**
     Convert the given dictionary to JSON as String
     
     - parameter dictionary: The dictionary to be converted
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    
    static func dictionaryToJSON(dictionary: NSDictionary) throws -> String {
        var json: NSString
        let jsonData: NSData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) as NSData
        
        
        json = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
        return json as String
        
    }
    
    //Json String Convert
    
    func JSONString() -> NSString{
        var jsonString : NSString = ""
        
        do
        {
            let jsonData : Data = try JSONSerialization .data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue : 0))
            jsonString = NSString(data: jsonData ,encoding: String.Encoding.utf8.rawValue)!
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        return jsonString
    }
    
    
    //  Convert NSDictionary to NSData
    var toNSData : Data! {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)          // success ...
        } catch {
            // failure
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
        return Data()
    }
    
    //  Check key is exist in NSDictionary or not
    func has(_ key: Key) -> Bool {
        return object(forKey: key) != nil
    }
    
}
