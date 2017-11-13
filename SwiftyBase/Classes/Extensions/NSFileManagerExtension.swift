//
//  NSFileManagerExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

/// This extension adds some useful functions to NSFileManager
public extension FileManager {
    // MARK: - Enums -
    
    public static func createDirectory(at directoryURL: URL) throws {
        return try self.default.createDirectory(at: directoryURL)
    }
    
    public func createDirectory(at directoryUrl: URL) throws {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let fileExists = fileManager.fileExists(atPath: directoryUrl.path, isDirectory: &isDir)
        if fileExists == false || isDir.boolValue != false {
            try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public static func removeTemporaryFiles(at path: String) throws {
        return try self.default.removeTemporaryFiles()
    }
    
    public static var document: URL {
        return self.default.document
    }
    
    public var document: URL {
        #if os(OSX)
            // On OS X it is, so put files in Application Support. If we aren't running
            // in a sandbox, put it in a subdirectory based on the bundle identifier
            // to avoid accidentally sharing files between applications
            var defaultURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            if ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] == nil {
                var identifier = Bundle.main.bundleIdentifier
                if identifier?.length == 0 {
                    identifier = Bundle.main.executableURL?.lastPathComponent
                }
                defaultURL = defaultURL?.appendingPathComponent(identifier ?? "", isDirectory: true)
            }
            return defaultURL ?? URL(fileURLWithPath: "")
        #else
            // On iOS the Documents directory isn't user-visible, so put files there
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        #endif
    }
    
    
    
    public func removeTemporaryFiles() throws {
        let contents = try contentsOfDirectory(atPath: NSTemporaryDirectory())
        for file in contents {
            try removeItem(atPath: NSTemporaryDirectory() + file)
        }
    }
    
    public static func removeDocumentFiles(at path: String) throws {
        return try self.default.removeDocumentFiles()
    }
    
    public func removeDocumentFiles() throws {
        let documentPath = document.path
        let contents = try contentsOfDirectory(atPath: documentPath)
        for file in contents {
            try removeItem(atPath: documentPath + file)
        }
    }
    
    /**
     Directory type enum
     
     - MainBundle: Main bundle directory
     - Library:    Library directory
     - Documents:  Documents directory
     - Cache:      Cache directory
     */
    public enum DirectoryType : Int {
        case MainBundle
        case Library
        case Documents
        case Cache
    }
    
    // MARK: - Class functions -
    
    /**
     Read a file an returns the content as String
     
     - parameter file:   File name
     - parameter ofType: File type
     
     - returns: Returns the content of the file a String
     */
    public static func readTextFile(file: String, ofType: String) throws -> String? {
        return try String(contentsOfFile: Bundle.main.path(forResource: file, ofType: ofType)!, encoding: String.Encoding.utf8)
    }
    
    /**
     Save a given array into a PLIST with the given filename
     
     - parameter directory: Path of the PLIST
     - parameter filename:  PLIST filename
     - parameter array:     Array to save into PLIST
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func saveArrayToPath(directory: DirectoryType, filename: String, array: Array<AnyObject>) -> Bool {
        var finalPath: String
        
        switch directory {
        case .MainBundle:
            finalPath = self.getBundlePathForFile(file: "\(filename).plist")
        case .Library:
            finalPath = self.getLibraryDirectoryForFile(file: "\(filename).plist")
        case .Documents:
            finalPath = self.getDocumentsDirectoryForFile(file: "\(filename).plist")
        case .Cache:
            finalPath = self.getCacheDirectoryForFile(file: "\(filename).plist")
        }
        
        return NSKeyedArchiver.archiveRootObject(array, toFile: finalPath)
    }
    
    /**
     Load array from a PLIST with the given filename
     
     - parameter directory: Path of the PLIST
     - parameter filename:  PLIST filename
     
     - returns: Returns the loaded array
     */
    public static func loadArrayFromPath(directory: DirectoryType, filename: String) -> AnyObject? {
        var finalPath: String
        
        switch directory {
        case .MainBundle:
            finalPath = self.getBundlePathForFile(file: filename)
        case .Library:
            finalPath = self.getLibraryDirectoryForFile(file: filename)
        case .Documents:
            finalPath = self.getDocumentsDirectoryForFile(file: filename)
        case .Cache:
            finalPath = self.getCacheDirectoryForFile(file: filename)
        }
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: finalPath) as AnyObject?
    }
    
