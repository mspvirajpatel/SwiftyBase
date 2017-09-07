//
//  Utility.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 07/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBase

class Utility: NSObject {
    
    //  MARK: - Network Connection Methods
    
    class func setMenuViewType(_ MenuType: Menu) {
        
        if SideMenuManager.menuLeftNavigationController  != nil {
            
            let menuController: SideMenuController? = (AppUtility.getDelegate() as! AppDelegate).menuController
            menuController?.displaySelectedView(type: MenuType.rawValue)
            
        }
    }
}
