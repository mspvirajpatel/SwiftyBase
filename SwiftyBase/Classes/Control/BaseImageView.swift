//
//  BaseImageView.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

/**
 This is list of ImageView Type which are define in BaseImageView Class. We can add new type in this and handle in BaseImageView.
 */
public enum BaseImageViewType: Int {

    case unknown = -1
    case profile = 1
    case logo = 2
    case defaultImg = 3
}

public enum LoadingImageState {
    case Idle
    case Downloading
    case Errored(URLSessionDownloadTask, NSError)
}

/**
 This class used to Create ImageView object and set image. We can use used this class as base ImageView in Whole Application.
 */
open class BaseImageView: UIImageView {

    // MARK: - Attributes -

    /// Its type Of ImageView. Default is unknown
    open var imageViewType: BaseImageViewType = .unknown

    open var progressIndicatorView = BaseCircularLoader(frame: CGRect.zero)

    open var loadstate: LoadingImageState!

    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /**
     Its Initialize method of BaseImageView.
     - parameter type its type of imageview like profile,logo etc..
     - parameter superView its object of imageView's superView. Its can be null. When it's not null than imageview will added as subview in SuperView object
     */
    public init(type: BaseImageViewType, superView: UIView?) {
        super.init(frame: CGRect.zero)

        imageViewType = type

        self.setCommonProperties()
        self.setlayout()

        if(superView != nil) {
            superView?.addSubview(self)
        }
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        self.progressIndicatorView.frame.origin = self.center

        switch imageViewType {
        case .defaultImg:

            break

        default:
            break
        }
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit {

    }

    // MARK: - Layout -
    /**
     This method is used to Set the Common proparty of ImageView as per Type like ContentMode,Border,tag,Backgroud color etc...
     */
    open func setCommonProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false

        switch imageViewType {

        case BaseImageViewType.profile:

            self.contentMode = .scaleAspectFit
            self.layoutSubviews()

            break

        case BaseImageViewType.logo:

            self.contentMode = .scaleAspectFit
            self.setBorder(AppColor.border.withAlpha(0.5), width: 0.0, radius: 2.0)
            self.clipsToBounds = true
            self.tag = 0
            self.isUserInteractionEnabled = true
            self.translatesAutoresizingMaskIntoConstraints = false

            break

        case BaseImageViewType.defaultImg:

            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            self.translatesAutoresizingMaskIntoConstraints = false

            break

        default:
            break
        }

    }

    /// This method is used to Set the layout related things as per type like ImageView Height, width etc..
    open func setlayout() {


    }

    // MARK: - Public Interface -

    // MARK: - User Interaction -



    // MARK: - Internal Helpers -

}

