//
//  PushManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/6.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import UserNotifications
import UIDeviceIdentifier

class PushManager: NSObject {
    
    static let shared = PushManager()
    fileprivate override init() {}
    
    static var model = PushModel()
    
    // MARK: - 注册推送服务
    class func registerDeviceToken(_ deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        let deviceTokenStr = deviceToken.hexStr
        let oldToken = StandardDefaults.value(forKey: DefaultsKey.DeviceToken) as? String
        if oldToken == deviceTokenStr { return }
        StandardDefaults.setValue(deviceTokenStr, forKey: DefaultsKey.DeviceToken)
    }
    
    // MARK: - 给服务器推用户信息
    class func reportDeviceToken() {
        guard GlobalAction.isLogin else { return }
        
        var paras = [String: Any]()
        paras["device_id"] = GlobalAction.UUID
        paras["registration_id"] = GlobalAction.JPushRegistrationID
        paras["device_token"] = GlobalAction.deviceToken
        
        NetWorker.post(ServerURL.UserDevice, params: paras, success: { _ in
            StandardDefaults.setValue(JPUSHService.registrationID(), forKey: DefaultsKey.JPushRegistrationID)
        }, error: { _,_  in }) { _ in}
        
    }
    
    // MARK: - 配置JPush
    class func configureJPush(_ launchOptions: [AnyHashable: Any]?) {
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = Int(UNAuthorizationOptions.badge.rawValue | UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: PushManager.shared)
        } else {
            JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: AppKey.JPushAppKey, channel: AppKey.JPushChannel, apsForProduction: AppKey.JPushIsProducation, advertisingIdentifier: nil)
    }
    
    // MARK: - 重置Badge
    class func resetPushBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
        JPUSHService.resetBadge()
    }
    
    // MARK: - 自定义AppDelegate的Push相关方法
    class func receiveRemoteNotification(_ userInfo: [AnyHashable: Any], withAppState state: UIApplicationState = UIApplication.shared.applicationState) {
        JPUSHService.handleRemoteNotification(userInfo)
        PushManager.resetPushBadge()
        handlePush(userInfo, withAppState: state)
    }
    
    // MARK: - 自定义push处理
    class func handlePush(_ userInfo: [AnyHashable: Any], withAppState state: UIApplicationState) {
        
        let userInfo = userInfo as [AnyHashable: AnyObject]
        
        model = PushModel()
        model.appState = state
        
        let aps = userInfo["aps"] as? [String: Any]
        if let message = aps?["alert"] as? String {
            model.message = message
        } else if let dict = aps?["alert"] as? [String: Any] {
            model.message = dict["body"] as? String
            model.title = dict["title"] as? String
            model.subtitle = dict["subtitle"] as? String
            model.image = (dict["data"] as? [String: Any])?["attachment-url"] as? String
        }
        
        model.direct = userInfo["direct"] as? String
        model.directType = userInfo["direct_type"] as? String
        model.data = userInfo["data"] as? [String: Any]
        if model.message == nil {
            model.message = model.data?["alert"] as? String
        }
        
        switch model.pushDirectType {
        case .unknown:
            jumpToUnknown()
        case .h5:
            jumpToH5()
        case .native:
            jumpToNative()
        case .outer:
            jumperToOuter()
        }
    }
    
    
    class func alertConfirmToVC(vc: UIViewController) {
        guard String.isNotEmptyString(model.message) else { return }
        
        let alert = LFAlertView.init(title: model.title, message: model.message, items: [Text.PushAlertCancel, Text.PushAlertGoCheck])
        alert.show()
        alert.action = {  index in
            switch index {
            case 1:
                toShow(vc: vc)
            default:
                break
            }
        }
    }
    
    class func show(vc: UIViewController, handleShowInForeground: Bool) {
        
        guard String.isNotEmptyString(model.message) else { return }
        
        // 如果app在前台
        if model.appState == .active {
            if !handleShowInForeground { return }
            // 在前台收到
            let pushView = CustomPushView()
            pushView.model = model
            pushView.show()
            pushView.click = {
                toShow(vc: vc)
            }
            return
        }
        // 在后台
        toShow(vc: vc)
        
    }
    
    class func handleTask(task: EmptyClosure?)  {
        if model.appState == .active {
            let pushView = CustomPushView()
            pushView.model = model
            pushView.show()
            pushView.click = {
                task?()
            }
            return
        }
        task?()
    }
    
    class func toShow(vc: UIViewController, tryCount: Int = 0) {
        var index = tryCount
        
        if index > 30 {
            return
        }
        
        func retry(vc: UIViewController, tryTimes: Int) {
            var idx = tryTimes
            GlobalAction.delayPerform {
                idx += 1
                toShow(vc: vc, tryCount: idx)
            }
        }
        
        guard let window = APP.window else {
            retry(vc: vc, tryTimes: index)
            return
        }
        
        guard let current = UIViewController.getCurrentControllerInWindow(window: window) else {
            retry(vc: vc, tryTimes: index)
            return
        }
        if let nav = current.navigationController {
            DispatchQueue.main.async {
                vc.hidesBottomBarWhenPushed = true
                nav.pushViewController(vc, animated: true)
            }
        } else if let nav = current as? NavigationController {
            DispatchQueue.main.async {
                vc.hidesBottomBarWhenPushed = true
                nav.pushViewController(vc, animated: true)
            }
        } else {
            retry(vc: vc, tryTimes: index)
        }
    }
    
}


