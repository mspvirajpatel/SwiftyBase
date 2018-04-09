//
//  File.swift
//  SwiftyBase
//
//  Created by Viraj Patel on 13/11/17.
//

import Foundation
import UIKit

class File {

    class func exists (path: URL) -> Bool {
        return FileManager().fileExists(atPath: path.path)
    }

    class func read (path: URL, encoding: String.Encoding = String.Encoding.utf8) -> String? {
        if File.exists(path: path) {
            do {
                // Read the file contents
                return try String(contentsOf: path)
            } catch let error as NSError {
                dLog("Failed reading from URL: \(path), Error: " + error.localizedDescription)
                return nil
            }
        }

        return nil
    }

    class func write (path: URL, content: String, encoding: String.Encoding = String.Encoding.utf8) -> URL? {
        do {
            try content.write(to: path, atomically: false, encoding: encoding)
            dLog("Save file path : \(path)")
            return path
        }
        catch {
            return nil
        }
    }
}
