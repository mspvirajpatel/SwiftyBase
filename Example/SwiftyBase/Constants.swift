//
//  Constants.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 30/08/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

//  MARK: - System Oriented Constants -

struct SystemConstants {
    
    static let showLayoutArea = true
    static let hideLayoutArea = false
    static let showVersionNumber = 1
    
    static let IS_IPAD = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    static let IS_DEBUG = false
}

struct General{
    static let textFieldColorAlpha : CGFloat = 0.5
}

//  MARK: - Thired Party Constants -


//  MARK: - Server Constants -


//  MARK: - layoutTime Constants -

struct ControlLayout {
    
    static let name : String = "controlName"
    static let borderRadius : CGFloat = 3.0
    
    static let horizontalPadding : CGFloat = 10.0
    static let verticalPadding : CGFloat = 10.0
    
    static let txtBorderWidth : CGFloat = 1.5
    static let txtBorderRadius : CGFloat = 2.5
    static let textFieldHeight : CGFloat = 30.0
    static let textLeftPadding : CGFloat = 10.0
}

//  MARK: - Cell Identifier Constants -

struct CellIdentifire {
    static let defaultCell  = "cell"
    static let leftMenu = "leftMenuCell"
    static let photo = "photoCell"
}

//  MARK: - Info / Error Message Constants -

struct ErrorMessage {
    
    static let noInternet = "⚠️ Internet connection is not available."
    static let noCurrentLocation = "⚠️ Unable to find current location."
    static let noCameraAvailable = "⚠️ Camera is not available in device."
    
}

// MARK: - Device Compatibility

struct currentDevice {
    static let isIphone = (UIDevice.current.model as NSString).isEqual(to: "iPhone") ? true : false
    static let isIpad = (UIDevice.current.model as NSString).isEqual(to: "iPad") ? true : false
    static let isIPod = (UIDevice.current.model as NSString).isEqual(to: "iPod touch") ? true : false
}