public extension BaseImageView {

//    /**
//     This imethod is Used to Set the image from Url.Its will set the Image when download complete meanwhile its show placeholder image on imageview. or progress bar.
//     - parameter urlString: URL of image.
//     */
//
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { () -> Void in
//                self.image = image
//            }
//            }.resume()
//    }
//
//    public func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }
//
//    public func displayImageFromURL(_ urlString: String){
//
//        if let url = NSURL(string: urlString) {
//            if let data = NSData(contentsOf: url as URL) {
//                self.image = UIImage(data: data as Data)
//            }
//        }
//    }

    //For Loading

    func setImageURL(_ url: String) {
        _ = self.setImageFromURL(url) { (value) in

            print("Image : \(value)")

        }
    }

    /**
     set image url and it will download automatically
     
     - parameters:
     - url: Download Image URL
     - returns:
     `ImageDownload` for pause,cancel the download
     */
    func setImageFromURL(_ url: String) -> ImageDownload {
        return self.setImageFromURL(url, placeholder: nil, progress: nil, completion: nil)
    }

    /**
     set image url and it will download automatically
     - parameters:
     - url: Download Image URL
     - placeholder: Before downloading image , showing the placeholder
     - returns:
     `ImageDownloader` for pause,cancel the download
     */

    func setImageFromURL(_ url: String, placeholder: UIImage?) -> ImageDownload {
        return self.setImageFromURL(url, placeholder: placeholder, progress: nil, completion: nil)
    }

    /**
     set image url and it will download automatically
     - parameters:
     - url: Download Image URL
     - progress: Callback function for progress. It will include Float value 0 to 1.
     - returns:
     `ImageDownload` for pause,cancel the download
     */

    func setImageFromURL(_ url: String, progress: ((_ value: Float) -> Void)?) -> ImageDownload {
        return self.setImageFromURL(url, placeholder: nil, progress: progress, completion: nil)
    }

    /**
     set image url and it will download automatically
     - parameters:
     - url: Download Image URL
     - placeholder: Before downloading image , showing the placeholder
     - progress: Callback function for progress. It will include Float value 0 to 1.
     - returns:
     `ImageDownloader` for pause,cancel the download
     */

    func setImageFromURL(_ url: String, placeholder: UIImage?, progress: ((_ value: Float) -> Void)?) -> ImageDownload {
        return self.setImageFromURL(url, placeholder: placeholder, progress: progress, completion: nil)
    }

    /**
     set image url and it will download automatically
     - parameters:
     - url: Download Image URL
     - placeholder: Before downloading image , showing the placeholder
     - progress: Callback function for progress. It will include Float value 0 to 1.
     - returns:
     `ImageDownloader` for pause,cancel the download
     */

    func setImageFromURL(_ url: String, progress: ((_ value: Float) -> Void)?, completion: ((UIImage?, Bool) -> Void)?) -> ImageDownload {

        return self.setImageFromURL(url, placeholder: nil, progress: progress, completion: completion)

    }

    /**
     set image url and it will download automatically
     - parameters:
     - url: Download Image URL
     - placeholder: Before downloading image , showing the placeholder
     - progress: Callback function for progress. It will include Float value 0 to 1.
     - completion: Callback function , it will call when download finish. Value will include image:UIImage? and success:Bool
     - returns:
     `ImageDownloader` for pause,cancel the download
     */

    func setImageFromURL(_ url: String, placeholder: UIImage?, progress: ((_ value: Float) -> Void)?, completion: ((_ image: UIImage?, _ success: Bool) -> Void)?) -> ImageDownload {

        progressIndicatorView.layoutSubviews()
        self.progressIndicatorView.frame.origin = self.center
        self.progressIndicatorView.frame = CGRect.init(x: self.progressIndicatorView.frame.origin.x, y: self.progressIndicatorView.frame.origin.y, width: 20.0, height: 20.0)

        addSubview(self.progressIndicatorView)

        self.layoutSubviews()

        self.image = placeholder

        let downloader = ImageDownload()

        downloader.downloadImageWithProgress(url, progress: progress, completion: {
            (image, success) in

            self.progressIndicatorView.reveal()
            self.loadstate = LoadingImageState.Idle

            DispatchQueue.main.async {
                let animation = CATransition()
                animation.duration = 0.23
                animation.type = CATransitionType.fade
                animation.isRemovedOnCompletion = true
                self.layer.add(animation, forKey: "transition")
                self.image = image
                if let callback = completion {
                    callback(image, success)
                }
            }

        })

        return downloader

    }

}

public class ImageDownload: NSObject {

    var downloadTask: URLSessionDownloadTask?
    var downloadImageURL: String = ""
    var backgroundSession: URLSession!

    var completionCallback: ((UIImage?, Bool) -> Void)?
    var progressCallback: ((Float) -> Void)?

    /**
     Download Image with async
     - parameters:
     - url: Download Image URL
     - placeholder: Before downloading image , showing the placeholder
     - progress: Callback function for progress. It will include Float value 0 to 1.
     - completion: Callback function , it will call when download finish. Value will include image:UIImage? and success:Bool
     */
    public func downloadImageWithProgress(_ url: String, progress: ((Float) -> Void)?, completion: ((UIImage?, Bool) -> Void)?) {

        if url == "" {
            if let callback = completion {
                callback(nil, false)
            }
            return
        }

        if let cacheImage = self.getImageWithURL(url) {

            if let callback = completion {
                callback(cacheImage, true)
            }

            return
        }

        self.progressCallback = progress
        self.completionCallback = completion


        if let imgURL = URL(string: url)
            {

            let identifier = "\(self.urlHash(url))\(self.randomString(length: 4))"

            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: identifier)

            backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)

