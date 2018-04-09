//
//  DataExtension.swift
//  Pods
//
//  Created by MacMini-2 on 01/09/17.
//
//

import Foundation

extension Data {
    var stringValue: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    var base64EncodedString: String? {
        return self.base64EncodedString(options: .lineLength64Characters)
    }

    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }


}
