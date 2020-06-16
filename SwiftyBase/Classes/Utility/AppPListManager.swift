//
//  AppPlistManager.swift
//  Pods
//
//  Created by MacMini-2 on 06/09/17.
//
//

import Foundation
import UIKit

open class AppPlistManager: NSObject {

    // MARK: - Attributes -

    // MARK: - Lifecycle -

    // MARK: - Lifecycle -

    public static let shared: AppPlistManager = {

        let instance = AppPlistManager()
        return instance
    }()

    deinit {

    }

    // MARK: - Public Interface -

    public func readFromPlist(_ fileName: String) -> AnyObject
    {
        let paths = Bundle.main.path(forResource: fileName, ofType: "plist")
        print(paths!)

        var plistData: AnyObject!

        do {
            let fileData: Data = try Data(contentsOf: URL(fileURLWithPath: paths!))

            plistData = try PropertyListSerialization .propertyList(from: fileData, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as AnyObject?
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return plistData
    }

    // MARK: - Internal Helpers -

    public func createPlistFromFileName(_ fileName: String, overRide: Bool)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName + ".plist")

        print(path)

        let fileManager = FileManager.default

        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "plist") {

                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                } catch _ {

                }
                print("copy")
            } else {
                print("plist not found. Please, make sure it is part of the bundle.")
            }
        } else {

            if overRide
                {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch _ {

                }

                if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "plist") {

                    do {
                        try fileManager.copyItem(atPath: bundlePath, toPath: path)
                    } catch _ {

                    }
                    print("copy")
                } else {
                    print("plist not found. Please, make sure it is part of the bundle.")
                }

            }
            print("plist already exits at path.")
        }
    }

    func savePlistData(_ fileName: String, parametres: NSDictionary) {

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName + ".plist")

        //writing to plist
        parametres.write(toFile: path, atomically: false)

        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved plist file is --> \(String(describing: resultDictionary?.description))")
    }

    func savePlistArray(_ fileName: String, parametres: NSArray) {

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName + ".plist")

        //writing to plist
        parametres.write(toFile: path, atomically: false)

        let resultDictionary = NSArray(contentsOfFile: path)
        print("Saved plist file is --> \(String(describing: resultDictionary?.description))")
    }
}
