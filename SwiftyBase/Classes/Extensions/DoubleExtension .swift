//
//  DoubleExtension .swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

public extension Double {
    public var second:  TimeInterval { return self }
    public var seconds: TimeInterval { return self }
    public var minute:  TimeInterval { return self * 60 }
    public var minutes: TimeInterval { return self * 60 }
    public var hour:    TimeInterval { return self * 3600 }
    public var hours:   TimeInterval { return self * 3600 }
}
