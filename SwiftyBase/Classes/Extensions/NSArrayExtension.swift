//
//  NSArrayExtension.swift
//  Pods
//
//  Created by MacMini-2 on 01/09/17.
//
//

import Foundation

/// This extension add some useful functions to NSArray
public extension NSArray {
    // MARK: - Instance functions -
    
    /**
     Get the object at a given index in safe mode (nil if self is empty or out of range)
     
     - parameter index: The index
     
     - returns: Returns the object at a given index in safe mode (nil if self is empty or out of range)
     */
    public func safeObjectAtIndex(index: Int) -> AnyObject? {
        if self.count > 0 && self.count > index {
            return self[index] as AnyObject?
        } else {
            return nil
        }
    }
    
    /**
     Create a reversed array from self
     
     - returns: Returns the reversed array
     */
    public func reversedArray() -> NSArray {
        return NSArray.reversedArray(array: self)
    }
    
    /**
     Convert self to JSON as String
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    public func arrayToJSON() throws -> NSString {
        return try NSArray.arrayToJSON(array: self)
    }
    
    /**
     Simulates the array as a circle. When it is out of range, begins again
     
     - parameter index: The index
     
     - returns: Returns the object at a given index
     */
    public func objectAtCircleIndex(index: Int) -> AnyObject {
        return self[self.superCircle(index: index, size: self.count)] as AnyObject
    }
    
    /**
     Private, to get the index as a circle
     
     - parameter index:   The index
     - parameter maxSize: Max size of the array
     
     - returns: Returns the right index
     */
    private func superCircle(index: Int, size maxSize: Int) -> Int{
        var _index = index
        if _index < 0 {
            _index = _index % maxSize
            _index += maxSize
        }
        if _index >= maxSize {
            _index = _index % maxSize
        }
        
        return _index
    }
    
    // MARK: - Class functions -
    
    /**
     Create a reversed array from the given array
     
     - parameter array: The array to be reverse
     
     - returns: Returns the reversed array
     */
    public static func reversedArray(array: NSArray) -> NSArray {
        let arrayTemp: NSMutableArray = NSMutableArray.init(capacity: array.count)
        let enumerator: NSEnumerator = array.reverseObjectEnumerator()
        
        for element in enumerator {
            arrayTemp.add(element)
        }
        
        return arrayTemp
    }
    
    /**
     Create a reversed array from the given array
     
     - parameter array: The array to be converted
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    public static func arrayToJSON(array: AnyObject) throws -> NSString {
        let data = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions())
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
    }
    
    
    //Json String
    
    public func JSONString() -> NSString{
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
    
    
    //  Make Comma separated String from array
    public var toCommaString: String! {
        return self.componentsJoined(by: ",")
    }
    
    
    //  Chack Array contain specific object
    public func containsObject<T:AnyObject>(_ item:T) -> Bool
    {
        for element in self
        {
            if item === element as? T
            {
                return true
            }
        }
        return false
    }
    
    //  Get Index of specific object
    public func indexOfObject<T : Equatable>(_ x:T) -> Int? {
        for i in 0...self.count {
            if self[i] as! T == x {
                return i
            }
        }
        return nil
    }
    
    //  Gets the object at the specified index, if it exists.
    public func get(_ index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
    
}
