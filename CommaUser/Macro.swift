//
//  Macro.swift
//  CommaUser
//
//  Created by Marco Sun on 16/4/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

//MARK: 定义
typealias EmptyClosure = () -> Void
typealias Dic          = [String: Any]?

let APP             = UIApplication.shared.delegate as! AppDelegate
let AppName         = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
let AppVersion      = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let AppBuildVersion = Bundle.main.infoDictionary![String(kCFBundleVersionKey)] as! String

var AppUser: UserModel { return UserManager.shared.user }
var AppTimestamp: TimestampModel { return BaseConfigManager.shared.timestampModel }
var AppBaseConfig: BaseConfigModel { return BaseConfigManager.shared.baseConfigModel }
var CurrentGym: CoursesGymModel { return UserManager.shared.currentGym }
var CurrentGymID: String { return UserManager.shared.currentGymID }


var placeHolderString: String { return "" }

//首页index
let CoursesIndex = 0
let MyTrainingIndex = 1
let MineIndex = 2

/// 默认场馆的id
let DefaultGymID = "0"
/// 默认登录后返回的gymid
let DefaultUserModelGymID = "0"

/// 标准defaults
let StandardDefaults = UserDefaults.standard
let ScreenBounds     = UIScreen.main.bounds

let InvalidInteger: Int        = -199004 // 随机取的一个服务器不会返回的负数作为无效数据
// 1M内存
let memory_size_M: Int64 = 1024 * 1024
// 1KB内存
let memory_size_KB: Int64 = 1024

//MARK: 全局方法
//设计稿是4.7寸的,大于4.7寸时不缩放
func convertWidth(_ width:CGFloat)->CGFloat{
    return Layout.ScreenWidth < Layout.width_4_inch ? Layout.ScreenWidth/Layout.width_4_7_inch * width : width
}

func convertHeight(_ height:CGFloat)->CGFloat{
    return Layout.ScreenHeight < Layout.height_4_inch ? Layout.ScreenHeight/Layout.height_4_7_inch * height : height
}

//设计稿是4.7寸的,此处scale指缩放与否
func coverVerMargin(_ scale:Bool, length:CGFloat) ->CGFloat{
    return length == 0 ? 0:(scale ? Layout.ScreenHeight >= Layout.height_4_7_inch ? ((Layout.ScreenHeight - Layout.TopBarHeight)/(Layout.height_4_7_inch - Layout.TopBarHeight) * length) : fabs(length)/length * 8 : length)
}

func coverVerMarginScale(_ length:CGFloat) -> CGFloat{
    return coverVerMargin(true,length: length)
}

func i2S(_ x:NSString) ->NSString{
    return NSString(format: "%ld", x)
}

func CGSizeMake(_ diameter: CGFloat) -> CGSize {
    return CGSize(width: diameter, height: diameter)
}

func CGRectMakeX(_ x: CGFloat) -> CGRect {
    return CGRect(x: x, y: 0, width: 0, height: 0)
}

func CGRectMakeY(_ y: CGFloat) -> CGRect {
    return CGRect(x: 0, y: y, width: 0, height: 0)
}

func CGRectMakeWidth(_ width: CGFloat) -> CGRect {
    return CGRect(x: 0, y: 0, width: width, height: 0)
}

func CGRectMakeHeight(_ height: CGFloat) -> CGRect {
    return CGRect(x: 0, y: 0, width: 0, height: height)
}

func UIEdgeInsetsMakeVer(_ ver: CGFloat, hor: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(ver, hor, ver, hor)
}

func UIEdgeInsetsMake(_ padding: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(padding, padding, padding, padding)
}

func centerOfRect(_ rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}

func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// create a static method to get a swift class for a string name
func swiftClassFromString(_ className: String) -> Any.Type! {
    // get the project name
    if  let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        // generate the full name of your class (take a look into your "YourProject-swift.h" file)
        let classStringName = appName + "." + className
        // return the class!
        return NSClassFromString(classStringName)
    }
    return nil;
}

// MARK: log
func dLog(_ message: Any, filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        print("[\(NSURL(string: filename)?.lastPathComponent ?? ""):\(line)] \(function) - \(message)")
    #endif
}

func uLog(_ message: Any, filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let alertView = UIAlertView(title: "[\(NSURL(string: filename)?.lastPathComponent ?? ""):\(line)]", message: "\(function) - \(message)",  delegate:nil, cancelButtonTitle:"OK")
    alertView.show()
    #endif

}


class Tuple: NSObject {
    
    class func `init`(indexPath: IndexPath) -> (Int, Int) {
        return (indexPath.section, indexPath.row)
    }
}
