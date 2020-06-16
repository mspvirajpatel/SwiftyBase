//
//  AppUtility.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//


import UIKit
import SystemConfiguration
import UserNotifications
import Photos
import SystemConfiguration.SCNetwork

open class AppUtility: NSObject {

    //  MARK: - Network Connection Methods

    public class func isNetworkAvailableWithBlock(_ completion: @escaping (_ wasSuccessful: Bool) -> Void) {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            completion(false)
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        completion(isReachable && !needsConnection)
    }

    public class func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: { (result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }

    public class func getDelegate() -> AnyObject? {
        return UIApplication.shared.delegate
    }

    public class func setPushNotificationEnabled(_ isEnabled: Bool) {

        let application = UIApplication.shared

        if isEnabled {

            if #available(iOS 10, *) {

                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in

                    guard error == nil else {
                        //Display Error.. Handle Error.. etc..
                        return
                    }

                    if granted {
                        //Do stuff here..
                    }
                    else {
                        //Handle user denying permissions..
                    }
                }

            }
            else {
                let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }

            //push notitification connection
            NSLog("Connected.")
        }
        else {
            if application.isRegisteredForRemoteNotifications {
                application.unregisterForRemoteNotifications()

            }
            //push notitification connection disconnect Code
            NSLog("Disconnected.")

        }
    }
    //  MARK: - User Defaults Methods

    public class func getUserDefaultsObjectForKey(_ key: String) -> AnyObject {
        let object: AnyObject? = UserDefaults.standard.object(forKey: key) as AnyObject?
        return object!
    }

    public class func setUserDefaultsObject(_ object: AnyObject, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }

    public class func clearUserDefaultsForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    public class func clearUserDefaults() {
        let appDomain: String = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }

    public class func getDocumentDirectoryPath() -> String
    {
        let arrPaths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        return arrPaths[0] as! String
    }

    public class func stringByPathComponet(fileName: String, Path: String) -> String
    {
        var tmpPath: NSString = Path as NSString
        tmpPath = tmpPath.appendingPathComponent(fileName) as NSString
        return tmpPath as String
    }

    //  MARK: - UIDevice Methods

    public class func getDeviceIdentifier() -> String {
        let deviceUUID: String = UIDevice.current.identifierForVendor!.uuidString
        return deviceUUID
    }

    //  MARK: - Misc Methods


    public class func generateOrderIDWithPrefix(_ prefix: String) -> String {

        srandom(UInt32(time(nil)))

        let randomNo: Int = Int(arc4random_uniform(UInt32(6)))//just randomizing the number
        let orderID: String = "\(prefix)\(randomNo)"
        return orderID

    }

    //    let persiontage = AppUtility.calculatePercentage(oldFigure: 1100, newFigure: 1000)
    //    print("Persiontag :  \(persiontage)")

    public class func calculatePercentage(oldFigure: Int, newFigure: Int) -> Int {

        let percentChange: Float?

        if ((oldFigure != 0) && (newFigure != 0)) {
            percentChange = (oldFigure.toFloat - newFigure.toFloat) / oldFigure.toFloat * 100
        }
        else {
            percentChange = 0.0
        }
        return Int(percentChange!)
    }


    //  MARK: - Time-Date Methods

    public class func convertDateToLocalTime(_ iDate: Date) -> Date {
        let timeZone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: Int = timeZone.secondsFromGMT(for: iDate)
        return Date(timeInterval: TimeInterval(seconds), since: iDate)
    }

    public class func convertDateToGlobalTime(_ iDate: Date) -> Date {
        let timeZone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: Int = -timeZone.secondsFromGMT(for: iDate)
        return Date(timeInterval: TimeInterval(seconds), since: iDate)
    }

    public class func getCurrentDateInFormat(_ format: String) -> String {

        let usLocale: Locale = Locale(identifier: "en_US")

        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateFormat = format

        timeFormatter.timeZone = TimeZone.autoupdatingCurrent
        timeFormatter.locale = usLocale

        let date: Date = Date()
        let stringFromDate: String = timeFormatter.string(from: date)

        return stringFromDate
    }

    public class func getDate(_ date: Date, inFormat format: String) -> String {

        let usLocale: Locale = Locale(identifier: "en_US")
        let timeFormatter: DateFormatter = DateFormatter()

        timeFormatter.dateFormat = format
        timeFormatter.timeZone = TimeZone.autoupdatingCurrent

        timeFormatter.locale = usLocale

        let stringFromDate: String = timeFormatter.string(from: date)

        return stringFromDate
    }


    public class func convertStringDateFromFormat(_ inputFormat: String, toFormat outputFormat: String, fromString dateString: String) -> String {

        let usLocale: Locale = Locale(identifier: "en_US")

        var dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = inputFormat

        dateFormatter = DateFormatter()
        let date: Date = dateFormatter.date(from: dateString)!

        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = outputFormat

        let resultedDateString: String = dateFormatter.string(from: date)

        return resultedDateString
    }

    public class func getTimeStampForCurrentTime() -> String {
        let timestampNumber: NSNumber = NSNumber(value: (Date().timeIntervalSince1970) * 1000 as Double)
        return timestampNumber.stringValue
    }

    public class func getTimeStampFromDate(_ iDate: Date) -> String {
        let timestamp: String = String(iDate.timeIntervalSince1970)
        return timestamp
    }

    public class func getCurrentTimeStampInGMTFormat() -> String {
        return AppUtility.getTimeStampFromDate(AppUtility.convertDateToGlobalTime(Date()))
    }

    //  MARK: - GCD Methods

    public class func executeTaskAfterDelay(_ delay: CGFloat, completion completionBlock: @escaping () -> Void)
    {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            completionBlock()
        }
    }

    public class func executeTaskInMainThreadAfterDelay(_ delay: CGFloat, completion completionBlock: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
            completionBlock()
        })
    }

    public class func executeTaskInGlobalQueueWithCompletion(_ completionBlock: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            completionBlock()
        })
    }

    public class func executeTaskInMainQueueWithCompletion(_ completionBlock: @escaping () -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            completionBlock()
        })
    }

    public class func executeTaskInGlobalQueueWithSyncCompletion(_ completionBlock: () -> Void) {
        DispatchQueue.global(qos: .default).sync(execute: { () -> Void in
            completionBlock()
        })
    }

    public class func executeTaskInMainQueueWithSyncCompletion(_ completionBlock: () -> Void) {
        DispatchQueue.main.sync(execute: { () -> Void in
            completionBlock()
        })
    }

    public static func synced(_ lock: AnyObject, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }

    //  MARK: - Data Validation Methods

    public class func isValidEmail(_ checkString: String) -> Bool {

        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"

        let emailRegex: String = laxString

        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailTest.evaluate(with: checkString)
    }

    public class func isValidPhone(_ phoneNumber: String) -> Bool {
        let phoneRegex: String = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }

    public class func isValidURL(_ candidate: String) -> Bool {
        let urlRegEx: String = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: candidate)
    }

    public class func isTextFieldBlank(_ textField: UITextField) -> Bool {
        return (textField.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
    }

    public class func isValidPhoneNoCountTen(_ mobileNo: String) -> Bool {
        return mobileNo.count == 10 ? true : false
    }

    class func isOnlyNumber (_ candidate: String) -> Bool {
        let urlRegEx: String = "^[0-9]+$"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: candidate)
    }

    class func isOnlyDecimal (_ candidate: String) -> Bool {
        let urlRegEx: String = "\\d+(\\.\\d{1,2})?"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: candidate)
    }

    class func isValiedHeight(_ height: String) -> Bool {
        let urlRegEx: String = "\\d{1,2}+(\\.\\d{1,2})?"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: height)
    }

    class func isValiedVirtical (_ candidate: String) -> Bool {
        let urlRegEx: String = "^[0-9]{1,3}+$"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: candidate)
    }


    class func isValiedWeight(_ height: String) -> Bool {
        let urlRegEx: String = "\\d{1,3}+(\\.\\d{1,2})?"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: height)
    }

    class func validateCharCount(_ name: String, minLimit: Int, maxLimit: Int) -> Bool {
        // check the name is between 4 and 16 characters
        if !(minLimit...maxLimit ~= name.count) {
            return false
        }
        return true
    }


    // check the name is between 4 and 16 characters
    public func validateCharCount(_ name: String, minLimit: Int, maxLimit: Int) -> Bool {
        if !(minLimit...maxLimit ~= name.count) {
            return false
        }
        return true
    }

    public func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }

    ///Change file size

    //myImageView.image = resizeImage(myImageView.image!, targetSize: CGSizeMake(600.0, 450.0))
    //
    //let imageData = UIImageJPEGRepresentation(myImageView.image!,0.50)

    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    public static let DownloadCompletedNotif: String = {
        return "com.AppDownloadManager.DownloadCompleted"
    }()

    public static let baseFilePath: String = {
        return (NSHomeDirectory() as NSString).appendingPathComponent("Documents") as String
    }()

    open class func getUniqueFileNameWithPath(_ filePath: NSString) -> NSString {
        let fullFileName: NSString = filePath.lastPathComponent as NSString
        let fileName: NSString = fullFileName.deletingPathExtension as NSString
        let fileExtension: NSString = fullFileName.pathExtension as NSString
        var suggestedFileName: NSString = fileName

        var isUnique: Bool = false
        var fileNumber: Int = 0

        let fileManger: FileManager = FileManager.default

        repeat {
            var fileDocDirectoryPath: NSString?

            if fileExtension.length > 0 {
                fileDocDirectoryPath = "\(filePath.deletingLastPathComponent)/\(suggestedFileName).\(fileExtension)" as NSString?
            } else {
                fileDocDirectoryPath = "\(filePath.deletingLastPathComponent)/\(suggestedFileName)" as NSString?
            }

            let isFileAlreadyExists: Bool = fileManger.fileExists(atPath: fileDocDirectoryPath! as String)

            if isFileAlreadyExists {
                fileNumber += 1
                suggestedFileName = "\(fileName)(\(fileNumber))" as NSString
            } else {
                isUnique = true
                if fileExtension.length > 0 {
                    suggestedFileName = "\(suggestedFileName).\(fileExtension)" as NSString
                }
            }

        } while isUnique == false

        return suggestedFileName
    }

    open class func calculateFileSizeInUnit(_ contentLength: Int64) -> Float {
        let dataLength: Float64 = Float64(contentLength)
        if dataLength >= (1024.0 * 1024.0 * 1024.0) {
            return Float(dataLength / (1024.0 * 1024.0 * 1024.0))
        } else if dataLength >= 1024.0 * 1024.0 {
            return Float(dataLength / (1024.0 * 1024.0))
        } else if dataLength >= 1024.0 {
            return Float(dataLength / 1024.0)
        } else {
            return Float(dataLength)
        }
    }

    open class func calculateUnit(_ contentLength: Int64) -> NSString {
        if(contentLength >= (1024 * 1024 * 1024)) {
            return "GB"
        } else if contentLength >= (1024 * 1024) {
            return "MB"
        } else if contentLength >= 1024 {
            return "KB"
        } else {
            return "Bytes"
        }
    }

    open class func addSkipBackupAttributeToItemAtURL(_ docDirectoryPath: NSString) -> Bool {
        let url: URL = URL(fileURLWithPath: docDirectoryPath as String)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {

            do {
                try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
                return true
            } catch let error as NSError {
                print("Error excluding \(url.lastPathComponent) from backup \(error)")
                return false
            }

        } else {
            return false
        }
    }

    open class func getFreeDiskspace() -> Int64? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let systemAttributes: AnyObject?
        do {
            systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last!) as AnyObject?
            let freeSize = systemAttributes?[FileAttributeKey.systemFreeSize] as? NSNumber
            return freeSize?.int64Value
        } catch let error as NSError {
            print("Error Obtaining System Memory Info: Domain = \(error.domain), Code = \(error.code)")
            return nil
        }
    }


    public class func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }

    public class func deviceTotalSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }

    public struct ByteStringOption: OptionSet {

        public let rawValue: Int

        static let Number = ByteStringOption(rawValue: 1 << 0)
        static let Unit = ByteStringOption(rawValue: 1 << 1)

        public init(rawValue: Int) {

            self.rawValue = rawValue
        }
    }



    public class func stringFromByte(byte: Int64?, displayOptions: ByteStringOption) -> String {

        let byteFormatter = ByteCountFormatter()

        if let byt = byte {

            byteFormatter.countStyle = .decimal
            byteFormatter.includesCount = false
            byteFormatter.includesUnit = false

            if displayOptions.contains(.Number) {

                byteFormatter.includesCount = true
            }

            if displayOptions.contains(.Unit) {

                byteFormatter.includesUnit = true
            }

            return byteFormatter.string(fromByteCount: byt)
        }

        return "Unkonw"

    }

    class func documentPath() -> String {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        return documentsPath
    }

    public class func imageWithBottomShadow(size: CGSize, imageColor: UIColor, shadowColor: UIColor, shadowHeight: CGFloat) -> UIImage {

        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = CGRect(x: 0, y: size.height - shadowHeight, width: size.width, height: shadowHeight)
        shadowLayer.backgroundColor = shadowColor.cgColor
        view.backgroundColor = imageColor
        view.layer.addSublayer(shadowLayer)

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

    class func saveFile(text: String, to fileNamed: String, folder: String = "ATP45") -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return nil }
        do {
            try FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        } catch let error as NSError {
            dLog("Unable to create directory \(error.debugDescription)")
        }

        let file: URL = writePath.appendingPathComponent(fileNamed + ".txt")

        if File.exists(path: file) {
            do {
                try FileManager.default.removeItem(at: file)
                return File.write(path: file, content: text)
            }
            catch let error as NSError {
                dLog("Unable to create directory \(error.debugDescription)")
                return nil
            }

        } else {
            return File.write(path: file, content: text)
        }
    }

    class func readFromDocumentsFile(fileName: String) -> String? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent("ATP45") else { return nil }

        let file = writePath.appendingPathComponent(fileName + ".txt")

        if File.exists(path: file) {
            return File.read(path: file)
        } else {
            //files = "*ERROR* \(fileName) does not exist."
            return nil
        }
    }

    // MARK: - Get IP Address of Device

    //    class func getIFAddresses() -> [String]
    //    {
    //        var addresses = [String]()
    //
    //        // Get list of all interfaces on the local machine:
    //        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    //        if getifaddrs(&ifaddr) == 0
    //        {
    //            // For each interface ...
    //            while ifaddr != nil
    //            {
    //                let ptr = ifaddr
    //                let flags = Int32((ptr?.pointee.ifa_flags)!)
    //                var addr = ptr?.pointee.ifa_addr.pointee
    //
    //                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
    //                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
    //                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6)
    //                    {
    //                        // Convert interface address to a human readable string:
    //                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
    //                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
    //                                        nil, socklen_t(0), NI_NUMERICHOST) == 0)
    //                        {
    //                            addresses.append(String.init(cString: hostname))
    //                        }
    //                    }
    //                }
    //                ifaddr = ptr?.pointee.ifa_next
    //            }
    //            freeifaddrs(ifaddr)
    //        }
    //        return addresses
    //    }

}
