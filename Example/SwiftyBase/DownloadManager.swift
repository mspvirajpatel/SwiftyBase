//
//  DownloadManager.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 11/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Photos
import SwiftyBase

@objc public protocol DownloadManagerDelegate
{
    /**A delegate method called each time whenever any download task's progress is updated
     */
    func downloadRequestDidUpdateProgress(_ downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called when interrupted tasks are repopulated
     */
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [AppDownloadModel])
    
    /**A delegate method called each time whenever new download task is start downloading
     */
    func downloadRequestStarted(downloadModel : AppDownloadModel , index : Int)
    
    /**A delegate method called each time whenever running download task is paused. If task is already paused the action will be ignored
     */
    func downloadRequestDidPaused(_ downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    func downloadRequestDidResumed(_ downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    func downloadRequestDidRetry(_ downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is cancelled by the user
     */
    func downloadRequestCanceled(_ downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is finished successfully
     */
    func downloadRequestFinished(_ downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is failed due to any reason
     */
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: AppDownloadModel, index: Int)
    
    /**A delegate method called each time whenever specified destination does not exists. It will be called on the session queue. It provides the opportunity to handle error appropriately
     */
    func downloadRequestDestinationDoestNotExists(_ downloadModel: AppDownloadModel, index: Int, location: URL)
}

class DownloadManager: NSObject
{
    public static let shared : DownloadManager = DownloadManager()
    weak var delegate : DownloadManagerDelegate?
    private var downloadPath : String = AppUtility.baseFilePath + "/SwiftyBase"
    
    lazy var vdDownloader : AppDownloadManager = { [unowned self] in
        
        let sessionIdentifer: String = "com.iosDevelopment.MZDownloadManager.BackgroundSession"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = AppDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        
        return downloadmanager
       
        }()
    
    private override init() {
        super.init()
        self.createDownloadFolder()
    }
    
    private func createDownloadFolder(){
        
        do{
            if !FileManager.default.fileExists(atPath: downloadPath){
                try FileManager.default.createDirectory(atPath: downloadPath, withIntermediateDirectories: true, attributes: nil)
            }
        }
        catch let error as NSError{
            print("Error :- \(error.localizedDescription)")
        }
    }
    
    internal func saveImageInLibrary(imageURL : String){
        do{
            let imagePath : String = (downloadPath as NSString).appendingPathComponent(imageURL)
            
            if let image = try UIImage(data: Data(contentsOf: URL(fileURLWithPath: imagePath))){
                
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .authorized:
                    
                    AppCustomPhotoAlbum.sharedInstance.saveImage(image:image)
                    break
                    
                case .denied, .restricted :
                    
                    break
                case .notDetermined:
                    // ask for permissions
                    
                    
                    PHPhotoLibrary.requestAuthorization() {  [weak self] status in
                        if self == nil
                        {
                            return
                        }
                        switch status {
                        case .authorized:
                            AppCustomPhotoAlbum.sharedInstance.saveImage(image:image)
                            
                            break
                        // as above
                        case .denied, .restricted:
                            
                            break
                            
                        default:
                            break
                            
                        }
                        
                    }
                }
                // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        catch let error as NSError{
            print("error :- \(error.localizedDescription)")
        }
    }
    
    public func downloadFiles(arrURL : NSMutableArray){
        
        for url in arrURL {
            self.downloadFile(fileURL: url as! String , username: "")
        }
    }
    
    public func downloadFile(fileURL : String , username : String){
        
        let url : NSString = fileURL as NSString
        let fileName : String = url.lastPathComponent
        
        if FileManager.default.fileExists(atPath: (downloadPath as NSString).appendingPathComponent(fileName)){
            do
            {
                try FileManager.default.removeItem(atPath: (downloadPath as NSString).appendingPathComponent(fileName))
            }
            catch let error as NSError
            {
                print("Error :- \(error.localizedDescription)")
            }
        }
        
        vdDownloader.addDownloadTask(fileName, fileURL: fileURL, destinationPath: downloadPath, username: username)
        
    }
    
}

// MARK : MZDownloadManager Delegate Method
extension DownloadManager : AppDownloadManagerDelegate{
    
    func downloadRequestStarted(_ downloadModel: AppDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestStarted(downloadModel: downloadModel, index: index)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [AppDownloadModel]) {
        if delegate != nil{
            delegate!.downloadRequestDidPopulatedInterruptedTasks(downloadModels)
        }
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: AppDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestDidUpdateProgress(downloadModel, index: index)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestDidPaused(_ downloadModel: AppDownloadModel, index: Int) {
        if delegate != nil{
            delegate!.downloadRequestDidPaused(downloadModel, index: index)
        }
    }
    
    func downloadRequestDidResumed(_ downloadModel: AppDownloadModel, index: Int) {
        if delegate != nil{
            delegate!.downloadRequestDidResumed(downloadModel, index: index)
        }
    }
    
    func downloadRequestCanceled(_ downloadModel: AppDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestCanceled(downloadModel, index: index)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestFinished(_ downloadModel: AppDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestFinished(downloadModel, index: index)
        }
        
        self.saveImageInLibrary(imageURL: downloadModel.fileName)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: AppDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate?.downloadRequestDidFailedWithError(error, downloadModel: downloadModel, index: index)
        }
        debugPrint("Error while downloading file: \(downloadModel.fileName)  Error: \(error)")
    }
    
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: AppDownloadModel, index: Int, location: URL) {
        
        if delegate != nil{
            delegate?.downloadRequestDestinationDoestNotExists(downloadModel,index: index, location: location)
        }
        else
        {
            let myDownloadPath = AppUtility.baseFilePath + "/Defaultfolder"
            if !FileManager.default.fileExists(atPath: myDownloadPath) {
                try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
            }
            let fileName = AppUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
            let path =  myDownloadPath + "/" + (fileName as String)
            try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
            debugPrint("Default folder path: \(myDownloadPath)")
        }
    }
}
