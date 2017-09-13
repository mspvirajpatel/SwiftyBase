//
//  DictionaryExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation


/// This extension adds some useful functions to NSDictionary
public extension Dictionary {
    // MARK: - Instance functions -
    
    internal var query: String {
        var parts = [String]()
        
        for (key, value) in self {
            parts.append("\(key)=\(value)")
        }
        
        return parts.joined(separator: "&")
    }
    
    internal func urlEncodedQuery(using encoding: String.Encoding) -> String {
        var parts = [String]()
        
        for case let (key as String, value as String) in self {
            parts.append("\(key.urlEncoded)=\(value.urlEncoded)")
        }
        
        return parts.joined(separator: "&")
    }
    
    internal func urlEncodedAndSortedQuery(using encoding: String.Encoding) -> String {
        var parts = [String]()
        
        for case let (key as String, value as String) in self {
            parts.append("\(key.urlEncoded)=\(value.urlEncoded)")
        }
        
        return parts.sorted().joined(separator: "&")
    }
    
    
    /**
     Convert self to JSON as String
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    func dictionaryToJSON() throws -> String {
        return try Dictionary.dictionaryToJSON(dictionary: self as AnyObject)
    }
    
    // MARK: - Class functions -
    
    /**
     Convert the given dictionary to JSON as String
     
     - parameter dictionary: The dictionary to be converted
     
     - returns: Returns the JSON as String or nil if error while parsing
     */
    
    
    static func dictionaryToJSON(dictionary: AnyObject) throws -> String {
        var json: NSString
        let jsonData: NSData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) as NSData
        
        json = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
        return json as String
        
    }
    
    /// EZSE: Returns a random element inside Dictionary
    public func random() -> Value {
        let index: Int = Int(arc4random_uniform(UInt32(self.count)))
        return Array(self.values)[index]
    }
    
    /// EZSE: Union of self and the input dictionaries.
    public func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (key, value) -> Void in
                _ = result.updateValue(value, forKey: key)
            }
        }
        return result
    }
    
    /// EZSE: Checks if a key exists in the dictionary.
    public func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// EZSE: Creates an Array with values generated by running
    /// each [key: value] of self through the mapFunction.
    public func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        var mapped: [V] = []
        forEach {
            mapped.append(map($0, $1))
        }
        return mapped
    }
    
    /// EZSE: Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction.
    public func mapValues<V>(_ map: (Key, Value) -> V) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            mapped[$0] = map($0, $1)
        }
        return mapped
    }
    
    /// EZSE: Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    public func mapFilterValues<V>(_ map: (Key, Value) -> V?) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[$0] = value
            }
        }
        return mapped
    }
    
    /// EZSE: Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    public func mapFilter<K, V>(_ map: (Key, Value) -> (K, V)?) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[value.0] = value.1
            }
        }
        return mapped
    }
    
    /// EZSE: Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction.
    public func map<K, V>(_ map: (Key, Value) -> (K, V)) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        }
        return mapped
    }
    
    /// EZSE: Constructs a dictionary containing every [key: value] pair from self
    /// for which testFunction evaluates to true.
    public func filter(_ test: (Key, Value) -> Bool) -> Dictionary {
        var result = Dictionary()
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        return result
    }
    
    /// EZSE: Checks if test evaluates true for all the elements in self.
    public func testAll(_ test: (Key, Value) -> (Bool)) -> Bool {
        for (key, value) in self {
            if !test(key, value) {
                return false
            }
        }
        return true
    }
    
    
}

extension Dictionary where Value: Equatable {
    /// EZSE: Difference of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] pairs.
    public func difference(_ dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValue(forKey: key)
                }
            }
        }
        return result
    }
}

/// EZSE: Combines the first dictionary with the second and returns single dictionary
public func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

/// EZSE: Difference operator
public func - <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.difference(second)
}

/// EZSE: Union operator
public func | <K: Hashable, V> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.union(second)
}


public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    ///  Merge the keys/values of two dictionaries.
    ///
    ///		let dict : [String : String] = ["key1" : "value1"]
    ///		let dict2 : [String : String] = ["key2" : "value2"]
    ///		let result = dict + dict2
    ///		result["key1"] -> "value1"
    ///		result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    /// - Returns: An dictionary with keys and values from both.
    public static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
    
    // MARK: - Operators
    
    ///  Append the keys and values from the second dictionary into the first one.
    ///
    ///		var dict : [String : String] = ["key1" : "value1"]
    ///		let dict2 : [String : String] = ["key2" : "value2"]
    ///		dict += dict2
    ///		dict["key1"] -> "value1"
    ///		dict["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
    
    
    ///  Remove contained in the array from the dictionary
    ///
    ///		let dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///		let result = dict-["key1", "key2"]
    ///		result.keys.contains("key3") -> true
    ///		result.keys.contains("key1") -> false
    ///		result.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    public static func -(lhs: [Key: Value], keys: [Key]) -> [Key: Value]{
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }
    
    ///  Remove contained in the array from the dictionary
    ///
    ///		var dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///		dict-=["key1", "key2"]
    ///		dict.keys.contains("key3") -> true
    ///		dict.keys.contains("key1") -> false
    ///		dict.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    public static func -=(lhs: inout [Key: Value], keys: [Key]) {
        lhs.removeAll(keys: keys)
    }
    
    ///  Lowercase all keys in dictionary.
    ///
    ///	 var dict = ["tEstKeY": "value"]
    ///	 dict.lowercaseAllKeys()
    ///	 print(dict) // prints "["testkey": "value"]"
    public mutating func lowercaseAllKeys() {
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
    
    /// Check if key exists in dictionary.
    ///
    ///		let dict: [String : Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
    ///		dict.has(key: "testKey") -> true
    ///		dict.has(key: "anotherKey") -> false
    ///
    /// - Parameter key: key to search for
    /// - Returns: true if key exists in dictionary.
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    
    ///  Remove all keys of the dictionary.
    ///
    ///		var dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///		dict.removeAll(keys: ["key1", "key2"])
    ///		dict.keys.contains("key3") -> true
    ///		dict.keys.contains("key1") -> false
    ///		dict.keys.contains("key2") -> false
    ///
    /// - Parameter keys: keys to be removed
    public mutating func removeAll(keys: [Key]) {
        keys.forEach({ removeValue(forKey: $0)})
    }
}
