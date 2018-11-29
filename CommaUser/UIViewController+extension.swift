//
//  File.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/19.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func popAnimated() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func pop() {
        _ = navigationController?.popViewController(animated: false)
    }
    
    func pushAnimated(_ ctr: UIViewController) {
        navigationController?.pushViewController(ctr, animated: true)
    }
    
    func push(_ ctr: UIViewController) {
        navigationController?.pushViewController(ctr, animated: false)
    }
    
    
    class func getCurrentController() -> UIViewController? {
        
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        return getCurrentControllerInWindow(window: window)
    }
    
    class func getNearestController() -> UIViewController? {
        
        for window in UIApplication.shared.windows.reversed() {
            if let vc = getCurrentControllerInWindow(window: window) {
                return vc
            }
        }
        return nil
    }
    
    class func getCurrentControllerInWindow(window: UIWindow) -> UIViewController? {
        
        var tempView: UIView?
        
        for subview in window.subviews.reversed() {
            
            
            if subview.classForCoder.description() == "UILayoutContainerView" {
                
                tempView = subview
                
                break
            }
        }
        
        if tempView == nil {
            
            tempView = window.subviews.last
        }
        
        var nextResponder = tempView?.next
        
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController || nextResponder?.classForCoder == NSClassFromString("UIInputWindowController")
        }
        
        while next{
            
            tempView = tempView?.subviews.first
            
            if tempView == nil {
                
                return nil
            }
            
            nextResponder = tempView!.next
        }
        
        return nextResponder as? UIViewController
        
    }
}

// HUD extension
extension UIViewController {
    
    var hudSubView: MBProgressHUD? {
        for hud in self.view.subviews.reversed() {
            if  hud is MBProgressHUD {
                return hud as? MBProgressHUD
            }
        }
        return nil
    }
    
    @discardableResult
    func showLoading(title: String = "") -> MBProgressHUD {
        let hud = LFProgressHUD.showLoading(view)
        if !title.isEmpty {
            hud.label.text = title
            hud.label.textColor = UIColor.white
        }
        return hud
    }
    
    @discardableResult
    func hideHUD(_ animate: Bool = true) -> Bool {
        return LFProgressHUD.dismiss(view)
    }
    
    @discardableResult
    func showNetErrorMessage() -> MBProgressHUD {
        return LFProgressHUD.showNetErrorMessage(view)
    }
    
    @discardableResult
    func showServerErrorMessage() -> MBProgressHUD {
        return LFProgressHUD.showServerErrorMessage(view)
    }
    
    
    func showClickedNetErrorMessage() {
        return LFProgressHUD.showClickedNetErrorMessage(view)
    }
    
    @discardableResult
    func showWithMessage(_ message: String?) -> MBProgressHUD {
        return LFProgressHUD.showWithMessage(view, message: message)
    }
    
    @discardableResult
    func showInfoWithMessage(_ message: String?) -> MBProgressHUD {
        return LFProgressHUD.showInfoWithMessage(view, message: message)
    }
    
    @discardableResult
    func showErrorWithMessage(_ message: String?) -> MBProgressHUD {
        return LFProgressHUD.showErrorWithMessage(view, message: message)
    }
    
    @discardableResult
    func showSuccessWithMessage(_ message: String?) -> MBProgressHUD {
        return LFProgressHUD.showSuccessWithMessage(view, message: message)
    }
    
    @discardableResult
    func showTextMessage(_ message: String?) -> MBProgressHUD {
        return LFProgressHUD.showTextMessage(view, message: message)
    }
    
    func hiddenLastHUD() {
        let hud = self.hudSubView
        hud?.removeFromSuperViewOnHide = true
        hud?.isHidden = true
    }
}


extension UIViewController {
    
    func setNavigationBar(color: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color), for: .default)
        imageColor = color
    }
    
    func setNavigationBar(image: UIImage?) {
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    
    private static var imageColorKey: UInt8 = 0
    var imageColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &UIViewController.imageColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIViewController.imageColorKey) as? UIColor
        }
    }
    
}

extension UIViewController {
    // MARK: - 在有tabController以及PhoneX的情况下， 修正tabBar的frame
    func correctTabBarFrame() {
        if let tabBar = tabBarController?.tabBar, Layout.is_window_5_8_inch {
            tabBar.frame.origin.y = Layout.ScreenHeight - tabBar.height
        }
    }
}

// 蓝牙弹框
extension UIViewController {
    func alertToOpenBluetooth() {
        if #available(iOS 11.0, *) {
            let alert = UIAlertController(title: nil, message: Text.OpenBluetoothNotice, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Text.Known, style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            _ = CBCentralManager()
        }
    }
}


