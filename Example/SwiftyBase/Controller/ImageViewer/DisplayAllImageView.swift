//
//  DisplayAllImageView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 18/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBase

class DisplayAllImageView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    
    // MARK: - Attribute -
    
    var photoCollectionView:UICollectionView!
    var flowLayout:UICollectionViewFlowLayout!
    
    var photoListArray:NSMutableArray!
    var photoListCount:NSInteger!
    
    var previousPhotoListCount:NSInteger!
    var nextPhotoListCount:NSInteger!
    
    var collectionCellSize:CGSize! = AppInterfaceUtility.getAppropriateSizeFromSize(UIScreen.main.bounds.size, withDivision: 3.0, andInterSpacing: 5.0)
    
    // MARK: - Lifecycle -
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
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
        
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        
        photoListArray =  [
            "http://www.intrawallpaper.com/static/images/HD-Wallpapers1_Q75eDHE_lG95giJ.jpeg",
            "http://www.intrawallpaper.com/static/images/hd-wallpapers-8_FY4tW4s.jpg",
            "http://www.intrawallpaper.com/static/images/tiger-wallpapers-hd-Bengal-Tiger-hd-wallpaper.jpg",
            "http://www.intrawallpaper.com/static/images/3D-Beach-Wallpaper-HD-Download_QssSQPf.jpg",
            "http://www.intrawallpaper.com/static/images/pixars_up_hd_wide-wide.jpg",
            "http://www.intrawallpaper.com/static/images/tree_snake_hd-wide.jpg",
            "http://www.intrawallpaper.com/static/images/3D-Wallpaper-HD-35_hx877p1.jpg",
            "http://www.intrawallpaper.com/static/images/tropical-beach-background-8.jpg",
            "http://www.intrawallpaper.com/static/images/1912472_ePOwBxX.jpg",
            "http://www.intrawallpaper.com/static/images/Colors_digital_hd_wallpaper_F37Cy15.jpg",
            "http://www.intrawallpaper.com/static/images/funky-wallpaper-hd_4beLiY2.jpg",
            "http://www.intrawallpaper.com/static/images/dna_nano_tech-wide_dyyhibN.jpg",
            "http://www.intrawallpaper.com/static/images/dream_village_hd-HD.jpg",
            "http://www.intrawallpaper.com/static/images/hd-wallpaper-25_hOaS0Jp.jpg","http://www.intrawallpaper.com/static/images/Golden-Gate-Bridge-HD-Wallpapers-WideScreen2.jpg"
            ,"http://www.intrawallpaper.com/static/images/hd-wallpaper-40_HM6Q9LK.jpg"
            
            
        ]
        
        photoListCount = photoListArray.count
        
        /*  photoCollectionView Allocation   */
        
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        
        
        photoCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.allowsMultipleSelection = false
        photoCollectionView.backgroundColor = UIColor.clear
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView .register(PhotoCollectionCell.self, forCellWithReuseIdentifier: CellIdentifire.defaultCell)
        
        self.addSubview(photoCollectionView)
        
        
    }
    
    override func setViewlayout()
    {
        super.setViewlayout()
        
        baseLayout.expandView(photoCollectionView, insideView: self)
        
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - UICollectionView DataSource Methods -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoListCount == 0  {
            self.displayErrorMessageLabel("No Record Found")
        }
        else
        {
            self.displayErrorMessageLabel(nil)
        }
        
        return photoListCount ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : PhotoCollectionCell!
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifire.defaultCell, for: indexPath) as? PhotoCollectionCell
        
        if cell == nil
        {
            cell = PhotoCollectionCell(frame: CGRect.zero)
        }
        if(indexPath.row < photoListArray.count){
            var imageString:NSString? = photoListArray[indexPath.row] as? NSString
            cell.displayImage(image: imageString!)
            imageString = nil;
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for photoURLString in photoListArray {
               
                let photoModel = PhotoModel(imageUrlString: photoURLString as? String, sourceImageView: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        let photoBrowser = PhotoBrowser(photoModels: setPhoto())
      
        photoBrowser.delegate = self
        photoBrowser.show(inVc: self.getViewControllerFromSubView()!, beginPage: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    
    
    // MARK: - Server Request -
    
//    public func getAllImagesRequest()
//    {
//        
//        operationQueue.addOperation { [weak self] in
//            if self == nil{
//                return
//            }
//            
//            BaseAPICall.shared.postReques(URL: APIConstant.userPhotoList, Parameter: NSDictionary(), Type: APITask.GetAllImages) { [weak self] (result) in
//                if self == nil{
//                    return
//                }
//                
//                switch result{
//                case .Success(let object,let error):
//                    
//                    self!.hideProgressHUD()
//                    
//                    var imageArray: NSMutableArray! = object as! NSMutableArray
//                    self!.previousPhotoListCount = self!.photoListArray.count
//                    self!.nextPhotoListCount = imageArray.count
//                    self!.photoListArray = imageArray
//                    self!.photoListCount = self!.photoListArray.count
//                    
//                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
//                        if self == nil{
//                            return
//                        }
//                        self!.photoCollectionView.reloadData()
//                    }
//                    
//                    defer{
//                        imageArray = nil
//                    }
//                    
//                    break
//                case .Error(let error):
//                    
//                    self!.hideProgressHUD()
//                    AppUtility.executeTaskInMainQueueWithCompletion {
//                        AppUtility.showWhisperAlert(message: error!.serverMessage, duration: 1.0)
//                    }
//                    
//                    break
//                case .Internet(let isOn):
//                    self!.handleNetworkCheck(isAvailable: isOn)
//                    break
//                }
//            }
//        }
//    }
//    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}


extension DisplayAllImageView: PhotoBrowserDelegate {
    
    func photoBrowserWillEndDisplay(_ endPage: Int) {
        let currentIndexPath = IndexPath(row: endPage, section: 0)
        
        let cell = photoCollectionView.cellForItem(at: currentIndexPath) as? PhotoCollectionCell
        cell?.alpha = 0.0
    }
   
    func photoBrowserDidEndDisplay(_ endPage: Int) {
        let currentIndexPath = IndexPath(row: endPage, section: 0)
        
        let cell = photoCollectionView.cellForItem(at: currentIndexPath) as? PhotoCollectionCell
        cell?.alpha = 1.0
    }
    
    func photoBrowserDidDisplayPage(_ currentPage: Int, totalPages: Int) {
        let visibleIndexPaths = photoCollectionView.indexPathsForVisibleItems
        
        let currentIndexPath = IndexPath(row: currentPage, section: 0)
        if !visibleIndexPaths.contains(currentIndexPath) {
            photoCollectionView.scrollToItem(at: currentIndexPath, at: .top, animated: false)
            photoCollectionView.layoutIfNeeded()
        }
    }
   
    func sourceImageViewForCurrentIndex(_ index: Int) -> UIImageView? {
        
        let currentIndexPath = IndexPath(row: index, section: 0)
        
        let cell = photoCollectionView.cellForItem(at: currentIndexPath) as? PhotoCollectionCell
        let sourceView = cell?.feedImageView
        return sourceView
    }
    
}
