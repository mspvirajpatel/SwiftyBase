//
//  AppDownloadManager.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


@objc public protocol AppDownloadManagerDelegate {
    /**A delegate method called each time whenever any download task's progress is updated
     */
    func downloadRequestDidUpdateProgress(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called when interrupted tasks are repopulated
     */
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [AppDownloadModel])
    /**A delegate method called each time whenever new download task is start downloading
     */
    @objc optional func downloadRequestStarted(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever running download task is paused. If task is already paused the action will be ignored
     */
    @objc optional func downloadRequestDidPaused(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    @objc optional func downloadRequestDidResumed(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    @objc optional func downloadRequestDidRetry(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever any download task is cancelled by the user
     */
    @objc optional func downloadRequestCanceled(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever any download task is finished successfully
     */
    @objc optional func downloadRequestFinished(_ downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever any download task is failed due to any reason
     */
    @objc optional func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: AppDownloadModel, index: Int)
    /**A delegate method called each time whenever specified destination does not exists. It will be called on the session queue. It provides the opportunity to handle error appropriately
     */
    @objc optional func downloadRequestDestinationDoestNotExists(_ downloadModel: AppDownloadModel, index: Int, location: URL)

}

open class AppDownloadManager: NSObject {

    fileprivate var sessionManager: Foundation.URLSession!
    open var downloadingArray: [AppDownloadModel] = []
    fileprivate var delegate: AppDownloadManagerDelegate?

    fileprivate var backgroundSessionCompletionHandler: (() -> Void)?

    fileprivate let TaskDescFileNameIndex = 0
    fileprivate let TaskDescFileURLIndex = 1
    fileprivate let TaskDescFileDestinationIndex = 2

    public convenience init(session sessionIdentifer: String, delegate: AppDownloadManagerDelegate) {
        self.init()

        self.delegate = delegate
        self.sessionManager = self.backgroundSession(sessionIdentifer)
        self.populateOtherDownloadTasks()
    }

    public convenience init(session sessionIdentifer: String, delegate: AppDownloadManagerDelegate, completion: (() -> Void)?) {
        self.init(session: sessionIdentifer, delegate: delegate)
        self.backgroundSessionCompletionHandler = completion
    }

    fileprivate func backgroundSession(_ sessionIdentifer: String) -> Foundation.URLSession {
        struct sessionStruct {
            static var onceToken: Int = 0
            static var session: Foundation.URLSession? = nil
        }

        let sessionConfiguration: URLSessionConfiguration

        sessionConfiguration = URLSessionConfiguration.background(withIdentifier: sessionIdentifer)
        sessionStruct.session = Foundation.URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)

        return sessionStruct.session!
    }
}

// MARK: Private Helper functions

extension AppDownloadManager {

    fileprivate func downloadTasks() -> NSArray {
        return self.tasksForKeyPath("downloadTasks")
    }

    fileprivate func tasksForKeyPath(_ keyPath: NSString) -> NSArray {
        var tasks: NSArray = NSArray()
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        sessionManager.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
            if keyPath == "downloadTasks" {
                tasks = downloadTasks as NSArray
                debugPrint("pending tasks \(tasks)")
            }

            semaphore.signal()
        }

        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return tasks
    }

    fileprivate func populateOtherDownloadTasks() {

        let downloadTasks = self.downloadTasks()

        for object in downloadTasks {
            let downloadTask = object as! URLSessionDownloadTask
            let taskDescComponents: [String] = downloadTask.taskDescription!.components(separatedBy: ",")
            let fileName = taskDescComponents[TaskDescFileNameIndex]
            let fileURL = taskDescComponents[TaskDescFileURLIndex]
            let destinationPath = taskDescComponents[TaskDescFileDestinationIndex]

            let downloadModel = AppDownloadModel.init(fileName: fileName, fileURL: fileURL, destinationPath: destinationPath)
            downloadModel.task = downloadTask
            downloadModel.startTime = Date()

            if downloadTask.state == .running {
                downloadModel.status = TaskStatus.downloading.description()
                downloadingArray.append(downloadModel)
            } else if(downloadTask.state == .suspended) {
                downloadModel.status = TaskStatus.paused.description()
                downloadingArray.append(downloadModel)
            } else {
                downloadModel.status = TaskStatus.failed.description()
            }
        }
    }

    fileprivate func isValidResumeData(_ resumeData: Data?) -> Bool {

        guard resumeData != nil || resumeData?.count > 0 else {
            return false
        }

        do {
            var resumeDictionary: AnyObject!
            resumeDictionary = try PropertyListSerialization.propertyList(from: resumeData!, options: PropertyListSerialization.MutabilityOptions(), format: nil) as AnyObject?
            var localFilePath = (resumeDictionary?["NSURLSessionResumeInfoLocalPath"] as? String)

            if localFilePath == nil || localFilePath?.count < 1 {
                localFilePath = (NSTemporaryDirectory() as String) + (resumeDictionary["NSURLSessionResumeInfoTempFileName"] as! String)
            }

            let fileManager: FileManager! = FileManager.default
            debugPrint("resume data file exists: \(fileManager.fileExists(atPath: localFilePath! as String))")
            return fileManager.fileExists(atPath: localFilePath! as String)
        } catch let error as NSError {
            debugPrint("resume data is nil: \(error)")
            return false
        }
    }
}

extension AppDownloadManager: URLSessionDelegate {

    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            for (index, downloadModel) in self.downloadingArray.enumerated()
            {
                if downloadTask.isEqual(downloadModel.task)
                    {
                    let receivedBytesCount = Double(downloadTask.countOfBytesReceived)
                    let totalBytesCount = Double(downloadTask.countOfBytesExpectedToReceive)
                    let progress = Float(receivedBytesCount / totalBytesCount)

                    let taskStartedDate = downloadModel.startTime!
                    let timeInterval = taskStartedDate.timeIntervalSinceNow
                    let downloadTime = TimeInterval(-1 * timeInterval)

                    let speed = Float(totalBytesWritten) / Float(downloadTime)

                    let remainingContentLength = totalBytesExpectedToWrite - totalBytesWritten

                    let remainingTime = remainingContentLength / Int64(speed)
                    let hours = Int(remainingTime) / 3600
                    let minutes = (Int(remainingTime) - hours * 3600) / 60
                    let seconds = Int(remainingTime) - hours * 3600 - minutes * 60

                    let totalFileSize = AppUtility.calculateFileSizeInUnit(totalBytesExpectedToWrite)
                    let totalFileSizeUnit = AppUtility.calculateUnit(totalBytesExpectedToWrite)

                    let downloadedFileSize = AppUtility.calculateFileSizeInUnit(totalBytesWritten)
                    let downloadedSizeUnit = AppUtility.calculateUnit(totalBytesWritten)

                    let speedSize = AppUtility.calculateFileSizeInUnit(Int64(speed))
                    let speedUnit = AppUtility.calculateUnit(Int64(speed))

                    downloadModel.remainingTime = (hours, minutes, seconds)
                    downloadModel.file = (totalFileSize, totalFileSizeUnit as String)
                    downloadModel.downloadedFile = (downloadedFileSize, downloadedSizeUnit as String)
                    downloadModel.speed = (speedSize, speedUnit as String)
                    downloadModel.progress = progress

                    self.downloadingArray[index] = downloadModel

                    self.delegate?.downloadRequestDidUpdateProgress(downloadModel, index: index)

                    break
                }
            }
        })

    }

    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL)
    {
        for (index, downloadModel) in downloadingArray.enumerated()
        {
            if downloadTask.isEqual(downloadModel.task)
                {
                let fileName = downloadModel.fileName as NSString
                let basePath = downloadModel.destinationPath == "" ? AppUtility.baseFilePath : downloadModel.destinationPath
                let destinationPath = (basePath as NSString).appendingPathComponent(fileName as String)

                let fileManager: FileManager = FileManager.default

                //If all set just move downloaded file to the destination
                if fileManager.fileExists(atPath: basePath)
                    {
                    let fileURL = URL(fileURLWithPath: destinationPath as String)
                    debugPrint("directory path = \(destinationPath)")
                    print("Comleted File :- \(fileName)")
                    do
                    {
                        try fileManager.moveItem(at: location, to: fileURL)
                    }
                    catch let error as NSError
                    {
                        debugPrint("Error while moving downloaded file to destination path:\(error)")
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.downloadRequestDidFailedWithError?(error, downloadModel: downloadModel, index: index)
                        })
                    }
                } else {
                    //Opportunity to handle the folder doesnot exists error appropriately.
                    //Move downloaded file to destination
                    //Delegate will be called on the session queue
                    //Otherwise blindly give error Destination folder does not exists

                    if let _ = self.delegate?.downloadRequestDestinationDoestNotExists {
                        self.delegate?.downloadRequestDestinationDoestNotExists?(downloadModel, index: index, location: location)
                    } else {
                        let error = NSError(domain: "FolderDoesNotExist", code: 404, userInfo: [NSLocalizedDescriptionKey: "Destination folder does not exists"])
                        self.delegate?.downloadRequestDidFailedWithError?(error, downloadModel: downloadModel, index: index)
                    }
                }

                break
            }
        }
    }

    func URLSession(_ session: Foundation.URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        debugPrint("task id: \(task.taskIdentifier)")
        /***** Any interrupted tasks due to any reason will be populated in failed state after init *****/

        if (error?.userInfo[NSURLErrorBackgroundTaskCancelledReasonKey] as? NSNumber)?.intValue == NSURLErrorCancelledReasonUserForceQuitApplication || (error?.userInfo[NSURLErrorBackgroundTaskCancelledReasonKey] as? NSNumber)?.intValue == NSURLErrorCancelledReasonBackgroundUpdatesDisabled {

            let downloadTask = task as! URLSessionDownloadTask
            let taskDescComponents: [String] = downloadTask.taskDescription!.components(separatedBy: ",")
            let fileName = taskDescComponents[TaskDescFileNameIndex]
            let fileURL = taskDescComponents[TaskDescFileURLIndex]
            let destinationPath = taskDescComponents[TaskDescFileDestinationIndex]

            let downloadModel = AppDownloadModel.init(fileName: fileName, fileURL: fileURL, destinationPath: destinationPath)
            downloadModel.status = TaskStatus.failed.description()
            downloadModel.task = downloadTask

            let resumeData = error?.userInfo[NSURLSessionDownloadTaskResumeData] as? Data

            DispatchQueue.main.async(execute: { () -> Void in
                var newTask = downloadTask
                if self.isValidResumeData(resumeData) == true {
                    newTask = self.sessionManager.downloadTask(withResumeData: resumeData!)
                } else {
                    newTask = self.sessionManager.downloadTask(with: URL(string: fileURL as String)!)
                }

                newTask.taskDescription = downloadTask.taskDescription
                downloadModel.task = newTask

                self.downloadingArray.append(downloadModel)

                self.delegate?.downloadRequestDidPopulatedInterruptedTasks(self.downloadingArray)
            })
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                for(index, object) in self.downloadingArray.enumerated() {
                    let downloadModel = object
                    if task.isEqual(downloadModel.task) {
                        if error?.code == NSURLErrorCancelled || error == nil {

                            self.downloadingArray.remove(at: index)

                            if error == nil {
                                self.delegate?.downloadRequestFinished?(downloadModel, index: index)
                            } else {
                                self.delegate?.downloadRequestCanceled?(downloadModel, index: index)
                            }

                        } else {
                            let resumeData = error?.userInfo[NSURLSessionDownloadTaskResumeData] as? Data

                            DispatchQueue.main.async(execute: { () -> Void in

                                var newTask = task
                                if self.isValidResumeData(resumeData) == true {
                                    newTask = self.sessionManager.downloadTask(withResumeData: resumeData!)
                                } else {
                                    newTask = self.sessionManager.downloadTask(with: URL(string: downloadModel.fileURL)!)
                                }

                                newTask.taskDescription = task.taskDescription
                                downloadModel.status = TaskStatus.failed.description()
                                downloadModel.task = newTask as? URLSessionDownloadTask

                                self.downloadingArray[index] = downloadModel

                                if let error = error {
                                    self.delegate?.downloadRequestDidFailedWithError?(error, downloadModel: downloadModel, index: index)
                                } else {
                                    let error: NSError = NSError(domain: "MZDownloadManagerDomain", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])

                                    self.delegate?.downloadRequestDidFailedWithError?(error, downloadModel: downloadModel, index: index)
                                }

                            })
                        }
                        break
                    }
                }
            })

        }
    }

    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {

        if let backgroundCompletion = self.backgroundSessionCompletionHandler {
            DispatchQueue.main.async(execute: {
                backgroundCompletion()
            })
        }
        debugPrint("All tasks are finished")

    }
}

