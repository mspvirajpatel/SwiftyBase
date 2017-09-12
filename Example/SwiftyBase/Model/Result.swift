//
//  Result.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 05/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class Result: NSObject, NSCoding, NSMutableCopying{
    
    var code : String!
    var name : String!
    var states : Any!
   
    required override init() {
        super.init()
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? String
        name = dictionary["name"] as? String
        states = dictionary["states"]
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if name != nil{
            dictionary["name"] = name
        }
        if states != nil{
            dictionary["states"] = states
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        states = aDecoder.decodeObject(forKey: "states")
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if states != nil{
            aCoder.encode(states, forKey: "states")
        }
        
    }
    
    // MARK: - NSCopying Delegate Method -
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        return getMutable()
    }
    
    private func getMutable() -> Result{
        
        let object : Result = Result()
        
        object.code = self.code
        object.name = self.name
        object.states = self.states
     
        return object
    }

    
}
