//
//  Constants.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 30/08/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import SwiftyBase

//  MARK: - System Oriented Constants -


//  MARK: - Thired Party Constants -


//  MARK: - Server Constants -
struct API {
    
    //  Main Domain
    
    static let baseURL = "https://api.printful.com/" // Enter Your API Base
    
    //  API - Sub Domain
    
    static let subURL1 = "sub URL"
    static let countries = "countries" // sub domain
}

//  MARK: - layoutTime Constants -


//  MARK: - Cell Identifier Constants -

struct CellIdentifire {
    static let defaultCell  = "cell"
    static let leftMenu = "leftMenuCell"
}


