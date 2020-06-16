//
//  AppImageUploadManager.swift
//  Pods
//
//  Created by MacMini-2 on 06/09/17.
//
//

import Foundation
import UIKit

private var _baseImageUploadURL: String! = ""
private var _imagename: String! = "source"

open class AppImageUploadManager: NSObject
{
    // MARK: - Attributes -

    fileprivate var isUploadingRunning: Bool = false
    fileprivate var documentPath: String? = ""
    fileprivate var uploadImageDirectoryPath: String? = ""
    fileprivate var fileManager: FileManager?
    fileprivate var updateUploadStatus: TaskFinishedEvent?
    fileprivate var totalUploadedImage: Int = 0
    fileprivate var totalImages: Int = 0
    public var dicImageParameter: NSMutableDictionary!
    public var dicBodyParameter: NSMutableDictionary!

    @IBInspectable open var setImageUrl: String {
        get {
            return _baseImageUploadURL
        }
        set {
            _baseImageUploadURL = newValue
        }
    }
    @IBInspectable open var setImagefileName: String {
        get {
            return _imagename
        }
        set {
            _imagename = newValue
        }
    }


    // MARK: - Lifecycle -
    public static let shared: AppImageUploadManager = {

        let instance = AppImageUploadManager()
        return instance
    }()

    deinit {

    }

    override init() {
        super.init()
        self.setupOnInit()
    }

    // MARK: - Public Interface -
    open func addImageForUpload(arrImage: [UIImage]) -> Bool
    {
        if isUploadingRunning == false {
            totalImages = totalImages + arrImage.count
            self.saveImagesInCatch(arrImage: arrImage)
            if self.updateUploadStatus != nil
                {
                self.updateUploadStatus!(true, NSArray(array: [totalUploadedImage, totalImages]))
            }
            self.prepareImageForUpload(imagePath: self.getImageForUploadOnServer())
        }
        return isUploadingRunning
    }

    open func setUpdateProgressStatusEven(event: @escaping TaskFinishedEvent) {
        updateUploadStatus = event
    }

    open func getTotalImageCount() -> Int
    {
        do
        {
            return try fileManager!.contentsOfDirectory(atPath: uploadImageDirectoryPath! as String).count
        }
        catch let error as NSError
        {
            print("Error while Getting Total Image Count:- \(error.localizedDescription)")
            return 0
        }
    }

    open func isUploadOperationRunning() -> Bool {
        return isUploadingRunning
    }

    // MARK: - Internal Helpers -
    fileprivate func setupOnInit()
    {
        documentPath = AppUtility.getDocumentDirectoryPath()
        fileManager = FileManager()
        uploadImageDirectoryPath = AppUtility.stringByPathComponet(fileName: "UploadImages", Path: documentPath!)
    }

    fileprivate func saveImagesInCatch(arrImage: [UIImage])
    {
        if !(fileManager?.fileExists(atPath: uploadImageDirectoryPath!))!
            {
            do
            {
                try fileManager?.createDirectory(atPath: uploadImageDirectoryPath!, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError {
                print("Error While Create Directory :- \(error.localizedDescription)")
                return
            }
        }
        var currentIndex: Int = totalUploadedImage
        for image in arrImage
        {
            var imagePath: String? = AppUtility.stringByPathComponet(fileName: "\(currentIndex).jpg", Path: uploadImageDirectoryPath!)
            print("imagePath:- \(String(describing: imagePath))")
            var img: UIImage? = image.compressImage(to: 500, compressRatio: 0.4)

            var imageData: Data? = img!.jpegData(compressionQuality: 0.7)!

            do {

                try imageData! .write(to: URL(fileURLWithPath: imagePath!), options: Data.WritingOptions.atomic)

            }
            catch let error as NSError {
                print("Error while saveing image : \(error.localizedDescription)")
            }

            currentIndex = currentIndex + 1

            imagePath = nil
            imageData = nil
            img = nil

        }
        print("finish Save")
    }

    fileprivate func getImageForUploadOnServer() -> String
    {
        do
        {
            let tmpFileList: [String] = try fileManager!.contentsOfDirectory(atPath: uploadImageDirectoryPath! as String)
            if tmpFileList.count > 0
                {
                return AppUtility.stringByPathComponet(fileName: tmpFileList.first!, Path: uploadImageDirectoryPath!)
            }
        }
        catch let error as NSError
        {
            print("Error while Feting Image:- \(error.localizedDescription)")
        }

        return ""
    }


    fileprivate func prepareImageForUpload(imagePath: String)
    {
        if (fileManager?.fileExists(atPath: imagePath))!
            {
            if dicImageParameter == nil {
                dicImageParameter = NSMutableDictionary()
                dicImageParameter! .setObject(NSData(contentsOfFile: imagePath)!, forKey: "data" as NSCopying)
                dicImageParameter! .setObject(_imagename, forKey: "name" as NSCopying)
                dicImageParameter! .setObject(_imagename, forKey: "fileName" as NSCopying)
                dicImageParameter! .setObject("image/jpeg", forKey: "type" as NSCopying)
            }

            isUploadingRunning = true

            self.uploadImageRequest(dicImage: dicImageParameter!, uploadFilePath: imagePath)

        }
    }

    // MARK: - Server Helpers -

    func uploadImageRequest(dicImage: NSDictionary, uploadFilePath: String)
    {

        if dicBodyParameter == nil {
            dicBodyParameter = NSMutableDictionary()
        }

        if _baseImageUploadURL == ""
            {
            return
        }

        APIManager.shared.uploadImage(url: _baseImageUploadURL, Parameter: dicBodyParameter, Images: [dicImage]) { [weak self] (result) in

            if self == nil {
                return
            }

            switch result {
            case .Success(_, _):

                self!.totalUploadedImage = self!.totalUploadedImage + 1

                do
                {
                    try self!.fileManager?.removeItem(atPath: uploadFilePath)
                    if self!.getTotalImageCount() > 0
                        {
                        if self!.updateUploadStatus != nil
                            {
                            self!.updateUploadStatus!(true, NSArray(array: [self!.totalUploadedImage, self!.totalImages]))
                        }

                        self!.prepareImageForUpload(imagePath: self!.getImageForUploadOnServer())
                    }
                    else
                    {
                        if self!.updateUploadStatus != nil
                            {
                            self!.updateUploadStatus!(true, NSArray(array: [self!.totalUploadedImage, self!.totalImages]))
                        }
                        self!.totalUploadedImage = 0
                        self!.totalImages = 0
                        self!.isUploadingRunning = false
                    }
                }
                catch let error as NSError {
                    print("Error While Remove image :- \(error.localizedDescription)")
                }

                break
            case .Error(_):

                self!.isUploadingRunning = false

                break
            case .Internet(_):
                break
            }
        }
    }
}

