//
//  IntExtension.swift
//  Pods
//
//  Created by MacMini-2 on 12/09/17.
//
//

import Foundation

public extension Int{
    
    var isEven: Bool {
        return (self % 2 == 0)
    }
    
    var isOdd: Bool {
        return (self % 2 != 0)
    }
    
    var isPositive: Bool {
        return (self >= 0)
    }
    
    var isNegative: Bool {
        return (self < 0)
    }
    
    var toDouble: Double {
        return Double(self)
    }
    
    var toFloat: Float {
        return Float(self)
    }
    
    var digits: Int {
        //this only works in bound of LONG_MAX 2147483647, the maximum value of int
        if(self == 0)
        {
            return 1
        }
        else if(Int(fabs(Double(self))) <= LONG_MAX)
        {
            return Int(log10(fabs(Double(self)))) + 1
        }
    }
}