//MARK: Public Helper Functions

extension AppDownloadManager {

    public func addDownloadTask(_ fileName: String, fileURL: String, destinationPath: String, username: String) {

        let url = URL(string: fileURL as String)!
        let request = URLRequest(url: url)

        let downloadTask = sessionManager.downloadTask(with: request)
        downloadTask.taskDescription = [fileName, fileURL, destinationPath].joined(separator: ",")
        downloadTask.resume()

        debugPrint("session manager:\(sessionManager) url:\(url) request:\(request)")

        let downloadModel = AppDownloadModel.init(fileName: fileName, fileURL: fileURL, destinationPath: destinationPath)
        downloadModel.startTime = Date()
        downloadModel.username = username
        downloadModel.status = TaskStatus.downloading.description()
        downloadModel.task = downloadTask

        downloadingArray.append(downloadModel)

        delegate?.downloadRequestStarted?(downloadModel, index: downloadingArray.count - 1)
    }

    public func addDownloadTask(_ fileName: String, fileURL: String) {
        addDownloadTask(fileName, fileURL: fileURL, destinationPath: "", username: "")
    }

    public func pauseDownloadTaskAtIndex(_ index: Int) {

        if downloadingArray.count != 0
            {
            let downloadModel = downloadingArray[index]

            guard downloadModel.status != TaskStatus.paused.description() else {
                return
            }

            let downloadTask = downloadModel.task
            downloadTask!.suspend()
            downloadModel.status = TaskStatus.paused.description()
            downloadModel.startTime = Date()

            downloadingArray[index] = downloadModel

            delegate?.downloadRequestDidPaused?(downloadModel, index: index)
        }
    }

