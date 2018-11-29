//
//  Layout.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

struct Layout {
    // MARK: - size
    static let NavBarHeight:CGFloat       = 44.0
    static let ToolBarHeight:CGFloat      = 44.0
    static var StatusBarHeight:CGFloat    { return UIApplication.shared.statusBarFrame.size.height }
    static let TabBarHeight: CGFloat      = 49.0
    
    static let ButtonHeight:CGFloat             = 44
    static let ButtonHeight50: CGFloat          = 50
    static let ButtonWidth303: CGFloat          = 303
    static let TextFieldHeight37: CGFloat       = 37
    static let BottomButtonWidthOffset:CGFloat  = -74.0
    static let BottomButtonBottomOffset:CGFloat = -30.0
    static let TagCellHeight:CGFloat            = 27.0
    
    static let MinMargin: CGFloat  = Digit8
    
    static let Digit8: CGFloat  = 8
    static let Digit9: CGFloat  = 9
    static let Digit10: CGFloat = 10
    static let Digit12: CGFloat = 12
    static let Digit15: CGFloat = 15
    static let Digit20: CGFloat = 20
    static let Digit25: CGFloat = 25
    static let Digit30: CGFloat = 30
    static let Digit35: CGFloat = 35
    static let Digit40: CGFloat = 40
    static let Digit45: CGFloat = 45
    static let Digit50: CGFloat = 50
    
    static let MinorButtonHeight: CGFloat = 48
    
    // MARK: - font size
    static let LoginRegFont: CGFloat      = 13
    static let TitleFont:CGFloat = 18
    static let NormalFont:CGFloat = 15
    
    // MARK: - screen_size
    static let ScreenWidth  = ScreenBounds.size.width
    static let ScreenHeight = ScreenBounds.size.height
    static var TopBarHeight: CGFloat { return NavBarHeight + StatusBarHeight }
    
    static let width_3_5_inch:CGFloat  = 320.0
    static let width_4_inch:CGFloat    = 320.0
    static let width_4_7_inch:CGFloat  = 375.0
    static let width_5_5_inch:CGFloat  = 414.0
    static let height_3_5_inch:CGFloat = 480.0
    static let height_4_inch:CGFloat   = 568.0
    static let height_4_7_inch:CGFloat = 667.0
    static let height_5_5_inch:CGFloat = 736.0
    static let height_5_8_inch:CGFloat = 812.0
    
    static let is_window_3_5_inch = ScreenHeight == height_3_5_inch
    static let is_window_4_inch   = ScreenHeight == height_4_inch
    static let is_window_4_7_inch = ScreenHeight == height_4_7_inch
    static let is_window_5_5_inch = ScreenHeight == height_5_5_inch
    static let is_window_5_8_inch = ScreenHeight == height_5_8_inch
    static let is_ge_window_5_8_inch = ScreenHeight >= height_5_8_inch
    
    // MARK: - 根据机型判断
    static var safeAreaInsetsBottom: CGFloat {
        if is_ge_window_5_8_inch {
            return 34
        }
        return 0
    }
    
    static var safeAreaInsetsTop: CGFloat {
        if is_ge_window_5_8_inch {
            return 24
        }
        return 0
    }
    
    // MARK: - 数值--alpha
    static let LineAlpha: CGFloat = 0.35
    static let BackAlpha: CGFloat = 0.3
    
    // MARK: - 动画时间
    static let AnimateDuration:TimeInterval = 0.3
    
    static let ContainerViewHeight: CGFloat = 185.0
    
    static let BottomButtonSize = CGSize(width: Layout.ScreenWidth, height: ButtonHeight)
    
    static func scale(_ length: CGFloat) -> CGFloat {
        return  Layout.ScreenWidth / width_4_7_inch * length
    }
    
    // 按照比例放大缩小
    static func layoutScaleHeight(_ height: CGFloat) -> CGFloat {
        return Layout.ScreenHeight / height_4_7_inch * height
    }
    // 按照比例放大缩小
    
    static func layoutScaleWidth(_ width: CGFloat) -> CGFloat {
        return Layout.ScreenWidth / width_4_7_inch * width
    }
    
    // 超过4.7寸放大1.5倍
    static func layoutScaleHeightOver4_7(_ height: CGFloat) -> CGFloat {
        return Layout.ScreenHeight <= height_4_7_inch ? height : Layout.ScreenHeight / height_4_7_inch * height * 1.5
    }
    // 超过4.7寸放大1.5倍
    static func layoutScaleWidthOver4_7(_ width: CGFloat) -> CGFloat {
        return Layout.ScreenWidth <= width_4_7_inch ? width : Layout.ScreenWidth / width_4_7_inch * width * 1.5
    }
    
    // 按照比例缩小小于4.7时候
    static func layoutScaleHeightLessThan4_7(_ height: CGFloat) -> CGFloat {
        if Layout.ScreenHeight >= height_4_7_inch {
            return height
        }
        return Layout.ScreenHeight / height_4_7_inch * height
    }
    // 按照比例缩小小于4.7时候
    static func layoutScaleWidthLessThan4_7(_ width: CGFloat) -> CGFloat {
        if Layout.ScreenWidth >= width_4_7_inch {
            return width
        }
        return Layout.ScreenWidth / width_4_7_inch * width
    }
}
