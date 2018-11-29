//
//  UIColor+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

extension UIColor {
    
    // 辅色 发黑
    class var minorColor: UIColor {
        return UIColor.white
    }
    
    // 下面按钮的绿色
    class var lightGreenColor: UIColor {
        return UIColor.hx129faa
    }
    // title的绿色
    class var darkGreenColor: UIColor {
        return UIColorFromRGB(0x23ec7d)
    }
    // 背景色
    class var backgroundColor: UIColor {
        return UIColor.hxf4f8f9
    }
    
    class var separatorColor: UIColor {
        return UIColorFromRGB(0xdddddd)
    }
    class var greyLabelColor: UIColor {
        return UIColorFromRGB(0xcccccc)
    }
    class var indicatorColor: UIColor {
        return UIColorFromRGB(0x37444b)
    }
    
    // 发灰的颜色
    class var hx888b9a: UIColor {
        return UIColorFromRGB(0x888b9a)
    }
    class var hx596167: UIColor {
        return UIColorFromRGB(0x596167)
    }

    class var hx34c86c: UIColor {
        return UIColorFromRGB(0x34c86c)
    }
    
    class var hxdfdddd: UIColor {
        return UIColorFromRGB(0xdfdddd)
    }
    class var hx28ca68: UIColor {
        return UIColorFromRGB(0x28ca68)
    }
    class var hxc2c0c0: UIColor {
        return UIColorFromRGB(0xc2c0c0)
    }
    class var hx969a9e: UIColor {
        return UIColorFromRGB(0x969a9e)
    }

    class var hx00ade6: UIColor {
        return UIColorFromRGB(0x00ade6)
    }
    class var hxf5f5f5: UIColor {
        return UIColorFromRGB(0xf5f5f5)
    }
    class var hxa4a5a6: UIColor {
        return UIColorFromRGB(0xa4a5a6)
    }
    class var hx95979e: UIColor {
        return UIColorFromRGB(0x95979e)
    }
    class var hxdfe0e3: UIColor {
        return UIColorFromRGB(0xdfe0e3)
    }
    class var hx2c2f35: UIColor {
        return UIColorFromRGB(0x2C2F35)
    }
    
    class var hxe7e7e7: UIColor {
        return UIColorFromRGB(0xe7e7e7)
    }

    class var hx2ac89d: UIColor {
        return UIColorFromRGB(0x2ac89d)
    }

    class var hxd6d7d8: UIColor {
        return UIColorFromRGB(0xd6d7d8)
    }
    
    class var hx5c5e6b: UIColor {
        return UIColorFromRGB(0x5C5E6B)
    }
    
    class var hx9b9b9b: UIColor {
        return UIColorFromRGB(0x9b9b9b)
    }
    
    class var hx129faa: UIColor {
        return UIColorFromRGB(0x129faa)
    }
    
    class var hxf4f8f9: UIColor {
        return UIColorFromRGB(0xf4f8f9)
    }
    
    class var hxff564c: UIColor {
        return UIColorFromRGB(0xff564c)
    }
    
    class var hxf8f8f8: UIColor {
        return UIColorFromRGB(0xf8f8f8)
    }
    
    class var hxf7f7f7: UIColor {
        return UIColorFromRGB(0xf7f7f7)
    }
    
    class var hxc1c3c8: UIColor {
        return UIColorFromRGB(0xc1c3c8)
    }
    
    class var hxc4c0c9: UIColor {
        return UIColorFromRGB(0xc4c0c9)
    }

    class var hxededed: UIColor {
        return UIColorFromRGB(0xededed)
    }
    
    class var hx91b6b9: UIColor {
        return UIColorFromRGB(0x91b6b9)
    }

    
    class func hexColor(_ rgbValue: Int) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func rgbColor(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return  UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    class func rgbaColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return  UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    
    class func randomColor() -> UIColor {
        let hue = ( CGFloat(arc4random() % 256) / 256.0 );  //  0.0 to 1.0
        let saturation = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        let brightness = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        return UIColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    /**
     返回两个颜色的混合过渡颜色
     - parameter ratio:      混合比例 0-1取值
     */
    class func mixColor(_ firstColor: UIColor, otherColor: UIColor, ratio: CGFloat = 0.5) -> UIColor {
        var ratio = ratio
        if ratio > 1 {
            ratio = 1
        }
        let comp0 = firstColor.cgColor.components
        let comp1 = otherColor.cgColor.components
        let r = (comp0?[0])! * (1 - ratio) + (comp1?[0])! * ratio
        let g = (comp0?[1])! * (1 - ratio) + (comp1?[1])! * ratio
        let b = (comp0?[2])! * (1 - ratio) + (comp1?[2])! * ratio
        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    /**
     返回混合颜色数组(过渡按照数组count)
     */
    class func mixColors(_ firstColor: UIColor, otherColor: UIColor, count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for index in 1...count {
            let color = UIColor.mixColor(firstColor, otherColor: otherColor, ratio: CGFloat(index) / CGFloat(count))
            colors.append(color)
        }
        return colors
    }
    
}
