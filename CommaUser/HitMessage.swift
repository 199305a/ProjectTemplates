//
//  HitMessage.swift
//  CommaUser
//
//  Created by Marco Sun on 16/4/18.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import MBProgressHUD


struct HitMessage {
    
    // 当前view
    static var currentView: UIView? {
        let view = GlobalAction.topView ?? AlertManager.view
        if !showAlertViews.contains(view) {
            showAlertViews.append(view)
        }
        return view
    }
    
    //展示alert的view的数组
    static var showAlertViews: [UIView] = []
    
    @discardableResult
    static func showLoading(title: String = "") -> MBProgressHUD? {
        if let view = currentView {
            let hud = LFProgressHUD.showLoading(view)
            if !title.isEmpty {
                hud.label.text = title
                hud.label.textColor = UIColor.white
            }
            return hud
        }
        return nil
    }
    
    @discardableResult
    static func dismiss(_ complete: EmptyClosure? = nil) -> Bool {
        var flag: Bool = false
        showAlertViews.forEach { (view) in
            flag = LFProgressHUD.dismiss(view, complete: complete)
        }
        showAlertViews.removeAll()
        return flag
        
    }
    
    @discardableResult
    static func showNetErrorMessage() -> MBProgressHUD? {
        if let view = currentView {
            return LFProgressHUD.showNetErrorMessage(view)
        }
        return nil
    }
    
    @discardableResult
    static func showServerErrorMessage() -> MBProgressHUD? {
        if let view = currentView {
            return LFProgressHUD.showServerErrorMessage(view)
        }
        return nil
    }
    
    static func showClickedNetErrorMessage() {
        if currentView != nil {
            LFAlertView.showClickNetworkError()
        }
    }
    
    @discardableResult
    static func showWithMessage(_ message: String) -> MBProgressHUD? {
        if let view = currentView {
            return LFProgressHUD.showWithMessage(view, message: message)
        }
        return nil
    }
    
    @discardableResult
    static func showInfoWithMessage(_ message: String) -> MBProgressHUD? {
        if let view = currentView {
            return LFProgressHUD.showInfoWithMessage(view, message: message)
        }
        return nil
    }
    
    @discardableResult
    static func showErrorWithMessage(_ message: String) -> MBProgressHUD? {
        if let view = currentView {
            return LFProgressHUD.showErrorWithMessage(view, message: message)
        }
        return nil
    }
    
    @discardableResult
    static func showSuccessWithMessage(_ message: String) -> MBProgressHUD? {
        if let view = currentView {
            return LFProgressHUD.showSuccessWithMessage(view, message: message)
        }
        return nil
    }
    
    @discardableResult
    static func fixMsg4message(_ message: String, placeHolderMsg: String) -> String {
        if String.isEmptyString(message) {
            return placeHolderMsg
        }
        
        return message
    }
    
}
