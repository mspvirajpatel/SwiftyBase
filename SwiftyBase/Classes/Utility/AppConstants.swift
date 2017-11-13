//
//  AppConstants.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

import Foundation


/// Prints the filename, function name, line number and textual representation of `object` and a newline character into the standard output if the build setting for "Active Complilation Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`.
///
/// The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
///
/// Only the first parameter needs to be passed to this funtion.
///
/// The textual representation is obtained from the `object` using `String(reflecting:)` which works for _any_ type. To provide a custom format for the output make your object conform to `CustomDebugStringConvertible` and provide your format in the `debugDescription` parameter.
/// - Parameters:
///   - object: The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
///   - file: The name of the file, defaults to the current file without the ".swift" extension.
///   - function: The name of the function, defaults to the function within which the call is made.
///   - line: The line number, defaults to the line number within the file that the call is made.
public func dLog<T>(_ object: @autoclosure () -> T, filename: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        
        let fileURL = filename.lastPathComponent.stringByDeletingPathExtension
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)] :-> " + String(reflecting: value))
    #endif
}

/// Outputs a `dump` of the passed in value along with an optional label, the filename, function name, and line number to the standard output if the build setting for "Active Complilation Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`.
///
/// The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
///
/// Only the first parameter needs to be passed in to this function. If a label is required to describe what is being dumped, the `label` parameter can be used. If `nil` (the default), no label is output.
/// - Parameters:
///   - object: The object to be `dump`ed. If it is obtained by evaluating an expression, this is lazily evaluated.
///   - label: An optional label that may be used to describe what is being dumped.
///   - file: he name of the file, defaults to the current file without the ".swift" extension.
///   - function: The name of the function, defaults to the function within which the call is made.
///   - line: The line number, defaults to the line number within the file that the call is made.
public func dLogDump<T>(_ object: @autoclosure () -> T, label: String? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("--------")
        print("<\(queue)> \(fileURL) \(function):[\(line)] ")
        label.flatMap{ print($0) }
        dump(value)
        print("--------")
    #endif
}

//  MARK: - System Constants -

public struct SystemConstants {
    
    public static let showLayoutArea = true
    public static let hideLayoutArea = false
    public static let showVersionNumber = 1
    
    public static let IS_IPAD = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    public static let IS_DEBUG = false
}

public struct ControlConstant {
    
    public static let controlKey : String = "ControlRequestKey"
    public static let name : String = "controlName"
   
    public static let borderRadius : CGFloat = 3.0
    
    public static let horizontalPadding : CGFloat = 10.0
    public static let verticalPadding : CGFloat = 10.0
    
    public static let txtBorderWidth : CGFloat = 1.5
    public static let txtBorderRadius : CGFloat = 2.5
    public static let textFieldHeight : CGFloat = 30.0
    public static let textLeftPadding : CGFloat = 10.0
    
}

public struct Server {
    
    //  Main Domain
    
    static let socketRootUrl = "any Socket URl"
    
    //  API - Sub Domain
    
    static func getFullAPIPath(_ apiURLString : String) -> String {
        return Server.socketRootUrl + apiURLString
    }
    
  
}

//  MARK: - Info / Error Message Constants -

public struct ErrorMessage {
    
    public static let noInternet = "⚠️ Internet connection is not available."
    public static let noCurrentLocation = "⚠️ Unable to find current location."
    public static let noCameraAvailable = "⚠️ Camera is not available in device."
    
}

// MARK: - Device Compatibility

public struct currentDevice {
    public static let isIphone = (UIDevice.current.model as NSString).isEqual(to: "iPhone") ? true : false
    public static let isIpad = (UIDevice.current.model as NSString).isEqual(to: "iPad") ? true : false
    public static let isIPod = (UIDevice.current.model as NSString).isEqual(to: "iPod touch") ? true : false
}
