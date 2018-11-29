//
//  UIKit+Extensions.swift
//  CommaUser
//
//  This file is used to put extensions of views
//
//  Created by Marco Sun on 16/5/20.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation
import AssetsLibrary
import Photos

extension UIScrollView {
    func addFakeIndicatorIfNeeded(_ disposeBag: DisposeBag) {
        guard let conV = self.superview else {
            return
        }
        
        self.layoutIfNeeded()
        let height = self.height
        let scale = height / self.contentSize.height
        
        if scale < 1 {
            let lineView = BaseView()
            lineView.backgroundColor = UIColor.indicatorColor
            let width: CGFloat = 2
            lineView.layer.cornerRadius = width/2
            
            conV.addSubview(lineView)
            
            lineView.snp.makeConstraints { (make) in
                make.height.equalTo(height * scale)
                make.width.equalTo(width)
                let margin = 2
                make.right.equalTo(conV).offset(-margin)
                make.top.equalTo(conV).offset(margin)
            }
            
            self.rx.contentOffset.filter({ (offset) -> Bool in
                return !offset.equalTo(CGPoint.zero)
            }).bind { (offset) in
                lineView.removeFromSuperview()
                }.disposed(by: disposeBag)
        }
    }
}

extension UIImagePickerController {
    typealias Handle = () -> ()
    func cemeraHandle(_ handle: Handle!, limitHandle: Handle!) -> Void {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            LFAlertView.showAlert("错误", message: "您的设备不支持照相机")
            return
        }
        sourceType = .camera
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if (granted) {
                    //第一次用户接受
                    if let tmp = handle {
                        DispatchQueue.main.async(execute: {
                            tmp()
                        })
                    }
                }else{
                    //用户拒绝
                    if let tmp = limitHandle {
                        DispatchQueue.main.async(execute: {
                            tmp()
                        })
                    }
                }
            })
        case .restricted: // 无法访问
            dLog("没有设备")
        case .denied: // 用户拒绝
            if let tmp = limitHandle {
                DispatchQueue.main.async(execute: {
                    tmp()
                })
            }
        case .authorized: // 开启授权
            if let tmp = handle {
                DispatchQueue.main.async(execute: {
                    tmp()
                })
            }
        }
    }
    
    func libaryHandle(_ handle: Handle!, limitHandle: Handle!) -> Void {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            LFAlertView.showAlert("错误", message: "您的设备不支持图片库")
            return
        }
        sourceType = .photoLibrary
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            if let tmp = handle {
                DispatchQueue.main.async(execute: {
                    tmp()
                })
            }
        case .restricted: // 无法访问
            dLog("没有设备")
        case .denied: // 用户拒绝
            if let tmp = limitHandle {
                DispatchQueue.main.async(execute: {
                    tmp()
                })
            }
        case .authorized: // 开启授权
            if let tmp = handle {
                DispatchQueue.main.async(execute: {
                    tmp()
                })
            }
        }
    }
}

extension UIAlertController {
    class func showPhotoAuthInfo(_ type: String, vc: UIViewController) -> Void {
        let alert = UIAlertController(title: type + Text.NoAuth, message: Text.OpenInSetting + type + Text.Auth, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Text.NotNow, style: .cancel, handler: nil)
        let setting = UIAlertAction(title: Text.ToSetting, style: .default) { (action) in
            let url = Foundation.URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
        alert.addAction(cancel)
        alert.addAction(setting)
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showLocationAuthInfo() {
        let alert = UIAlertController(title: Text.NoLocationAuth, message: Text.LocationAuthMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Text.NotNow, style: .cancel, handler: nil)
        let setting = UIAlertAction(title: Text.ToSetting, style: .default) { (action) in
            if let url = Foundation.URL.init(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        alert.addAction(cancel)
        alert.addAction(setting)
        let vc = UIViewController.getCurrentController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    class func showClickNetworkError() {
        let alert = UIAlertController(title: nil, message: Text.NetErrorMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Text.Known, style: .cancel, handler: nil)
        alert.addAction(cancel)
        let vc = UIViewController.getCurrentController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    /**
     联系客服
     */
    class func contactCustomerService() -> Void {
        
        let url = Foundation.URL(string: "telprompt:" + (AppBaseConfig.customer_phone ?? BaseConfigManager.localConfigModel.customer_phone!) )
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        }
    }
    
    
    class func showAlert(_ title: String?, message: String?, cancelTitle: String = Text.OK) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let vc = UIViewController.getCurrentController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
}




