//
//  DoubleExtension .swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

public extension Double {
    var second:  TimeInterval { return self }
    var seconds: TimeInterval { return self }
    var minute:  TimeInterval { return self * 60 }
    var minutes: TimeInterval { return self * 60 }
    var hour:    TimeInterval { return self * 3600 }
    var hours:   TimeInterval { return self * 3600 }
}
