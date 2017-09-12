//
//  DownloadingView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 11/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyBase

class DownloadingView: BaseView{
    
    // MARK: - Attribute -
    var tblCurrentDownload : UITableView!
    var downloadManager : AppDownloadManager! = DownloadManager.shared.vdDownloader
    var selectedTaskIndex : IndexPath!
    let alertControlTag : Int = 500
    var baseStartDownload : BaseButton!
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    deinit{
        print("DownloadingView Deinit Called")
        self.releaseObject()
    }
    
    override func releaseObject() {
        super.releaseObject()
        
        NotificationCenter.default.removeObserver(self)
        
        if tblCurrentDownload != nil && tblCurrentDownload.superview != nil{
            tblCurrentDownload.removeFromSuperview()
            tblCurrentDownload = nil
        }
        
        downloadManager = nil
        selectedTaskIndex = nil
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        DownloadManager.shared.delegate = self
        
        baseStartDownload = BaseButton.init(ibuttonType: .primary, iSuperView: self)
        baseStartDownload.layer.setValue("baseStartDownload", forKey: ControlConstant.name)
        baseStartDownload.setTitle("Download", for: UIControlState())
        baseStartDownload.setButtonTouchUpInsideEvent { (sender, object) in
            DownloadManager.shared.downloadFiles(arrURL: ["http://wallpaperswide.com/download/just_live-wallpaper-1440x900.jpg","https://www.planwallpaper.com/static/images/6768666-1080p-wallpapers.jpg","https://www.planwallpaper.com/static/images/HD-Wallpapers1_FOSmVKg.jpeg","https://www.planwallpaper.com/static/images/canada-winter-moraine-lake-alberta-hd-high-511002.jpg"])
        }
        
        tblCurrentDownload = UITableView()
        tblCurrentDownload.backgroundColor = UIColor.clear
        tblCurrentDownload.translatesAutoresizingMaskIntoConstraints = false
        tblCurrentDownload.register(DownloadInfoCell.self, forCellReuseIdentifier: "download")
        tblCurrentDownload.layer.setValue("tblCurrentDownload", forKey: ControlConstant.name)

        
        tblCurrentDownload.separatorStyle = .none
        tblCurrentDownload.delegate = self
        tblCurrentDownload.dataSource = self
        tblCurrentDownload.estimatedRowHeight = 200.0
        tblCurrentDownload.rowHeight = UITableViewAutomaticDimension
        self.addSubview(tblCurrentDownload)
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[baseStartDownload]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[baseStartDownload][tblCurrentDownload]|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        self.layoutSubviews()
        
    }
    
    // MARK: - Public Interface -
    func refreshCellForIndex(_ downloadModel: AppDownloadModel, index: Int) {
        let indexPath : IndexPath! = IndexPath.init(row: index, section: 0)
        if let cell : DownloadInfoCell = self.tblCurrentDownload.cellForRow(at: indexPath) as? DownloadInfoCell {
            cell.displayCellData(indexPath: indexPath, downloadModel: downloadModel)
        }
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
}

// MARK: UITableView Delegate Method
extension DownloadingView : UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if downloadManager.downloadingArray.count == 0{
            self.displayErrorMessageLabel("No current download ruuning.")
            return 0
        }
        else{
            self.displayErrorMessageLabel(nil)
            return downloadManager.downloadingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : DownloadInfoCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "download", for: indexPath) as? DownloadInfoCell
        
        if cell == nil{
            cell = DownloadInfoCell(style: UITableViewCellStyle.default, reuseIdentifier: "download")
        }
        
        cell.displayCellData(indexPath: indexPath, downloadModel: downloadManager.downloadingArray[indexPath.row])
        return cell
    }
}

// MARK: UITableView DataSource Method
extension DownloadingView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTaskIndex = indexPath
        let downloadModel = downloadManager.downloadingArray[indexPath.row]
        self.showAppropriateActionController(downloadModel.status)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Download Manager Delegate Method
extension DownloadingView : DownloadManagerDelegate{
    /**A delegate method called each time whenever any download task's progress is updated
     */
    func downloadRequestDidUpdateProgress(_ downloadModel: AppDownloadModel, index: Int){
        self.refreshCellForIndex(downloadModel , index: index)
    }
    
