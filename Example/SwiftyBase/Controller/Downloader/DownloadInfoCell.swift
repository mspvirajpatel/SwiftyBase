//
//  DownloadInfoCell.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 11/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyBase

class DownloadInfoCell: UITableViewCell {
    
    // MARK: - Attribute -
    
    var imgThumb : BaseImageView!
    var lblFileName : BaseLabel!
    var lblSizeStatus : BaseLabel!
    var lblStatus : BaseLabel!
    var progressBar : UIProgressView!
    var containerView : UIView!
    
    
    // MARK: - Lifecycle -
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.loadViewControls()
        self.setViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted){
            self.contentView.backgroundColor = UIColor.clear
            
        }else{
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit
    {
        print("DownloadInfoCell deinit callde")
        
        NotificationCenter.default.removeObserver(self)
        
        if containerView != nil && containerView.superview != nil{
            containerView.removeFromSuperview()
            containerView = nil
        }
        
        if imgThumb != nil && imgThumb.superview != nil{
            imgThumb.removeFromSuperview()
            imgThumb = nil
        }
        
        if lblFileName != nil && lblFileName.superview != nil{
            lblFileName.removeFromSuperview()
            lblFileName = nil
        }
        
        if lblSizeStatus != nil && lblSizeStatus.superview != nil{
            lblSizeStatus.removeFromSuperview()
            lblSizeStatus = nil
        }
        
        if lblStatus != nil && lblStatus.superview != nil{
            lblStatus.removeFromSuperview()
            lblStatus = nil
        }
    }
    
    // MARK: - Layout -
    func loadViewControls()
    {
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        containerView = UIView()
        containerView.layer .setValue("containerView", forKey: ControlConstant.name)
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        self.contentView.addSubview(containerView)
        
        
        lblFileName = BaseLabel(labelType: BaseLabelType.medium, superView: containerView)
        lblFileName.text = "Hello "
        lblFileName.layer .setValue("lblFileName", forKey: ControlConstant.name)
        
        lblSizeStatus = BaseLabel(labelType: .medium, superView: containerView)
        lblSizeStatus.text = "656 "
        lblSizeStatus.layer .setValue("lblSizeStatus", forKey: ControlConstant.name)
        
        lblStatus = BaseLabel(labelType: .medium, superView: containerView)
        lblStatus.text = "Failed "
        lblStatus.layer .setValue("lblStatus", forKey: ControlConstant.name)
        
        imgThumb = BaseImageView(type: .defaultImg, superView: containerView)
        imgThumb.layer .setValue("imgThumb", forKey: ControlConstant.name)
        
        progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.layer .setValue("progressBar", forKey: ControlConstant.name)
        self.containerView.addSubview(progressBar)
    }
    
    func setViewLayout()
    {
        var layout : AppBaseLayout? = AppBaseLayout()
        
        layout!.expandView(containerView, insideView: self.contentView, betweenSpace: 10.0)
        
        layout!.viewDictionary = containerView.getDictionaryOfVariableBindings(superView: containerView, viewDic: NSDictionary()) as! [String : AnyObject]
        layout!.metrics = ["hSpace" : 10.0,"vSpace" : 10.0,"betweenSpace" : 5.0]
        
        layout!.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-hSpace-[imgThumb(==50)]-hSpace-[lblFileName]-hSpace-|", options: NSLayoutFormatOptions(rawValue : 0), metrics: layout?.metrics, views: layout!.viewDictionary)
        containerView.addConstraints(layout!.control_H)
        
        layout!.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-vSpace-[imgThumb(==50)]->=vSpace@249-|", options: NSLayoutFormatOptions(rawValue : 0), metrics: layout!.metrics, views: layout!.viewDictionary)
        containerView.addConstraints(layout!.control_V)
        
        lblFileName.topEqualTo(view: imgThumb)
        
        layout!.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-vSpace-[lblFileName]-vSpace-[lblSizeStatus]-vSpace-[lblStatus]-vSpace-[progressBar]->=vSpace@751-|", options: [.alignAllLeading,.alignAllTrailing], metrics: layout!.metrics, views: layout!.viewDictionary)
        containerView.addConstraints(layout!.control_V)
        
        
        defer{
            layout?.releaseObject()
            layout = nil
        }
        self.layoutIfNeeded()
        
        AppUtility.executeTaskInMainThreadAfterDelay(0.1) { [weak self] in
            if self == nil{
                return
            }
            
            let shadowPath = UIBezierPath(roundedRect: self!.containerView.bounds, cornerRadius: 5.0)
            self!.containerView.layer.masksToBounds = false
            self!.containerView.layer.shadowColor = UIColor.black.cgColor
            self!.containerView.layer.shadowOffset = CGSize(width: 0.5, height: 1);
            self!.containerView.layer.shadowOpacity = 0.5
            self!.containerView.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    
    // MARK: - Public Interface -
    func displayCellData(indexPath : IndexPath,downloadModel : AppDownloadModel) -> Void{
        
        if downloadModel.username != ""
        {
            self.lblFileName.text = downloadModel.username
        }
        else
        {
            self.lblFileName.text = downloadModel.fileName
        }
        
        progressBar.progress = downloadModel.progress
        
        var fileSize = "Getting information..."
        if let _ = downloadModel.file?.size {
            fileSize = String(format: "%.2f %@", (downloadModel.file?.size)!, (downloadModel.file?.unit)!)
        }
        
        if let _ = downloadModel.downloadedFile?.size{
            fileSize = "\(String(format: "%.2f %@", (downloadModel.downloadedFile?.size)!, (downloadModel.downloadedFile?.unit)!)) \\ \(fileSize)"
        }
        
        lblSizeStatus.text = fileSize
        lblStatus.text = downloadModel.status
        
//        imgThumb.setImageURL(downloadModel.fileURL)
    }
    
    // MARK: - User Interaction -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
}
