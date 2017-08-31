//
//  AppConstants.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

import Foundation


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