    /**A delegate method called when interrupted tasks are repopulated
     */
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [AppDownloadModel]){
        tblCurrentDownload.reloadData()
    }
    
    /**A delegate method called each time whenever new download task is start downloading
     */
    func downloadRequestStarted(downloadModel : AppDownloadModel , index : Int){
        let indexPath = IndexPath.init(row: index, section: 0)
        tblCurrentDownload.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    /**A delegate method called each time whenever running download task is paused. If task is already paused the action will be ignored
     */
    func downloadRequestDidPaused(_ downloadModel: AppDownloadModel, index: Int){
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    func downloadRequestDidResumed(_ downloadModel: AppDownloadModel, index: Int){
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    func downloadRequestDidRetry(_ downloadModel: AppDownloadModel, index: Int){
        
    }
    
    /**A delegate method called each time whenever any download task is cancelled by the user
     */
    func downloadRequestCanceled(_ downloadModel: AppDownloadModel, index: Int){
        
        self.safelyDismissAlertController()
        
        if index < tblCurrentDownload.numberOfRows(inSection: 0){
            let indexPath = IndexPath.init(row: index, section: 0)
            tblCurrentDownload.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    /**A delegate method called each time whenever any download task is finished successfully
     */
    func downloadRequestFinished(_ downloadModel: AppDownloadModel, index: Int){
        
        self.safelyDismissAlertController()
        
        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")
        
        if tblCurrentDownload.numberOfRows(inSection: 0) > index{
            let indexPath = IndexPath.init(row: index, section: 0)
            tblCurrentDownload.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    /**A delegate method called each time whenever any download task is failed due to any reason
     */
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: AppDownloadModel, index: Int){
        self.refreshCellForIndex(downloadModel, index: index)
        debugPrint("Error while downloading file: \(downloadModel.fileName)  Error: \(error)")
    }
    
    /**A delegate method called each time whenever specified destination does not exists. It will be called on the session queue. It provides the opportunity to handle error appropriately
     */
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: AppDownloadModel, index: Int, location: URL){
        let myDownloadPath = AppUtility.baseFilePath + "/Default folder"
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName = AppUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
        let path =  myDownloadPath + "/" + (fileName as String)
        
        do{
            try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
        }
        catch let error as NSError{
            print("Error :",error.localizedDescription)
        }
        
        debugPrint("Default folder path: \(myDownloadPath)")
    }
}

// MARK: DownloadView Alert Controller's Method
extension DownloadingView
{
    func showAppropriateActionController(_ requestStatus: String) {
        switch requestStatus {
        case TaskStatus.downloading.description():
            self.showAlertControllerForPause()
            break
        case TaskStatus.failed.description():
            self.showAlertControllerForRetry()
            break
        case TaskStatus.paused.description():
            self.showAlertControllerForStart()
            break
        default:
            break
        }
    }
    
    func showAlertControllerForPause() {
        
        var pauseAction : UIAlertAction! = UIAlertAction(title: "Pause", style: .default) { [weak self] (alertAction: UIAlertAction) in
            if self == nil {
                return
            }
            self!.downloadManager.pauseDownloadTaskAtIndex(self!.selectedTaskIndex.row)
        }
        
        var removeAction : UIAlertAction! = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (alertAction: UIAlertAction) in
            if self == nil {
                return
            }
            
            self!.downloadManager.cancelTaskAtIndex(self!.selectedTaskIndex.row)
        }
        
        var cancelAction : UIAlertAction! = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        var alertController : UIAlertController! = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControlTag
        alertController.addAction(pauseAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.getViewControllerFromSubView()!.present(alertController, animated: true, completion: nil)
        
        defer {
            pauseAction = nil
            removeAction = nil
            cancelAction = nil
            alertController = nil
        }
        
    }
    
    func showAlertControllerForRetry() {
        
        var retryAction : UIAlertAction! = UIAlertAction(title: "Retry", style: .default) { [weak self] (alertAction: UIAlertAction) in
            if self == nil {
                return
            }
            self!.downloadManager.retryDownloadTaskAtIndex(self!.selectedTaskIndex.row)
        }
        
        var removeAction : UIAlertAction! = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (alertAction: UIAlertAction) in
            if self == nil {
                return
            }
            self!.downloadManager.cancelTaskAtIndex(self!.selectedTaskIndex.row)
        }
        
        var cancelAction : UIAlertAction! = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        var alertController : UIAlertController! = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControlTag
        alertController.addAction(retryAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.getViewControllerFromSubView()!.present(alertController, animated: true, completion: nil)
        
        defer {
            retryAction = nil
            removeAction = nil
            cancelAction = nil
            alertController = nil
        }
    }
    
    func showAlertControllerForStart() {
        
        var startAction : UIAlertAction! = UIAlertAction(title: "Start", style: .default) { [weak self] (alertAction: UIAlertAction) in
            if self == nil {
                return
            }
            self!.downloadManager.resumeDownloadTaskAtIndex(self!.selectedTaskIndex.row)
        }
        
        var removeAction : UIAlertAction! = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (alertAction: UIAlertAction) in
            if self == nil {
                return
            }
            self!.downloadManager.cancelTaskAtIndex(self!.selectedTaskIndex.row)
        }
        
        var cancelAction : UIAlertAction! = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControlTag
        alertController.addAction(startAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.getViewControllerFromSubView()!.present(alertController, animated: true, completion: nil)
        
        defer {
            startAction = nil
            removeAction = nil
            cancelAction = nil
        }
    }
    
    func safelyDismissAlertController() {
        /***** Dismiss alert controller if and only if it exists and it belongs to MZDownloadManager *****/
        /***** E.g App will eventually crash if download is completed and user tap remove *****/
        /***** As it was already removed from the array *****/
        if let controller = self.getViewControllerFromSubView()!.presentedViewController {
            guard controller is UIAlertController && controller.view.tag == alertControlTag else {
                return
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
