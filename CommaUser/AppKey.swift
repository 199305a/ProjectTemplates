//
//  AppKey.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import Foundation

// app环境，上线前切换到production

#if Dev
var AppEnv: ProjectEnvironment = .dev
#elseif Beta
let AppEnv: ProjectEnvironment = .beta
#elseif Alpha
let AppEnv: ProjectEnvironment = .alpha
#else
let AppEnv: ProjectEnvironment = .production
#endif

//let AppEnv: ProjectEnvironment = .dev

var DebugMode: Bool {
    return AppEnv != .production
}

struct AppKey {
    
    static let AppPlatform = "ios"
    static let AppScheme = "CommaUser"
    static let AppStoreAppID = "1352235192"
    static let ServerAppID = "20002"
    
    // 后台给的key
    static var AppKey: String {
        return DebugMode ? "keykeykeykeykeykeykeykeykeykey11" : "19AYTeOy4Gt61lQmztk33GqPD4m4fUhf"
    }
    // 高德地图 // app store 版本
    static var GaoDeMapKey: String {
        return DebugMode ? "10932d94ccc537c59f59427e3acc2567" : "5127fe112bd803d82031a21ab026356b"
    }
    // 微信ID
    static var WeChatAppID: String {
        return DebugMode ? "wxf2609f2eb9cf192a" : "wx3a277026a765cfef"
    }
    
    // 微信Key
    static var WeChatKey: String {
        return DebugMode ? "nGHNCKzHwJPY2vuUZ8RDXoWqzioB25ur" : "wNO2uGfKZDP5ShLCXmU4ypTlFH0zR8vd"
    }
    // 微信partnerID
    static var WeChatMCHID: String {
        return DebugMode ? "1503297501" : "1502465761"
    }
    
    // 友盟Key
    static var UMengKey: String {
        return DebugMode ? "5ad6c01af43e486f40000055" : "5ad6bfdca40fa35d8c0001eb"
    }
    
    // 友盟频道
    static var UMengChannel: String {
        return DebugMode ? "Ad Hoc" : "App Store"
    }
    
    // 极光推送
    static var JPushAppKey: String {
        return DebugMode ? "493e59e5b3171613c1c22c7d" : "fe9775a90bbede23074faabd"
    }
    // 推送频道
    static var JPushChannel: String {
        return DebugMode ? "Ad Hoc" : "App Store"
    }
    // 推送是否生产环境
    static var JPushIsProducation: Bool {
        return !DebugMode
    }
   //听云AppKey
    static var tingyunAppKey:String {
        return "e0da2783bf6d4e1a930d028a6399ddbe"
    }
    
}

enum ProjectEnvironment {
    case alpha, beta, dev, production
    
    var desc: String {
        switch self {
        case .alpha:
            return "alpha"
        case  .beta:
            return "beta"
        case  .dev:
            return "dev"
        case .production:
            return "production"
        }
    }
}
