//
//  AppTimer.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

import Foundation

public class AppTimer {

    private let internalTimer: DispatchSourceTimer

    private var isRunning = false

    public let repeats: Bool

    public typealias AppTimerHandler = (AppTimer) -> Void

    private var handler: AppTimerHandler

    public init(interval: DispatchTimeInterval, repeats: Bool = false, queue: DispatchQueue = .main, handler: @escaping AppTimerHandler) {

        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }

        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            internalTimer.schedule(deadline: .now() + interval)
        }
    }

    public static func repeaticTimer(interval: DispatchTimeInterval, queue: DispatchQueue = .main, handler: @escaping AppTimerHandler) -> AppTimer {
        return AppTimer(interval: interval, repeats: true, queue: queue, handler: handler)
    }

    deinit {
        self.internalTimer.cancel()
    }

    //You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }

    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }

    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }

    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }

    public func rescheduleHandler(handler: @escaping AppTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }

    }
}

//MARK: Throttle
public extension AppTimer {

    private static var timers = [String: DispatchSourceTimer]()

    public static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main, handler: @escaping () -> Void) {

        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
        }

        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now() + interval)
        timer.setEventHandler {
            handler()
            timer.cancel()
            timers.removeValue(forKey: identifier)
        }
        timer.resume()
        timers[identifier] = timer
    }
}

//MARK: Count Down
public class SwiftCountDownTimer {

    private let internalTimer: AppTimer

    private var leftTimes: Int

    private let originalTimes: Int

    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void

    public init(interval: DispatchTimeInterval, times: Int, queue: DispatchQueue = .main, handler: @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void) {

        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = AppTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self] AppTimer in
            if let strongSelf = self {
                if strongSelf.leftTimes > 0 {
                    strongSelf.leftTimes = strongSelf.leftTimes - 1
                    strongSelf.handler(strongSelf, strongSelf.leftTimes)
                } else {
                    strongSelf.internalTimer.suspend()
                }
            }
        }
    }

    public func start() {
        self.internalTimer.start()
    }

    public func suspend() {
        self.internalTimer.suspend()
    }

    public func reCountDown() {
        self.leftTimes = self.originalTimes
    }

}

public extension DispatchTimeInterval {

    public static func fromSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return .nanoseconds(Int(seconds * Double(NSEC_PER_SEC)))
    }
}


//Timer Usage
//
//single timer
//
//let timer = SwiftTimer(interval: .seconds(2)) {
//    print("fire")
//}
//timer.start()
//repeatic timer
//
//let timer = SwiftTimer.repeaticTimer(interval: .seconds(1)) {
//    print("fire")
//}
//timer.start()
//dynamically changing interval
//
//let timer = SwiftTimer.repeaticTimer(interval: .seconds(5)) { timer in
//    print("doSomething")
//}
//timer.start()  // print doSomething every 5 seconds
//
//func speedUp(timer: SwiftTimer) {
//    timer.rescheduleRepeating(interval: .seconds(1))
//}
//speedUp(timer) // print doSomething every 1 second
//throttle
//
//SwiftTimer.throttle(interval: .seconds(0.5), identifier: "throttle") {
//    search(inputText)
//}
//count down timer
//
//let timer = SwiftCountDownTimer(interval: .fromSeconds(0.1), times: 10) { timer , leftTimes in
//    label.text = "\(leftTimes)"
//}
//timer.start()