    public func resumeDownloadTaskAtIndex(_ index: Int) {
        if downloadingArray.count != 0
            {
            let downloadModel = downloadingArray[index]

            guard downloadModel.status != TaskStatus.downloading.description() else {
                return
            }

            let downloadTask = downloadModel.task
            downloadTask!.resume()
            downloadModel.status = TaskStatus.downloading.description()

            downloadingArray[index] = downloadModel

            delegate?.downloadRequestDidResumed?(downloadModel, index: index)
        }

    }

    public func retryDownloadTaskAtIndex(_ index: Int) {
        let downloadModel = downloadingArray[index]

        guard downloadModel.status != TaskStatus.downloading.description() else {
            return
        }

        let downloadTask = downloadModel.task

        downloadTask!.resume()
        downloadModel.status = TaskStatus.downloading.description()
        downloadModel.startTime = Date()
        downloadModel.task = downloadTask
    }

    public func cancelTaskAtIndex(_ index: Int) {
        if downloadingArray.count != 0
            {
            let downloadInfo = downloadingArray[index]
            let downloadTask = downloadInfo.task
            downloadTask!.cancel()
        }
    }

    public func presentNotificationForDownload(_ notifAction: String, notifBody: String) {
        let application = UIApplication.shared
        let applicationState = application.applicationState

        if applicationState == UIApplication.State.background {
            let localNotification = UILocalNotification()
            localNotification.alertBody = notifBody
            localNotification.alertAction = notifAction
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber += 1
            application.presentLocalNotificationNow(localNotification)
        }
    }
}