    /**
     Get the Bundle path for a filename
     
     - parameter file: Filename
     
     - returns: Returns the path as a String
     */
    public static func getBundlePathForFile(file: String) -> String {
        let fileExtension = file.pathExtension
        var stringdata = ""
        do {
            stringdata = try Bundle.main.path(forResource: file.stringByReplacingWithRegex(regexString: String(format: ".%@", file) as NSString, withString: "") as String, ofType: fileExtension)!
            
        }
        catch _ {
            // Error handling
        }
        return stringdata
        
    }
    
    /**
     Get the Documents directory for a filename
     
     - parameter file: Filename
     
     - returns: Returns the directory as a String
     */
    public static func getDocumentsDirectoryForFile(file: String) -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsDirectory.stringByAppendingPathComponent(path: String(format: "%@/", file))
    }
    
    /**
     Get the Library directory for a filename
     
     - parameter file: Filename
     
     - returns: Returns the directory as a String
     */
    public static func getLibraryDirectoryForFile(file: String) -> String {
        let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        return libraryDirectory.stringByAppendingPathComponent(path: String(format: "%@/", file))
    }
    
    /**
     Get the Cache directory for a filename
     
     - parameter file: Filename
     
     - returns: Returns the directory as a String
     */
    public static func getCacheDirectoryForFile(file: String) -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return cacheDirectory.stringByAppendingPathComponent(path: String(format: "%@/", file))
    }
    
    /**
     Returns the size of the file
     
     - parameter file:      Filename
     - parameter directory: Directory of the file
     
     - returns: Returns the file size
     */
    public static func fileSize(file: String, fromDirectory directory: DirectoryType) throws -> NSNumber? {
        if file.count != 0 {
            var path: String
            
            switch directory {
            case .MainBundle:
                path = self.getBundlePathForFile(file: file)
            case .Library:
                path = self.getLibraryDirectoryForFile(file: file)
            case .Documents:
                path = self.getDocumentsDirectoryForFile(file: file)
            case .Cache:
                path = self.getCacheDirectoryForFile(file: file)
            }
            
            if FileManager.default.fileExists(atPath: path) {
                let fileAttributes: NSDictionary? = try FileManager.default.attributesOfItem(atPath: file) as NSDictionary?
                if let _fileAttributes = fileAttributes {
                    return NSNumber(value: _fileAttributes.fileSize())
                }
            }
        }
        
        return nil
    }
    
    /**
     Delete a file with the given filename
     
     - parameter file:      Filename to delete
     - parameter directory: Directory of the file
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func deleteFile(file: String, fromDirectory directory: DirectoryType) throws -> Bool {
        if file.count != 0 {
            var path: String
            
            switch directory {
            case .MainBundle:
                path = self.getBundlePathForFile(file: file)
            case .Library:
                path = self.getLibraryDirectoryForFile(file: file)
            case .Documents:
                path = self.getDocumentsDirectoryForFile(file: file)
            case .Cache:
                path = self.getCacheDirectoryForFile(file:file)
            }
            
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    return true
                } catch {
                    return false
                }
            }
        }
        
        return false
    }
    
    /**
     Move a file from a directory to another
     
     - parameter file:        Filename to move
     - parameter origin:      Origin directory of the file
     - parameter destination: Destination directory of the file
     - parameter folderName:  Folder name where to move the file. If folder not exist it will be created automatically
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func moveLocalFile(file: String, fromDirectory origin: DirectoryType, toDirectory destination: DirectoryType, withFolderName folderName: String? = nil) throws -> Bool {
        var originPath: String
        
        switch origin {
        case .MainBundle:
            originPath = self.getBundlePathForFile(file: file)
        case .Library:
            originPath = self.getLibraryDirectoryForFile(file: file)
        case .Documents:
            originPath = self.getDocumentsDirectoryForFile(file: file)
        case .Cache:
            originPath = self.getCacheDirectoryForFile(file: file)
        }
        
        var destinationPath: String = ""
        if folderName != nil {
            destinationPath = String(format: "%@/%@", destinationPath, folderName!)
        } else {
            destinationPath = file
        }
        
        switch destination {
        case .MainBundle:
            destinationPath = self.getBundlePathForFile(file: destinationPath)
        case .Library:
            destinationPath = self.getLibraryDirectoryForFile(file: destinationPath)
        case .Documents:
            destinationPath = self.getDocumentsDirectoryForFile(file: destinationPath)
        case .Cache:
            destinationPath = self.getCacheDirectoryForFile(file: destinationPath)
        }
        
        if folderName != nil {
            let folderPath: String = String(format: "%@/%@", destinationPath, folderName!)
            if !FileManager.default.fileExists(atPath: originPath) {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
            }
        }
        
        var copied: Bool = false, deleted: Bool = false
        if FileManager.default.fileExists(atPath: originPath) {
            do {
                try FileManager.default.copyItem(atPath: originPath, toPath: destinationPath)
                copied = true
            } catch {
                copied = false
            }
        }
        
        if destination != .MainBundle {
            if FileManager.default.fileExists(atPath: originPath) {
                do {
                    try FileManager.default.removeItem(atPath: originPath)
                    deleted = true
                } catch {
                    deleted = false
                }
            }
        }
        
        if copied && deleted {
            return true
        }
        return false
    }
    
    
    /**
     Move a file from a directory to another
     
     - parameter file:        Filename to move
     - parameter origin:      Origin directory of the file
     - parameter destination: Destination directory of the file
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    @available(*, obsoleted: 1.2.0, message: "Use moveLocalFile(_, fromDirectory:, toDirectory:, withFolderName:)")
    public static func moveLocalFile(file: String, fromDirectory origin: DirectoryType, toDirectory destination: DirectoryType) throws -> Bool {
        return try self.moveLocalFile(file: file, fromDirectory: origin, toDirectory: destination, withFolderName: nil)
    }
    
    /**
     Duplicate a file into another directory
     
     - parameter origin:      Origin path
     - parameter destination: Destination path
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func duplicateFileAtPath(origin: String, toNewPath destination: String) -> Bool {
        if FileManager.default.fileExists(atPath: origin) {
            do {
                try FileManager.default.copyItem(atPath: origin, toPath: destination)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    /**
     Rename a file with another filename
     
     - parameter origin:  Origin path
     - parameter path:    Subdirectory path
     - parameter oldName: Old filename
     - parameter newName: New filename
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func renameFileFromDirectory(origin: DirectoryType, atPath path: String, withOldName oldName: String, andNewName newName: String) -> Bool {
        var originPath: String
        
        switch origin {
        case .MainBundle:
            originPath = self.getBundlePathForFile(file: path)
        case .Library:
            originPath = self.getLibraryDirectoryForFile(file: path)
        case .Documents:
            originPath = self.getDocumentsDirectoryForFile(file: path)
        case .Cache:
            originPath = self.getCacheDirectoryForFile(file: path)
        }
        
        if FileManager.default.fileExists(atPath: originPath) {
            
            var newNamePath: String = ""
            
            do {
                newNamePath = try originPath.stringByReplacingWithRegex(regexString: oldName as NSString, withString: newName as NSString) as String
                try FileManager.default.copyItem(atPath: originPath, toPath: newNamePath)
                do {
                    try FileManager.default.removeItem(atPath: originPath)
                    return true
                } catch {
                    return false
                }
                
            } catch {
                return false
            }
        }
        return false
    }
    
    /**
     Get the given settings for a given key
     
     - parameter settings:     Settings filename
     - parameter objectForKey: Key to set the object
     
     - returns: Returns the object for the given key
     */
    public static func getSettings(settings: String, objectForKey: String) -> AnyObject? {
        var path: String = self.getLibraryDirectoryForFile(file: "")
        path = path.stringByAppendingPathExtension(ext: "/Preferences/")!
        path = path.stringByAppendingPathExtension(ext: "\(settings)-Settings.plist")!
        
        var loadedPlist: NSMutableDictionary
        if FileManager.default.fileExists(atPath: path) {
            loadedPlist = NSMutableDictionary(contentsOfFile: path)!
        } else {
            return nil
        }
        
        return loadedPlist.object(forKey: objectForKey) as AnyObject?
    }
    
    /**
     Set the given settings for a given object and key. The file will be saved in the Library directory
     
     - parameter settings: Settings filename
     - parameter object:   Object to set
     - parameter objKey:   Key to set the object
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func setSettings(settings: String, object: AnyObject, forKey objKey: String) -> Bool {
        
        var path: String = self.getLibraryDirectoryForFile(file: "")
        path = path.stringByAppendingPathExtension(ext: "/Preferences/")!
        path = path.stringByAppendingPathExtension(ext: "\(settings)-Settings.plist")!
        
        
        var loadedPlist: NSMutableDictionary
        if FileManager.default.fileExists(atPath: path) {
            loadedPlist = NSMutableDictionary(contentsOfFile: path)!
        } else {
            loadedPlist = NSMutableDictionary()
        }
        
        loadedPlist[objKey] = object
        
        return loadedPlist.write(toFile: path, atomically: true)
    }
    
    /**
     Set the App settings for a given object and key. The file will be saved in the Library directory
     
     - parameter object: Object to set
     - parameter objKey: Key to set the object
     
     - returns: Returns true if the operation was successful, otherwise false
     */
    public static func setAppSettingsForObject(object: AnyObject, forKey objKey: String) -> Bool {
        return self.setSettings(settings: App.name, object: object, forKey: objKey)
    }
    
    /**
     Get the App settings for a given key
     
     - parameter objKey: Key to get the object
     
     - returns: Returns the object for the given key
     */
    public static func getAppSettingsForObjectWithKey(objKey: String) -> AnyObject? {
        return self.getSettings(settings: App.name, objectForKey: objKey)
    }
    
    
    /**
     Get URL of Document directory.
     
     - returns: Document directory URL.
     */
    class func ts_documentURL() -> URL {
        return ts_URLForDirectory(.documentDirectory)!
    }
    
    /**
     Get String of Document directory.
     
     - returns: Document directory String.
     */
    class func ts_documentPath() -> String {
        return ts_pathForDirectory(.documentDirectory)!
    }
    
    /**
     Get URL of Library directory
     
     - returns: Library directory URL
     */
    class func ts_libraryURL() -> URL {
        return ts_URLForDirectory(.libraryDirectory)!
    }
    
    /**
     Get String of Library directory
     
     - returns: Library directory String
     */
    class func ts_libraryPath() -> String {
        return ts_pathForDirectory(.libraryDirectory)!
    }
    
    /**
     Get URL of Caches directory
     
     - returns: Caches directory URL
     */
    class func ts_cachesURL() -> URL {
        return ts_URLForDirectory(.cachesDirectory)!
    }
    
    /**
     Get String of Caches directory
     
     - returns: Caches directory String
     */
    class func ts_cachesPath() -> String {
        return ts_pathForDirectory(.cachesDirectory)!
    }
    
    /**
     Adds a special filesystem flag to a file to avoid iCloud backup it.
     
     - parameter filePath: Path to a file to set an attribute.
     */
    class func ts_addSkipBackupAttributeToFile(_ filePath: String) {
        let url: URL = URL(fileURLWithPath: filePath)
        do {
            try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
        } catch {}
    }
    
    /**
     Check available disk space in MB
     
     - returns: Double in MB
     */
    class func ts_availableDiskSpaceMb() -> Double {
        let fileAttributes = try? `default`.attributesOfFileSystem(forPath: ts_documentPath())
        if let fileSize = (fileAttributes![FileAttributeKey.systemSize] as AnyObject).doubleValue {
            return fileSize / Double(0x100000)
        }
        return 0
    }
    
    fileprivate class func ts_URLForDirectory(_ directory: FileManager.SearchPathDirectory) -> URL? {
        return `default`.urls(for: directory, in: .userDomainMask).last
    }
    
    fileprivate class func ts_pathForDirectory(_ directory: FileManager.SearchPathDirectory) -> String? {
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
    }
}