            downloadImageURL = url
            downloadTask = backgroundSession.downloadTask(with: imgURL)
            downloadTask?.resume()
        }
    }

    /**
     Delete image in cached folder
     - parameters:
     - url: Downloaded Image URL
     */
    public func deleteCacheImage(_ url: String) {

        if let path = self.imagePathAtURL(url) {
            let fManager = FileManager.default
            if fManager.fileExists(atPath: path) {
                do {
                    try fManager.removeItem(atPath: path)
                }
                catch {
                    print ("delete image error")
                }
            }
        }

    }

    func saveImage(_ data: Data, name: String) {
        if let file = self.imagePathAtURL(name) {

            do {
                try data.write(to: URL(fileURLWithPath: file), options: .atomicWrite)
            }
            catch let error as NSError
            {
                print("Error :- \(error.localizedDescription)")
            }
        }
    }

    func getImageWithURL(_ url: String) -> UIImage? {

        if let filepath = self.imagePathAtURL(url) {



            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: filepath)) {

                return UIImage(data: imageData)
            }
        }

        return nil
    }

    func urlHash(_ url: String) -> String {

        var hash = url.hashValue

        if hash < 0 {
            hash = hash * -1
        }
        return "\(hash)"
    }

    func imagePathAtURL(_ url: String) -> String? {

        var cacheFolder: NSString! = ""

        let documentDirs: NSString! = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString

        if let documentDir = documentDirs {
            cacheFolder = documentDir.appendingPathComponent("cached") as NSString
            var directory: ObjCBool = false

            if(!FileManager.default.fileExists(atPath: cacheFolder as String, isDirectory: &directory)) {
                if (!directory.boolValue) {
                    do {
                        try FileManager.default.createDirectory(atPath: cacheFolder as String, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch {
                        print("folder create error")
                        return nil
                    }
                }
            }
        }

        let imageURL = self.urlHash(url)

        return cacheFolder.appendingPathComponent("\(imageURL).cqc")

    }


    /**
     Clear all image in cached folder of application support directory
     */

    public static func clearAllTheCachedImages() {

        let documentDir: NSString = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString
        let cachedFolder = documentDir.appendingPathComponent("cached")

        do {
            try FileManager.default.removeItem(atPath: cachedFolder)
        }
        catch {
            print ("cannot delete")
        }

    }


    /**
     Cancel the image download
     */

    public func cancelDownload() {

        self.downloadTask?.cancel()
    }

    /**
     Pause the image download
     */

    public func pauseDownload() {

        self.downloadTask?.suspend()

    }

    /**
     Resume the image download if suspend
     */

    public func resumeDownload() {
        self.downloadTask?.resume()
    }


    func randomString(length: Int) -> String {

        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}


extension ImageDownload: URLSessionDelegate {

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {

        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))

    }

}

extension ImageDownload: URLSessionDownloadDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        if let err = error, let callback = completionCallback {
            print(err.localizedDescription)
            callback(nil, false)
        }
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        if let file = self.imagePathAtURL(self.downloadImageURL) {

            let destURL = URL(fileURLWithPath: file)


            if let callback = self.completionCallback {
                do {
                    let d = try Data(contentsOf: location)
                    if d.count <= 0 {
                        callback(nil, false)
                        return
                    }


                    try d.write(to: destURL, options: .atomic)

                    let img = self.getImageWithURL(self.downloadImageURL)
                    callback(img, true)
                    return
                }
                catch {
                    callback(nil, false)
                }
            }
        }
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if let callback = self.progressCallback {
            callback(progress)
        }
    }
}



//Usage
//
//Download and Show
//
//imageView.setImageFromURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg")
//imageView.setImageFromURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg", placeholder: placeholderImage)
//Downloading with progress
//
//imageView.setImageFromURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg", placeholder: nil, progress: { (value: Float) in
//
//    //supporting progress
//    print(value)
//
//})
//Downloading with completion
//
//imageView.setImageFromURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg", placeholder: nil, progress: nil, completion: { (image:UIImage?, success:Bool) in
//
//    if (success) {
//
//    }
//
//})
//Clear Cache
//
//ImageDownload.clearAllTheCachedImages()
//var downloader = ImageDownloader()
//downloader.deleteCacheImage("file URL")
