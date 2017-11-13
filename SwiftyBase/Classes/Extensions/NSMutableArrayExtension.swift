//
//  NSMutableArrayExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

/// This extension adds some useful functions to NSMutableArray
public extension NSMutableArray {
    // MARK: - Instance functions -
    
    /**
     Move an object from an index to another
     
     - parameter from: The index to move from
     - parameter to:   The index to move to
     */
    public func moveObjectFromIndex(from: Int, toIndex to: Int) {
        if to != from {
            let obj: AnyObject? = self.safeObjectAtIndex(index: from)
            self.removeObject(at: from)
            
            if to >= self.count {
                self.add(obj!)
            } else {
                self.insert(obj!, at:to)
            }
        }
    }
    
    // MARK: - Class functions -
    // MARK: - Class functions -
    
    /**
     Sort an array by a given key with option for ascending or descending
     
     - parameter key:       The key to order the array
     - parameter array:     The array to be ordered
     - parameter ascending: A Bool to choose if ascending or descending
     
     - returns: Returns the given array ordered by the given key ascending or descending
     */
    public static func sortArrayByKey(key: String, array: NSMutableArray, ascending: Bool) -> NSMutableArray {
        var tempArray: NSMutableArray = NSMutableArray()
        tempArray.addObjects(from: array as [AnyObject])
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        let sortedArray = tempArray.sortedArray(using: [descriptor])
        
        tempArray.removeAllObjects()
        tempArray = NSMutableArray(array: sortedArray)
        
        array.removeAllObjects()
        array.addObjects(from: tempArray as [AnyObject])
        
        return array
    }
    
}
