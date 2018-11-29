//
//  GlobalAction.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/21.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import RxCocoa

class GlobalAction: NSObject {
    
    
    static var isLogin: Bool {
        return AppUser.hasToken
    }
    
    static var isFirstLaunch: Bool {
        return !hasUUID
    }
    
    static var updatedVersion: Bool {
        return false
    }
    
    static var hasUUID: Bool {
        if let _ = StandardDefaults.value(forKey: DefaultsKey.UUID) as? String { return true }
        return false
    }
    static var UUID: String? {
        return StandardDefaults.value(forKey: DefaultsKey.UUID) as? String
    }
    
    static var deviceToken: String? {
        return StandardDefaults.value(forKey: DefaultsKey.DeviceToken) as? String
    }
    
    static var JPushRegistrationID: String? {
        return String.isNotEmptyString(JPUSHService.registrationID()) ? JPUSHService.registrationID() : nil
    }
    
    static var deviceVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var systemVersion: Float {
        let os = ProcessInfo().operatingSystemVersion
        return Float(os.majorVersion) + Float(os.minorVersion) / 10
    }
    
    // 升级之后第一次加载
    static var isUpdatedAndFirstLaunch: Bool {
        if let version = StandardDefaults.value(forKey: DefaultsKey.CurrentVersion) as? String, version == AppVersion {
            return false
        }
        return true
    }
    
    static var formatter: DateFormatter = {
        let tmp = DateFormatter.init()
        tmp.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return tmp
    }()
    
    static var topView: UIView? { return APP.topController?.view }
    
    /**
     获取时间戳，服务器当前时间
     */
    static var serverTimestamp: Int  {
        return Int(Date.init().timeIntervalSince1970) + AppTimestamp.timeDelta
    }
    
    /**
     打某人电话
     */
    class func call(_ number : String) -> Void {
        
        guard String.isNotEmptyString(number) else {
            return
        }
        let alert = LFAlertView.init(title: nil, message: Text.MakeSureCall, items: [Text.Cancel, Text.Sure])
        alert.show()
        alert.action = { index in
            guard index != 0 else { return }
            let url = Foundation.URL(string: "tel:" + number)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
        
    }
    
    
    
    
    /**
     先返回nav root，再pop
     */
    class func popToRootAndPushToVC(_ currentVC: UIViewController?, destinationVC: UIViewController) -> Void {
        
        guard let vc = currentVC?.navigationController else {
            return
        }
        vc.popToRootViewController(animated: false)
        destinationVC.hidesBottomBarWhenPushed = true
        vc.pushViewController(destinationVC, animated: true)
    }
    
    
    /**
     先返回nav root，再pop
     */
    class func popToRootSecondAndPushToVC(_ currentVC: UIViewController?, destinationVC: UIViewController) -> Void {
        
        guard let vc = currentVC?.navigationController else {
            return
        }
        if vc.viewControllers.count > 1 {
            vc.popToViewController(vc.viewControllers[1], animated: false)
            destinationVC.hidesBottomBarWhenPushed = true
            vc.pushViewController(destinationVC, animated: true)
        }
    }
    
    
    class func popToRootThridAndPushToVC(_ currentVC: UIViewController?, destinationVC: UIViewController) -> Void {
        
        guard let vc = currentVC?.navigationController else {
            return
        }
        if vc.viewControllers.count > 2 {
            vc.popToViewController(vc.viewControllers[2], animated: false)
            destinationVC.hidesBottomBarWhenPushed = true
            vc.pushViewController(destinationVC, animated: true)
        }
    }
    
    class func popToRootAndSelectedTab(index: Int) -> Void {
        APP.tabBarController.selectedIndex = index
    }
    

    
    /**
     判断一个字符串是否是数字
     */
    class func isNumber(_ str: String?) -> Bool {
        
        guard String.isNotEmptyString(str) else { return false }
        
        let number =  Int.init(str!)
        
        if let _ = number { return true }
        
        let doubleNumber = Double.init(str!)
        
        if let _ = doubleNumber { return true }
        
        return false
    }
    
    class func handleWhenSuccess(_ complete: @escaping EmptyClosure) {
        HitMessage.showSuccessWithMessage(Text.MsgSuccess)
        delayPerform(complete)
    }
    
    class func delayPerform(_ task: @escaping EmptyClosure) {
        delayPerformOnMainQueue(0.5, task: task)
    }
    
    class func delayPerformOnMainQueue(_ second: Double, task: @escaping EmptyClosure) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(second * 1000.0)), execute: task)
    }
    
    class func toAppStore() {
        let url = "itms-apps://itunes.apple.com/app/id" + AppKey.AppStoreAppID
        if UIApplication.shared.canOpenURL(Foundation.URL.init(string: url)!) {
            UIApplication.shared.openURL(Foundation.URL.init(string: url)!)
        }
    }
    
    class func toScoreInAppStore() {
        let url = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(AppKey.AppStoreAppID)"
        if UIApplication.shared.canOpenURL(Foundation.URL.init(string: url)!) {
            UIApplication.shared.openURL(Foundation.URL.init(string: url)!)
        }
    }
    
    
    //将极坐标系上的点的坐标转换为直角坐标系上的坐标
    class func getPosition(center: CGPoint, dist: CGFloat, angle: CGFloat) -> CGPoint {
        let FDEG2RAD = CGFloat(Double.pi / 180.0)
        let point = CGPoint(
            x: center.x + dist * cos(angle * FDEG2RAD),
            y: center.y + dist * sin(angle * FDEG2RAD)
        )
        return point
    }
    
    //MARK: - 将角度转化为弧度
    class func radian(_ angle: Double) -> CGFloat {
        return CGFloat(Double.pi / 180.0) * CGFloat(angle)
    }
    
    //MARK: - 比较版本大小
    class func compare(_ version1: String, to version2: String) -> StringCompareResult {
        var versionNumArr1 = version1.components(separatedBy: ".").map { (str) -> Int in
            return Int(str) ?? 0
        }
        var versionNumArr2 = version2.components(separatedBy: ".").map { (str) -> Int in
            return Int(str) ?? 0
        }
        
        let intervalCount = versionNumArr1.count - versionNumArr2.count
        if intervalCount < 0 {
            versionNumArr1 += [Int].init(repeating: 0, count: -intervalCount)
        } else {
            versionNumArr2 += [Int].init(repeating: 0, count: intervalCount)
        }
        
        for (i,num) in versionNumArr1.enumerated() {
            let interval = num - versionNumArr2[i]
            if interval != 0 {
                let value = interval / abs(interval)
                return StringCompareResult.init(rawValue: value) ?? .equal
            }
        }
        return .equal
    }
}

enum StringCompareResult {
    
    init?(rawValue: Int) {
        switch rawValue {
        case let value where value > 0 :
            self = .greater
        case let value where value < 0:
            self = .less
        case 0:
            self = .equal
        default:
            return nil
        }
    }
    
    case less, equal, greater
}