// MARK: - 处理一级指令
extension PushManager {
    
    // MARK: - 跳转至原生页面
    class func jumpToNative() {
        
        var nativeType: NativeSecondType = .unknown
        if let direct = model.direct, let type = NativeSecondType.init(rawValue: direct) {
            nativeType = type
        }
        switch nativeType {
        case .unknown:
            handleNativeUnknown()
        case .update:
            handleNativeUpdate()
        case .schedule:
            handleNativePush()
        }
    }
    
    // MARK: - 无法识别的一级指令处理
    class func jumpToUnknown() {
        
        guard String.isNotEmptyString(model.message) else { return }
        if model.appState == .active {
            let pushView = CustomPushView()
            pushView.model = model
            pushView.show()
        }
        
    }
    
    // MARK: - 跳转至H5页面
    class func jumpToH5() {
        
        var outerType: HTML5SecondType = .unknown
        if let direct = model.direct, let type = HTML5SecondType.init(rawValue: direct) {
            outerType = type
        }
        switch outerType {
        case .unknown:
            jumpToUnknown()
        case .app:
            handleAPPH5()
        case .default:
            handleDefaultH5()
        }
    }
    
    // MARK: - 跳转至应用外
    class func jumperToOuter() {
        
        var outerType: OuterSecondType = .unknown
        if let direct = model.direct, let type = OuterSecondType.init(rawValue: direct) {
            outerType = type
        }
        switch outerType {
        case .unknown:
            jumpToUnknown()
        }
        
    }
    
}

// MARK: - native push handle
extension PushManager  {
    
    class func handleNativeUpdate() {
        guard let data = model.data else {
            return
        }
        
        func update(data: [String: Any]) {
            let forceUpdate = data["update"] as? Int == 2
            let items =  forceUpdate ? [Text.GoToAppStore] : [Text.Known, Text.GoToAppStore]
            let alert = LFAlertView.init(title: data["title"] as? String, message: data["content"] as? String, items: items)
            alert.action = { index in
                if !forceUpdate {
                    guard index != 0 else { return }
                }
                if forceUpdate {
                    update(data: data)
                }
                GlobalAction.toAppStore()
            }
            alert.show()
        }
        
        update(data: data)

    }
    
    class func handleNativePush() {
        guard let data = model.data else {
            return
        }
        let vc = MyTrainerCourseDetailVC()
        vc.schedule_ID = data["schedule_id"] as? String
//        let vc = WebViewController.init(URLStr: data["url"] as! String)
        show(vc: vc, handleShowInForeground: true)
    }
    
    // MARK: - 处理无法识别的native指令
    class func handleNativeUnknown() {
        
        guard String.isNotEmptyString(model.message) else { return }
        
        handleTask {
            let alert = LFAlertView.init(title: nil, message: Text.UpdateToLook, items: [Text.NotUpdateNow, Text.UpdateNow])
            alert.show()
            alert.action = {  index in
                guard index == 1 else {
                    return
                }
                GlobalAction.toAppStore()
            }
        }
        
    }
}

// MARK: - web push handle
extension PushManager {
    
    class func handleAPPH5() {
        
        guard let urlStr = model.data?["url"] as? String, let _ = URL.init(string: urlStr) else {
            return
        }
        let vc = WebViewController.init(URLStr: urlStr)
        show(vc: vc, handleShowInForeground: true)
    }
    
    class func handleDefaultH5() {
        guard let urlStr = model.data?["url"] as? String, let url = URL.init(string: urlStr) else {
            return
        }
        handleTask {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: - JPush delegate
extension PushManager: JPUSHRegisterDelegate {
    
    // MARK: - JPUSH Register Delegate
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            PushManager.receiveRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.sound.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            PushManager.receiveRemoteNotification(userInfo)
        }
        completionHandler()
    }
}

// MARK: - 一级指令
enum PushDirectType: String {
    case unknown
    case h5 = "h5"
    case native = "native"
    case outer = "outer"
}

// MARK: - 应用外二级指令
enum OuterSecondType: String {
    case unknown
}

// MARK: - H5二级指令
enum HTML5SecondType: String {
    case unknown
    case `default` = "default"
    case app = "app"
}

// MARK: - 原生二级指令
enum NativeSecondType: String {
    case unknown
    case update = "update"
    case schedule = "schedule"

}


class PushModel: BaseModel {
    
    var appState: UIApplicationState?
    
    var directType: String?
    var direct: String?
    var data: [String: Any]?
    
    var message: String?
    var title: String?
    var subtitle: String?
    var image: String?
    
    var pushDirectType: PushDirectType {
        guard let directType = self.directType else {
            return .unknown
        }
        return PushDirectType.init(rawValue: directType) ?? .unknown
    }
    
}

