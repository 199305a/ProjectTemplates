//
//  NotiKey.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import Foundation

struct NotiKey {
    // 更新定位
    static let LocationUpdated                    = Notification.Name.init("LocationUpdated")
    // 支付宝支付完成
    static let AlipayPayDone                      = Notification.Name.init("AlipayPayDone")
    // 微信支付完成
    static let WXPayDone                          = Notification.Name.init("WXPayDone")
    // 免金额支付完成
    static let FreeMoneyPayDone                   = Notification.Name.init("FreeMoneyPayDone")
    // 支付完成
    static let PayDone                            = Notification.Name.init("PayDone")
    // 私教课支付完成
    static let PrivateClassPayDone                = Notification.Name.init("PrivateClassPayDone")
    // 手环支付完成
    static let BraceletPayDone                     = Notification.Name.init("BraceletPayDone")
    // 买卡支付完成
    static let BuyCardPayDone                     = Notification.Name.init("BuyCardPayDone")
    // 买团体课支付完成
    static let FeeTeamCoursePayDone               = Notification.Name.init("FeeTeamCoursePayDone")
    // 买小团操课支付完成
    static let LittleGroupTeamCoursePayDone               = Notification.Name.init("LittleGroupTeamCoursePayDone")
    // 登出成功
    static let LogoutSuccess                      = Notification.Name.init("LogoutSuccess")
    // 登录成功
    static let LoginSuccess                       = Notification.Name.init("LoginSuccess")
    // 基础配置成功
    static let BaseConfigSuccess                  = Notification.Name.init("BaseConfigSuccess")
    // 切换门店
    static let ChangedStore                       = Notification.Name.init("ChangedStore")
    // 手动取消登录
    static let ManualUnlogin                      = Notification.Name.init("ManualUnlogin")
    // 登录控制器消失或者销毁时候
    static let LoginControllerDismissed           = Notification.Name.init("LoginControllerDismissed")
    // 一个view上面没有其他的LFAlertView的时候发起
    static let NoOtherLFAlert           = Notification.Name.init("NoOtherLFAlert")
    // 利用alt扩展需要延迟加载的通知
    static let DelayAlertNotification           = Notification.Name.init("DelayAlertNotification")
    // 完成了填写资料
    static let UserInfosCompleted           = Notification.Name.init("UserInfosCompleted")

}




