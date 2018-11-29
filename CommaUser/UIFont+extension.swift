//
//  UIFont+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

extension UIFont {
    static var bold17: UIFont {
        return boldAppFontOfSize(17)
    }
    
    static var bold20: UIFont {
        return boldAppFontOfSize(20)
    }
    
    static var bold15: UIFont {
        return boldAppFontOfSize(15)
    }
    
    static var bold13: UIFont {
        return boldAppFontOfSize(13)
    }

    static var bold12: UIFont {
        return boldAppFontOfSize(12)
    }
    
    static var font9: UIFont {
        return appFontOfSize(9)
    }
    
    static var font12: UIFont {
        return appFontOfSize(12)
    }
    
    static var font15: UIFont {
        return appFontOfSize(15)
    }
    
    static var ImpactFont45: UIFont? {
        return UIFont.init(name: "Impact", size: 45)
    }
    
    static var ImpactFont25: UIFont? {
        return UIFont.init(name: "Impact", size: 25)
    }
    
    
    class func impactFontOf(size: CGFloat) -> UIFont {
        return UIFont.init(name: Text.Impact, size: size) ?? appFontOfSize(size)
    }
    
    class func PingFangSCMediumFontOf(size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Medium", size: size) ?? appFontOfSize(size)
    }
    
    class func DINProBlackFontOf(size: CGFloat) -> UIFont {
        return UIFont.init(name: "DINPro-Black", size: size) ?? appFontOfSize(size)
    }
    
    class func DINProBoldFontOf(size: CGFloat) -> UIFont {
        return UIFont.init(name: "DINPro-Bold", size: size) ?? appFontOfSize(size)
    }
    
    class func appFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func boldAppFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    class func scaleAppFontOfSize(_ fontSize: CGFloat) -> UIFont {
        var size: CGFloat = 1
        if Layout.ScreenWidth < 375 {
            size = 0.86
        }
        size = size * fontSize
        let tmp = Int.init(size)
        size = CGFloat.init(tmp)
        
        return UIFont.systemFont(ofSize: size)
    }

    class func scaleBoldAppFontOfSize(_ fontSize: CGFloat) -> UIFont {
        var size: CGFloat = 1
        if Layout.ScreenWidth < 375 {
            size = 0.86
        }
        size = size * fontSize
        let tmp = Int.init(size)
        size = CGFloat.init(tmp)
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    func blodFont() -> UIFont {
        let fontDesc = fontDescriptor
        let fontDescriptorSymbolicTraits = UIFontDescriptorSymbolicTraits.init(rawValue:(fontDesc.symbolicTraits.rawValue | UIFontDescriptorSymbolicTraits.traitBold.rawValue))
        let boldFontDesc = fontDesc.withSymbolicTraits(fontDescriptorSymbolicTraits)
        return UIFont.init(descriptor: boldFontDesc!, size: pointSize)
    }
    
    var layoutFont: UIFont {
        var size: CGFloat = Layout.scale(self.pointSize)
        let tmp = Int.init(size)
        size = CGFloat.init(tmp)
        return UIFont.appFontOfSize(size)
    }
    
//    UIFont.familyNames.forEach { (str) in
//    debugPrint("fontFamily--" + str)
//    let font = UIFont.fontNames(forFamilyName: str)
//    debugPrint("fontName-- \(font)")
//    }
    
    
}
