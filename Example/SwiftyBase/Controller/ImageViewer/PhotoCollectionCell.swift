//
//  PhotoCollectionCell.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 18/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBase

class PhotoCollectionCell: UICollectionViewCell {
    // MARK: - Attributes -
    
    var feedImageView:BaseImageView!
    var baselayout:AppBaseLayout!
    var parentTableView:UICollectionView!
    var isCellSelected : Bool = false
    
    @IBInspectable var FIRST: CGFloat = 1.5
    
    @IBInspectable var parallaxRatio: CGFloat = 1.5 {
        didSet {
            self.parallaxRatio = max(parallaxRatio, 1.0)
            self.parallaxRatio = min(parallaxRatio, 2.0)
            var rect: CGRect = self.bounds
            rect.size.height = rect.size.height * parallaxRatio
            self.feedImageView.frame = rect
            self.updateParallaxOffset()
        }
    }
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.loadViewControls()
        self.setViewControlsLayout()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        self.safeRemoveObserver()
        var v: UIView? = newSuperview
        while (v != nil) {
            if (v is UICollectionView) {
                self.parentTableView = (v as? UICollectionView)
                break
            }
            v = v?.superview
        }
        self.safeAddObserver()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    // MARK: - Layout -
    
    func loadViewControls()
    {
        self.contentView.backgroundColor = UIColor.white
        self.contentView.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.setBorder(UIColor.red, width: 1.0, radius: 7.0)
        
        /*  feedImageView Allocation   */
        
        feedImageView = BaseImageView.init(type: BaseImageViewType.defaultImg, superView: self.contentView)
        //feedImageView.setupForImageViewer()
        feedImageView.contentMode = UIViewContentMode.scaleAspectFill
        
        feedImageView.setBorder(UIColor.red, width: 1.0, radius: 7.0)
    }
    
    func setViewControlsLayout()
    {
        baselayout = AppBaseLayout.init()
        baselayout.expandView(feedImageView, insideView: self.contentView)
        
        self.layoutIfNeeded()
    }
    
    // MARK: - Public Interface -
    
    func displayImage(image:NSString)
    {
        if(image != ""){
//            feedImageView.displayImageFromURL(image as String)
            _ = feedImageView.setImageFromURL(image as String)
        }
    }
    
    func safeAddObserver() {
        if self.parentTableView != nil {
            defer {
            }
            do {
                self.parentTableView.addObserver(self, forKeyPath: "contentOffset", options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            }
            catch {
                
            }
        }
    }
    func safeRemoveObserver() {
        if (self.parentTableView != nil) {
            defer {
                self.parentTableView = nil
            }
            do {
                self.parentTableView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
            }
            catch
            {
            
            }
        }
    }
    override func layoutSubviews(){
        super.layoutSubviews()
        self.parallaxRatio = FIRST;
    }
    
    deinit{
        self.safeRemoveObserver()
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentOffset") {
            if !self.parentTableView.visibleCells.contains(self) || (self.parallaxRatio == 1.0) {
                return
            }
            self.updateParallaxOffset()
        }
    }
    
    
    func updateParallaxOffset() {
        if(self.parentTableView != nil)
        {
            let contentOffset: CGFloat = self.parentTableView.contentOffset.y
            let cellOffset: CGFloat = self.frame.origin.y - contentOffset
            let percent: CGFloat = (cellOffset + self.frame.size.height) / (self.parentTableView.frame.size.height + self.frame.size.height)
            let extraHeight: CGFloat = self.frame.size.height * (self.parallaxRatio - 1.0)
            var rect: CGRect = self.feedImageView.frame
            rect.origin.y = -extraHeight * percent
            self.feedImageView.frame = rect
        }
        
        
    }
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
}
