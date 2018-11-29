//
//  APPConfigManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/11/2.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
import Reachability

class APPConfigManager: NSObject {
    
    static var lastIsReachable: Reachability.Connection? // 当前网络状态的上一次状态
    static let reachability = Reachability.init()
    
    
    class func applicationBaseConfigure() {
        openNetworkActivityIndicator()
        observeJPushStatus()
        APPConfigManager.observeNetWorkStatus()
    }
    
    // 开启菊花
    class func openNetworkActivityIndicator() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    // 监听推送状态
    class func observeJPushStatus() {
        _ = NotificationCenter.default.rx.notification(NSNotification.Name.jpfNetworkDidLogin).bind { _ in
            let pushID = StandardDefaults.object(forKey: DefaultsKey.JPushRegistrationID) as? String
            // 如果本地有JPUSH ID，则不上报新的内容
            if pushID == JPUSHService.registrationID() { return }
            PushManager.reportDeviceToken() // 给服务器推用户信息
        }
    }
    
    // 监听网路状态
    class func observeNetWorkStatus() {
        try?reachability?.startNotifier()
        _ = NotificationCenter.default.rx.notification(Notification.Name.reachabilityChanged).bind { (_) in
            let enable = reachability?.connection
            if enable != .none && lastIsReachable == .none {
                NetWorker.syncTimestamp{ }
            }
            lastIsReachable = enable
        }
    }
    
}
