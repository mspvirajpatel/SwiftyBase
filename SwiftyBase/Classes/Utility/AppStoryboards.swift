//
//  AppStoryboards.swift
//  SwiftyBase
//
//  Created by Viraj Patel on 13/11/17.
//

import Foundation
import UIKit

extension UIStoryboard {

    //MARK:- Generic Public/Instance Methods

    func loadViewController(withIdentifier identifier: viewControllers) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }

    //MARK:- Class Methods to load Storyboards

    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: Bundle.main)
    }

    class func storyBoard(withTextName name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }

}

enum storyboards: String {
    case main = "Main"

}

enum viewControllers: String {

    //OEM Storyboard
    case ListController = "ListController",

    //Consumer Storyboard
    BaseControlsDemoController = "BaseControlsDemoController"
}

//let connectVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .BaseControlsDemoController) as! BaseControlsDemoController
