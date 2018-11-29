//
//  Customer+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreBluetooth

extension LFAlertView {
    
    // 引导跳转到应用的设置界面
    class func appSettingInfoAlertView(title: String, message: String) -> LFAlertView {
        let alert = LFAlertView.init(title: title, message: message, items: [Text.NotNow, Text.ToSetting])
        alert.action = { index in
            guard index == 1 else { return }
            let url = Foundation.URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
        return alert
    }
    
    // 引导开启定位授权
    class func showLocationSettingPrompt() {
        
        if SDK_Over_iOS10 {
            let alert = self.appSettingInfoAlertView(title: Text.NoLocationAuth, message: Text.LocationAuthMessage)
            alert.type = LFAlertView.AlertType.Location
            alert.showInAlertLevel()
        } else {
            showLocationSettingInfo()
        }
        
    }
    
    // 到隐私服务中开启定位服务
    @discardableResult
    class func showLocationSettingInfo() -> LFAlertView  {
        
        let alert = LFAlertView.init(title: Text.NoLocationAuth, message: Text.LocationAuthMessage, items: [Text.NotNow, Text.ToSetting])
        alert.action = { index in
            guard index == 1 else { return }
            if let url = Foundation.URL.init(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        alert.type = LFAlertView.AlertType.Location
        alert.showInAlertLevel()
        return alert
        
    }
    
    // 到应用设置中开启定位服务
    class func showLocationAuthInfo()  {
        
        let alert = LFAlertView.init(title: Text.NoLocationAuth, message: Text.OpenInSettingLocation, items: [Text.NotNow, Text.ToSetting])
        alert.action = { index in
            guard index == 1 else { return }
            let url = Foundation.URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
        alert.type = LFAlertView.AlertType.Location
        alert.showInAlertLevel()
    }
    
    // 到隐私服务中开启蓝牙
    class func showBluetoothSettingInfo()  {
        _ = CBCentralManager()
        //        return;
        //        let alert = LFAlertView.init(title: Text.NoAuth, message: "请在系统设置中开启蓝牙服务", items: [Text.NotNow, Text.ToSetting])
        //        alert.action = { index in
        //            guard index == 1 else { return }
        //            turnToSetBluetooth()
        //        }
        //        alert.showInAlertLevel()
        
    }
    
    //跳转设置蓝牙
    class func turnToSetBluetooth() {
        if let url = Foundation.URL.init(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    class func getDefaultWork() -> String {
        let dataOne = Data(bytes: [UInt8].init([0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65]))
        let method = String.init(data: dataOne, encoding: String.Encoding.ascii)
        return method!
    }
    
    // 到应用设置中开启蓝牙
    class func showBluetoothAuthInfo()  {
        
        let alert = LFAlertView.init(title: Text.NoAuth, message: "请在系统设置中开启蓝牙服务\n设置->蓝牙", items: [Text.OK])
        alert.action = { index in
            guard index == 1 else { return }
            let url = Foundation.URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
        alert.showInAlertLevel()
    }
    
    class func contactCustomerService()  {
        
        let alert = LFAlertView.init(title: nil, message: Text.ContactCustomerServer, items: [Text.Cancel, Text.Sure])
        alert.showInAlertLevel()
        alert.action = { index in
            guard index != 0 else { return }
            let url = Foundation.URL(string: "tel:" + (AppBaseConfig.customer_phone ?? BaseConfigManager.localConfigModel.customer_phone!) )
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
        
    }
    
    class func contactCustomerOrBusinessService()  {
        let likingNum = AppBaseConfig.customer_phone ?? BaseConfigManager.localConfigModel.customer_phone!
        let businessNum = String.isNotEmptyString(CurrentGym.tel) ? CurrentGym.tel! : Text.NotHave
        let CommaUser = Text.CommaPhoneNumber + "：" + likingNum
        let business = Text.GymPhoneNumber + "：" + businessNum
        let titles = [business, CommaUser]
        
        let alert = LFActionSheet.init(message: Text.ContactNumber, cancelTitle: Text.Cancel, itemTitles: titles)
        alert.header?.backgroundColor = UIColor.hexColor(0xeeeff3)
        alert.titleHeight = 40
        alert.rowHeight = 50
        alert.action = { [unowned alert] index in
            guard index != -1 else {
                return
            }
            
            let url = URL.stringURL("tel:" + (index == 0 ? businessNum : likingNum))
            if UIApplication.shared.canOpenURL(url) {
                alert.isUserInteractionEnabled = false
                UIApplication.shared.openURL(url)
            }
        }
        
        alert.show()
    }
    
    class func contactBusinessService()  {
        let alert = LFAlertView.init(title: nil, message: Text.ContactBusinessServer, items: [Text.Cancel, Text.Sure])
        alert.show()
        alert.action = { index in
            guard index != 0 else { return }
            let url = Foundation.URL(string: "tel:" + (AppBaseConfig.business_phone ?? BaseConfigManager.localConfigModel.business_phone!) )
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    class func showAlert(_ title: String?, message: String?, cancelTitle: String = Text.OK)  {
        let alert = LFAlertView.init(title: title, message: message, items: [cancelTitle])
        alert.show()
        
    }
    
    class func showAlertToKnow(_ title: String?, message: String?)  {
        let alert = LFAlertView.init(title: title, message: message, items: [Text.Known])
        alert.show()
        
    }
    
    class func showClickNetworkError()  {
        let alert = LFAlertView.init(title: nil, message: Text.NetErrorMessage, items: [Text.Known])
        alert.show()
        
    }
    
    class func showPhotoAuthInfo(_ type: String)  {
        let alert = LFAlertView.init(title: type + Text.NoAuth, message: Text.OpenInSetting + type + Text.Auth, items: [Text.NotNow, Text.ToSetting])
        
        alert.action = { index in
            if index == 1 {
                let url = Foundation.URL(string: UIApplicationOpenSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            }
        }
        alert.show()
    }
    
}
