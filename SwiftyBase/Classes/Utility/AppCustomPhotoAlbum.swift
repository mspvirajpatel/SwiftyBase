//
//  AppCustomPhotoAlbum.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation
import Photos

private var _name: String! = "SwiftyBase"

open class AppCustomPhotoAlbum {

    open class var sharedInstance: AppCustomPhotoAlbum
    {
        struct Static
        {
            static var instance: AppCustomPhotoAlbum?
        }

        Static.instance = AppCustomPhotoAlbum()

        return Static.instance!
    }

    @IBInspectable open var albumName: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }

    open var albumFound = Bool()
    open var images: [UIImage] = [UIImage]()
    open var assetCollection: PHAssetCollection!

    public init() {

        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: _name)
        }) { success, _ in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            }
            else
            {

            }
        }
    }

    public func fetchAssetCollectionForAlbum() -> PHAssetCollection! {

        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", _name)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
            albumFound = true
            return collection.firstObject!
        }
        else {
            albumFound = false
        }

        return nil
    }


    public func fetchCustomAlbumPhotos(completion: (_ albumImages: [UIImage]) -> Void) {

        if assetCollection == nil {
            completion([UIImage]())
            return
        }

        let photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        let imageManager = PHCachingImageManager()

        self.images.removeAll()
        photoAssets.enumerateObjects(options: .concurrent) { (object, count, stop) in
            let asset = object
            let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                self.images.append(image!)
            })
        }
        completion(self.images)
    }

    public func saveImage(image: UIImage) {
        if assetCollection == nil {
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)

        }, completionHandler: nil)
    }

}

//Use Save Image in Own PhotoAlbum: AppCustomPhotoAlbum.sharedInstance.saveImage(image:image)

//Use Get Images in Own PhotoAlbum:
//AppCustomPhotoAlbum.sharedInstance.fetchCustomAlbumPhotos { (albumImages) in
//
//    //... list of Array Images Get in albumImages
//}
