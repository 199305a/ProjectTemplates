//
//  UIImage-extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/4/18.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreImage

typealias NCIImage = CIImage

extension UIImage {
    func croppedImage(_ bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.size.width * self.scale, height: bound.size.height * self.scale)
        let imageRef = self.cgImage!.cropping(to: scaledBounds)
        let croppedImage : UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage;
    }
    
    func blurImageWithLevel(_ level: CGFloat) -> UIImage {
        //处理原始NSData数据
        guard let inputImg = NCIImage.init(image: self) else {
            return self
        }
        
        //创建高斯模糊滤镜
        guard let filter = CIFilter(name: "CIGaussianBlur") else {
            return self
        }
        
        filter.setValue(inputImg, forKey: kCIInputImageKey)
        filter.setValue(level, forKey: "inputRadius")
        
        guard let outputImg = filter.outputImage else {
            return self
        }
        
        //生成模糊图片
        let context = CIContext(options: nil)
        let theCgImg = context.createCGImage(outputImg, from: inputImg.extent)
        
        return UIImage.init(cgImage: theCgImg!)
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func roundRectImage4Size(_ size: CGSize, lWidth: CGFloat, lColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let p = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: 1, dy: 1), cornerRadius: 33/2)
        p.lineWidth = lWidth
        UIColor.clear.setFill()
        lColor.setStroke()
        p.fill()
        p.stroke()
        let im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return im!;
    }
    
    class func roundRectImage(_ cornerRadius: CGFloat, borderWidth: CGFloat, lColor: UIColor) -> UIImage {
        let size = CGSizeMake(cornerRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let p = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
        p.lineWidth = borderWidth
        UIColor.clear.setFill()
        lColor.setStroke()
        p.fill()
        p.stroke()
        var im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        im = im!.resizableImage(withCapInsets: UIEdgeInsetsMake(size.height / 2, size.width / 2, size.height / 2, size.width / 2))
        return im!;
    }
    
    class func imageWithColor(_ color: UIColor, width: CGFloat = 1, height: CGFloat = 1) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!;
    }
    
    // MARK: --- compress file ---
    func compressImage(_ width: CGFloat) -> UIImage {
        
        guard self.size.width > width else { return self }
        
        let maxWidth = width;
        let maxHeight = self.size.height;
        var newImageSize = self.size;
        if (self.size.width > maxWidth) {
            newImageSize.height = newImageSize.height * maxWidth / newImageSize.width;
            newImageSize.width = maxWidth;
        }
        if (newImageSize.height > maxHeight) {
            newImageSize.width = newImageSize.width * maxHeight / newImageSize.height;
            newImageSize.height = maxHeight;
        }
        UIGraphicsBeginImageContext(newImageSize);
        self.draw(in: CGRect(x: 0, y: 0, width: newImageSize.width, height: newImageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!;
    }
    
    
    class func originalImage(named name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
    

    static var placeholderLaunch: UIImage? {
        return UIImage.init(named: "launch")
    }

    static var placeholderCourse: UIImage? {
        return UIImage.init(named: "placeholder_course")
    }
    
    static var placeholderGroupCourse: UIImage? {
        return UIImage.init(named: "placeholder_group_course")
    }
    
    static var PlaceHolderAvatar: UIImage? {
        return UIImage.init(named: "placeholder_avatar")
    }
    static var PlaceHolderBanner: UIImage? {
        return UIImage.init(named: "placeholder_banner")
    }
    static var PlaceHolderFeeding: UIImage? {
        return UIImage.init(named: "placeholder_feeding")
    }
    static var PlaceHolderFeedingInfo: UIImage? {
        return UIImage.init(named: "placeholder_feeding_info")
    }
    static var PlaceHolderGym: UIImage? {
        return UIImage.init(named: "placeholder_gym")
    }
    static var PlaceHolderStore: UIImage? {
        return UIImage.init(named: "placeholder_store")
    }
    static var PlaceHolderToBeTrainer: UIImage? {
        return UIImage.init(named: "placeholder_to_be_trainer")
    }
    static var PlaceHolderTrainerInfo: UIImage? {
        return UIImage.init(named: "placeholder_feeding_info")
    }
    static var PlaceHolderMine: UIImage? {
        return UIImage.init(named: "placeholder_mine")
    }
    static var PlaceHolderMedal: UIImage? {
        return UIImage.init(named: "medal_placeholder")
    }
    static var PlaceHolderSelfHelp: UIImage? {
        return UIImage.init(named: "placeholder_selfhelp")
    }
    
}

extension UIImage {
    func blur(with level: CGFloat) -> UIImage? {
        return UIImage.blurryImage(self, withBlurLevel: level)
    }
    
    func blur(mask level: CGFloat) -> UIImage? {
        return UIImage.blurryImage(self, withMaskImage: self, blurLevel: level)
    }
    
    var majorColor: UIColor? {
        return UIImage.mostColor(self)
    }
}

extension UIImage {
    
    class func gradientImage(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: [startColor.cgColor,endColor.cgColor] as CFArray, locations: nil)
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

let DefaultTabbarShadowImage = UIImage.init(named: "tabbar_shadow_image")

let DefaultNavbarShadowImage = UIImage.gradientImage(startColor: UIColor.black.withAlphaComponent(0.06),
                                               endColor: UIColor.black.withAlphaComponent(0.0),
                                               startPoint: CGPoint.init(x: Layout.ScreenWidth / 2, y: 0),
                                               endPoint: CGPoint.init(x: Layout.ScreenWidth / 2, y: 1.5),
                                               size: CGSize.init(width: Layout.ScreenWidth, height: 1.5))

