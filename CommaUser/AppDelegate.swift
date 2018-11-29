//
//  AppDelegate.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/8.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let tabBarController = TabBarController()
    
    var topController: UIViewController? {
        return UIViewController.getCurrentController()
    }
    
    var rootIsTabVC: Bool {
        return window!.rootViewController === tabBarController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 获取城市信息
        obtainCityInfo()
        // 同步时间戳
        NetWorker.syncTimestamp {
            // 检查更新
            BaseConfigManager.checkUpdate()
            // 获取基础配置
            BaseConfigManager.obtainBaseConfig {
                LocationManager.shared.requestOpenCityIdList()
                self.handleVCChanges()
                // 极光推送的配置放在用户切换过root控制器且知道是否移除本地JPUSH ID以后
                PushManager.configureJPush(launchOptions)
                // 取消通知按钮
                PushManager.resetPushBadge()
            }
        }
        // 进行全局基础配置
        APPConfigManager.applicationBaseConfigure()
        // 三方SDK配置
        SDKManager.configureSDKWithOptions(launchOptions)

        if GlobalAction.isLogin {
            BraceletManager.shared.reportData()
        }
        

        self.window = UIWindow.init(frame: ScreenBounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.rootViewController = LaunchController()
        self.window?.makeKeyAndVisible()
        application.setStatusBarHidden(false, with: .fade)
        return true
    }
    
    func handleVCChanges() {
        
        // 过场动画
        let tran = CATransition.init()
        tran.subtype = kCATransitionFromRight
        tran.duration = 0.4
        tran.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        tran.setValue(true, forKey: KeyValues.changedWindowRootController)
        tran.type = kCATransitionPush
        APP.window?.layer.add(tran, forKey: nil)
        self.window?.rootViewController = self.tabBarController
    }
    
    func obtainCityInfo() {
        LocationManager.shared.executeGetRegionFromDisk()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        DataStoreManager.storeDataToDisk()
        if GlobalAction.isLogin {
            BraceletManager.shared.reportData()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NetWorker.syncTimestamp{}
        PushManager.resetPushBadge()
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DataStoreManager.storeDataToDisk()
        
    }
    
    
    // MARK: - Open URL
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        PayManager.shared.handleOpenURL(url, withDelegate: nil)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        PayManager.shared.handleOpenURL(url, withDelegate: nil)
        return true
    }
    
    // MARK: - Push
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushManager.registerDeviceToken(deviceToken)      
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushManager.receiveRemoteNotification(userInfo, withAppState: application.applicationState)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("注册远程推送失败: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if !SDK_Over_iOS10 {
            JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
        }
        
    }
}


