//
//  AppEnumerable.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 08/09/17.
//

import Foundation

public protocol AppEnumerable: RawRepresentable {
    static var enumerate: AnySequence<Self> { get }
    static var elements: [Self] { get }
    static var count: Int { get }
    static var startIndex: Int { get }
}

public extension AppEnumerable where RawValue == Int {
    static var enumerate: AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var i = startIndex
            return AnyIterator { () -> Self? in
                let element = Self(rawValue: i)
                i += 1
                return element
            }
        }
    }
    
    static var elements: [Self] {
        return Array(enumerate)
    }

    static var count: Int {
        return elements.count
    }

    static var startIndex: Int {
        return 0
    }
}
