//
//  App.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation
import UIKit
import Foundation

/// Used to store the HasBeenOpened in defaults
private let HasBeenOpened = "HasBeenOpened"
/// Used to store the HasBeenOpenedForCurrentVersion in defaults
private let HasBeenOpenedForCurrentVersion = "\(HasBeenOpened)\(App.version)"

// MARK: - Global functions -

/// Get AppDelegate (To use it, cast to AppDelegate with "as! AppDelegate")
let APP_DELEGATE: UIApplicationDelegate? = UIApplication.shared.delegate

/// This class adds some useful functions for the App
public class App {
    // MARK: - Class functions -

    /**
     Executes a block only if in DEBUG mode
     
     - parameter block: The block to be executed
     */
    public static func debugBlock(block: () -> ()) {
        #if DEBUG
            block()
        #endif
    }

    /**
     Executes a block on first start of the App.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStart
     */
    public static func onFirstStart(block: (_ isFirstStart: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: HasBeenOpened)
        if hasBeenOpened != true {
            defaults.set(true, forKey: HasBeenOpened)
            defaults.synchronize()
        }

        block(!hasBeenOpened)
    }

    /**
     Executes a block on first start of the App for current version.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStartForCurrentVersion
     */
    public static func onFirstStartForCurrentVersion(block: (_ isFirstStartForCurrentVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: HasBeenOpenedForCurrentVersion)
        if hasBeenOpenedForCurrentVersion != true {
            defaults.set(true, forKey: HasBeenOpenedForCurrentVersion)
            defaults.synchronize()
        }

        block(!hasBeenOpenedForCurrentVersion)
    }

    /**
     Executes a block on first start of the App for current given version.
     Remember to execute UI instuctions on main thread
     
     - parameter version: Version to be checked
     - parameter block:   The block to execute, returns isFirstStartForVersion
     */
    public static func onFirstStartForVersion(version: String, block: (_ isFirstStartForVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForVersion: Bool = defaults.bool(forKey: HasBeenOpened + "\(version)")
        if hasBeenOpenedForVersion != true {
            defaults.set(true, forKey: HasBeenOpened + "\(version)")
            defaults.synchronize()
        }

        block(!hasBeenOpenedForVersion)
    }

    /// Returns if is the first start of the App
    public static var isFirstStart: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: HasBeenOpened)
        if hasBeenOpened != true {
            return true
        } else {
            return false
        }
    }

    /// Returns if is the first start of the App for current version
    public static var isFirstStartForCurrentVersion: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: HasBeenOpenedForCurrentVersion)
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }

    /**
     Returns if is the first start of the App for the given version
     
     - parameter version: Version to be checked
     
     - returns: Returns if is the first start of the App for the given version
     */
    public static func isFirstStartForVersion(version: String) -> Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: HasBeenOpened + "\(version)")
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }
}

public extension App {

    public static var name: String = { return App.string(forKey: "CFBundleName") }()
    public static var version: String = { return App.string(forKey: "CFBundleShortVersionString") }()
    public static var build: String = { return App.string(forKey: "CFBundleVersion") }()
    public static var executable: String = { return App.string(forKey: "CFBundleExecutable") }()
    public static var bundle: String = { return App.string(forKey: "CFBundleIdentifier") }()

    private static func string(forKey key: String) -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let value = infoDictionary[key] as? String else { return "" }

        return value
    }
}
