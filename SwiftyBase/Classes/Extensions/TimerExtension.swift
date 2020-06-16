//
//  NSTimerExtension.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation

// MARK: - Timer Extension -
private class NSTimerActor {
    var block: () -> ()
    
    init(_ block: @escaping () -> ()) {
        self.block = block
    }
    
    @objc func fire() {
        block()
    }
}

public extension Timer {
    class func new(after interval: TimeInterval, _ block: @escaping () -> ()) -> Timer {
        let actor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: false)
    }
    
    class func new(every interval: TimeInterval, _ block: @escaping () -> ()) -> Timer {
        let actor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: true)
    }
    
    class func after(interval: TimeInterval, _ block: @escaping () -> ()) -> Timer {
        let timer = Timer.new(after: interval, block)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        return timer
    }
    
    class func every(interval: TimeInterval, _ block: @escaping () -> ()) -> Timer {
        let timer = Timer.new(every: interval, block)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        return timer
    }
}

//Use
//NSTimer.after(1.minute) {
//    println("Are you still here?")
//}
//
//// Repeating an action
//NSTimer.every(0.7.seconds) {
//    statusItem.blink()
//}
//
//// Pass a method reference instead of a closure
//NSTimer.every(30.seconds, align)
//
//// Make a timer object without scheduling
//let timer = NSTimer.new(every: 1.second) {
//    println(self.status)
//}

