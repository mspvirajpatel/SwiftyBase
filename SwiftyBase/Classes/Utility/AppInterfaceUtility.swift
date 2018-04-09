//
//  AppInterfaceUtility.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

import Foundation

open class AppInterfaceUtility: NSObject {

    public class func getDeviceScreenSize() -> CGSize {
        let screenBounds: CGRect = UIScreen.main.bounds
        return screenBounds.size
    }

    public class func getAppropriateSizeFromSize(_ iSize: CGSize, withDivision divider: CGFloat, andInterSpacing interSpacing: CGFloat) -> CGSize {

        let iWidth: CGFloat = iSize.width
        let iHeight: CGFloat = iSize.height

        var oWidth: CGFloat
        var oHeight: CGFloat

        if iWidth >= iHeight {

            oWidth = (iHeight - (interSpacing * (divider + 1))) / divider
            oHeight = oWidth

        } else {

            oWidth = (iWidth - (interSpacing * (divider + 1))) / divider
            oHeight = oWidth

        }

        let oSize: CGSize = CGSize(width: oWidth, height: oHeight)
        return oSize
    }

    public class func aspectScaledImageSizeForImageView(_ iv: UIImageView, image: UIImage) -> CGSize {

        var x: CGFloat
        var y: CGFloat

        var a: CGFloat
        var b: CGFloat

        x = iv.frame.size.width
        y = iv.frame.size.height

        a = image.size.width
        b = image.size.height

        if x == a && y == b {

        }
        else {
            if x > a && y > b {
                if x - a > y - b {
                    a = y / b * a
                    b = y
                }
                else {
                    b = x / a * b
                    a = x
                }
            }
            else {
                if x < a && y < b {
                    if a - x > b - y {
                        a = y / b * a
                        b = y
                    }
                    else {
                        b = x / a * b
                        a = x
                    }
                }
                else {
                    if x < a && y > b {
                        b = x / a * b
                        a = x
                    }
                    else {
                        if x > a && y < b {
                            a = y / b * a
                            b = y
                        }
                        else {
                            if x == a {
                                a = y / b * a
                                b = y
                            }
                            else {
                                if y == b {
                                    b = x / a * b
                                    a = x
                                }
                            }
                        }
                    }
                }
            }
        }
        return CGSize(width: a, height: b)
    }

    public class func cropImage(_ image: UIImage, fromRect rect: CGRect) -> UIImage {
        let imageRef: CGImage = image.cgImage!.cropping(to: rect)!
        let croppedImage: UIImage = UIImage(cgImage: imageRef)
        return croppedImage
    }

    public class func imageFromColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)

        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    public class func createImageFromView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)

        let context: CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)

        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return snapshotImage
    }

    public class func setCircleViewWith(_ borderColor: UIColor, width: CGFloat, ofView view: UIView) {

        view.layer.cornerRadius = (view.frame.size.width / 2)
        view.layer.masksToBounds = (true)
        view.layer.borderWidth = (width)
        view.layer.borderColor = (borderColor.cgColor)

        let containerLayer: CALayer = CALayer()
        containerLayer.shadowColor = UIColor.black.cgColor

        containerLayer.shadowRadius = 10.0
        containerLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        containerLayer.shadowOpacity = 1.0
        view.superview?.layer.addSublayer(containerLayer)
    }

    public class var currentRegion: String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    }

    /// MARK: Calls action when a screen shot is taken
    public static func detectScreenShot(_ action: @escaping () -> ()) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue) { notification in
            // executes after screenshot
            action()
        }
    }

    /// MARK: Downloads JSON from url string
    public static func requestJSON(_ url: String, success: @escaping ((Any?) -> Void), error: ((NSError) -> Void)?) {
        requestURL(url,
                   success: { (data) -> Void in
                       let json: Any? = self.dataToJsonDict(data)
                       success(json)
                   },
                   error: { (err) -> Void in
                       if let e = error {
                           e(err)
                       }
                   })
    }

    /// MARK: converts NSData to JSON dictionary
    public static func dataToJsonDict(_ data: Data?) -> Any? {
        if let d = data {
            var error: NSError?
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(
                    with: d,
                    options: JSONSerialization.ReadingOptions.allowFragments)
            } catch let error1 as NSError {
                error = error1
                json = nil
            }

            if let _ = error {
                return nil
            } else {
                return json
            }
        } else {
            return nil
        }
    }

    /// MARK:
    fileprivate static func requestURL(_ url: String, success: @escaping (Data?) -> Void, error: ((NSError) -> Void)? = nil) {
        guard let requestURL = URL(string: url) else {
            assertionFailure("EZSwiftExtensions Error: Invalid URL")
            return
        }

        URLSession.shared.dataTask(
            with: URLRequest(url: requestURL),
            completionHandler: { data, response, err in
                if let e = err {
                    error?(e as NSError)
                } else {
                    success(data)
                }
            }).resume()
    }
}
