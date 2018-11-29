//
//  Jumper.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/12.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import SDWebImage

/// 用来处理登录和登出的类

struct Jumper {
    
    // MARK: - login
    
    /**
     登录态失效时候调用以及点登录的时候调用
     */
    static func jumpToLogin(_ needToFirstPage: Bool = false) {
        
        if LoginController.isAppeared {
            return
        }
        
        func toLogin(_ vc: UIViewController?) {
            let loginVC = LoginController()
            let root = NavigationController(rootViewController: loginVC)
            LoginController.isAppeared = true
            vc?.present(root, animated: true) {
                LoginController.isAppeared = false
                self.clearBeforeLogin()
            }
        }
        
        if needToFirstPage {
            // select first page
            APP.tabBarController.selectedIndex = CoursesIndex
            if let vc = APP.tabBarController.presentedViewController {
                vc.dismiss(animated: false, completion: nil)
                DispatchQueue.main.async {
                    toLogin(APP.tabBarController)
                }
            } else {
                DispatchQueue.main.async {
                    toLogin(APP.tabBarController)
                }
            }
            return
        }
        // won't to first page
        DispatchQueue.main.async {
            toLogin(APP.topController)
        }
    }
    
    

    

    
    

    
    static func logout() {
        HitMessage.showLoading()
        NetWorker.delete(ServerURL.Logout.r(GlobalAction.JPushRegistrationID ?? "0"), success: { (dataObj) in
            HitMessage.showSuccessWithMessage(Text.LogoutSuccess)
            self.handleForLogoutSuccess()
        }, error: { (statusCode, message) in
            HitMessage.showErrorWithMessage(Text.LogoutFailure)
        }) { (error) in
            HitMessage.showNetErrorMessage()
            
        }
    }
    
    
    static func handleForLogoutSuccess() {
        toFirstPage()
        //删除userdefaults里的数据
        StandardDefaults.removeAll()
        // 清空单例模型
        clearManagers()
        // 清除图片缓存
        clearImages()
        // 清除手环相关的数据
        BraceletManager.shared.reset()
        
        //在这里处理清除缓存在沙盒里的东西（归档）(如果有的话)
        
        NotificationCenter.default.post(name: NotiKey.LogoutSuccess, object: nil)
    }
    
    static func clearBeforeLogin() {
        toFirstPage()
        //删除userdefaults里的数据
        StandardDefaults.removeAll()
        // 清空单例模型
        clearManagers()
    }
    
    static func toFirstPage() {
        if !APP.rootIsTabVC {
            APP.window?.rootViewController = APP.tabBarController
        }
    }
    
    static func clearManagers() {
        //重要： BaseConfigModel不重置
        //重要： 地理位置不重置
        UserManager.resetUserModel() // 记得要重置用户模型
        dLog(AppUser.description)
    }
    
    static func clearImages() {
        SDImageCache.shared().clearDisk()
        SDImageCache.shared().clearMemory()
    }
    
}




