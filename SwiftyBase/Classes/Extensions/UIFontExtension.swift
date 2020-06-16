//
//  UIFontExtension.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation

public extension UIFont {
    
    convenience init(fontString: String) {
        let stringArray : Array = fontString.components(separatedBy: ";")
        self.init(name: stringArray[0], size:stringArray[1].toFloat())!
    }
}
