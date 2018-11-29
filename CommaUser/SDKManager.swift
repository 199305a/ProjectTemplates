//
//  SDKManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/6.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FCUUID
import Fabric
import Crashlytics

var SDK_Over_iOS11: Bool {
    return SDKManager.SDKVersion >= 11.0
}

var SDK_Over_iOS10: Bool {
    return SDKManager.SDKVersion >= 10.0
}

var SDK_Over_iOS9: Bool {
    return SDKManager.SDKVersion >= 9.0
}

var is_iOS11: Bool {
    return Int(SDKManager.SDKVersion) == 11
}

var is_iOS10: Bool {
    return Int(SDKManager.SDKVersion) == 10
}

var is_iOS9: Bool {
    return Int(SDKManager.SDKVersion) == 9
}

struct SDKManager {
    
    // 系统版本，注意请不要修改它！
    static var SDKVersion: Float = {
        let os = ProcessInfo().operatingSystemVersion
        return Float(os.majorVersion) + Float(os.minorVersion) / 10
    }()
    
    
    static func configureSDKWithOptions(_ launchOptions: [AnyHashable: Any]?) {
       //听云SDK
        NBSAppAgent.start(withAppID: AppKey.tingyunAppKey)
        NBSAppAgent.setUserIdentifier(AppUser.user_name)
        NBSAppAgent.leaveBreadcrumb(#function)
        
        // 注册 UUID
        if StandardDefaults.value(forKey: DefaultsKey.UUID) == nil {
            let uuid = FCUUID.uuidForDevice()
            StandardDefaults.setValue(uuid, forKey: DefaultsKey.UUID)
        }
        
        // 键盘监听
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // 微信
        WXApi.registerApp(AppKey.WeChatAppID)
        
        // 地图
        AMapServices.shared().apiKey = AppKey.GaoDeMapKey
        
        // 崩溃统计
        Fabric.with([Crashlytics.self])
        Crashlytics.sharedInstance().setUserIdentifier(AppUser.token)
        Crashlytics.sharedInstance().setUserName(AppUser.user_name)
        
        // 友盟统计
        UMAnalyticsConfig.sharedInstance().appKey = AppKey.UMengKey
        UMAnalyticsConfig.sharedInstance().channelId = AppKey.UMengChannel
        MobClick.setAppVersion(AppVersion)
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        MobClick.setEncryptEnabled(true)
        
    }
    
    
}
