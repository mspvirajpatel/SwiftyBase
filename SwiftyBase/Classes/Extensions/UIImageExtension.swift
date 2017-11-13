//
//  UIImageExtension.swift
//  Pods
//
//  Created by MacMini-2 on 06/09/17.
//
//

import Foundation

public extension CGSize {
    
    // get scale of image size with max dimention
    public func scale(max: CGFloat) -> CGFloat {
        if width > height{
            if width > max {
                return max / width
            }
        } else {
            if height > max {
                return max / height
            }
        }
        return 1
        
    }
}

public extension UIImage {
    
    public func scaleToSize(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
    
    // resize image with max dimention option & compressRatio like 0.5
    public func compressImage(to maxDimention: CGFloat,compressRatio:CGFloat) -> UIImage {
       
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        
        let aspect = self.size.scale(max: maxDimention)
        let maxHeight = self.size.height * aspect
        let maxWidth = self.size.width * aspect
        //        var maxHeight : CGFloat = 1136.0
        //        var maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = compressRatio
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        let rect = CGRect.init(x: 0, y: 0, width: actualWidth, height: actualHeight)
        
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality)
        UIGraphicsEndImageContext()
        
        return UIImage.init(data: imageData!)!
    }
    
    
}

public extension UIImage{
    
    public func maskWithColor(_ color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext?.clip(to: bounds, mask: maskImage!)
        bitmapContext?.setFillColor(color.cgColor)
        bitmapContext?.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext?.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            
            return coloredImage
            
        } else {
            return nil
        }
    }
    
    public func croppedImage(_ bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.size.width * self.scale, height: bound.size.height * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage : UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage;
    }
    
    
    public func normalizeBitmapInfo(_ bI: CGBitmapInfo) -> UInt32 {
        var alphaInfo: UInt32 = bI.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        if alphaInfo == CGImageAlphaInfo.last.rawValue {
            alphaInfo =  CGImageAlphaInfo.premultipliedLast.rawValue
        }
        
        if alphaInfo == CGImageAlphaInfo.first.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        }
        
        var newBI: UInt32 = bI.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue;
        
        newBI |= alphaInfo;
        
        return newBI
    }
    
    public enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    public func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight, margin:CGPoint = CGPoint(x: 20, y: 20), waterMarkTextColor:UIColor = UIColor.white, waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 20), backgroundColor:UIColor = UIColor.clear) -> UIImage{
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:waterMarkTextColor, NSAttributedStringKey.font:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(withAttributes: textAttributes)
        var textFrame = CGRect.init(x: 0, y: 0, width: textSize.width, height: textSize.width)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        }
        
        /// Start creating the image with water mark
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
        NSString(string: waterMarkText).draw(in: textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
    
    public func editWithText(text : String,setImage : UIImage) -> UIImage? {
        
        let font : UIFont! = Font(.installed(.AppleMedium), size:  SystemConstants.IS_IPAD ? .standard(.h) : .standard(.h) ).instance
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let imageSize = self.size
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        self.draw(at: .zero)
        
        let stringBox : CGSize = NSString(string: text).size(withAttributes: [NSAttributedStringKey.font : font])
        
        
        //Ractangle
        let rectangle = CGRect(x: 0, y: (imageSize.height) - (stringBox.height), width: stringBox.width + 110, height: stringBox.height)
        context!.setFillColor(AppColor.appPrimaryBG.value.cgColor)
        context!.addRect(rectangle)
        context!.drawPath(using: .fill)
        
        //Image
        let image : UIImage = (setImage.maskWithColor(.white))!
        let imageRact : CGRect = CGRect(x: 20, y: (imageSize.height) - (stringBox.height / 2) - (50 / 2), width: 50, height: 50)
        image.draw(in: imageRact)
        
        
        //Labale
        let lableRact = CGRect(x: 90, y: (imageSize.height) - stringBox.height, width: stringBox.width, height: stringBox.height)
        text.draw(in: lableRact.integral, withAttributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.white , NSAttributedStringKey.paragraphStyle : paragraphStyle])
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
