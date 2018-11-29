//
//  BaseConfigManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/9.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import Alamofire

class BaseConfigManager: NSObject {
    
    var baseConfigModel: BaseConfigModel = BaseConfigManager.configModel // 基础配置数据
    let timestampModel = TimestampModel() // 时间戳数据
    static let shared = BaseConfigManager() // 单例
    fileprivate override init() {}
    fileprivate static var configModel: BaseConfigModel {
        let data = StandardDefaults.object(forKey: DefaultsKey.BaseConfigModel) as? Data
        if let _ = data {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data!) as? BaseConfigModel
            if let _ = model, GlobalAction.isUpdatedAndFirstLaunch == false {
                return model!
            }
            StandardDefaults.removeObject(forKey: DefaultsKey.BaseConfigModel)
        }
        return localConfigModel
        
    }
    
    static var localConfigModel: BaseConfigModel { // 注意，这个是打包到本地的，不可以更改
        let config = DebugMode ? "TestBaseConfig" : "BaseConfig"
        let path = Bundle.main.path(forResource: config, ofType: "plist")
        let dict = NSDictionary.init(contentsOfFile: path!)
        let model =  BaseConfigModel.parse(dictionary: dict!)
        return model
    }
    
    class func obtainBaseConfig(_ complete: EmptyClosure?) { // 获取基础配置
        
        NetWorker.get(ServerURL.BaseConfig, success: { (dataObj) in
            
            let model = BaseConfigModel.parse(dict: dataObj)
            BaseConfigManager.shared.baseConfigModel = model // 内存中的要更换成最新的
            saveBaseConfig(model) // baseconfig操作
            NotificationCenter.default.post(name: NotiKey.BaseConfigSuccess, object: nil)
            complete?()
        }, error: { (statusCode, message) in
            complete?()
        }) { (error) in
            complete?()
        }
    }
    
    class func saveBaseConfig(_ model: BaseConfigModel) {
        let data = NSKeyedArchiver.archivedData(withRootObject: model)
        StandardDefaults.set(data, forKey: DefaultsKey.BaseConfigModel)
    }
    
    // 一般用不到的方法，只有在发版前更新基础配置的时候使用
    class func generateBaseConfigPlist(_ dataObj: [String: AnyObject]) {
        let dict = NSDictionary.init(dictionary: dataObj)
        let path = DebugMode ? "TestBaseConfig.plist" : "BaseConfig.plist"
        let tmpPath = NSTemporaryDirectory() + path
        dLog("tmpPath")
        dLog(tmpPath)
        dict.write(toFile: tmpPath, atomically: true)
        
    }
    
    
    class func checkUpdate() {
        NetWorker.get(ServerURL.CheckUpdate, success: { (dataObj) in
            let model = UpdateModel.parse(dict: dataObj["info"] as! [String : Any])
            self.checkUpdate(model: model)
        }, error: nil, failed: nil)
    }
    
    class func checkUpdate(model: UpdateModel) {
        guard let lastVersion = model.version else { return }
        let result = GlobalAction.compare(AppVersion, to: lastVersion)
        guard result == .less else { return }
        switch model.mode {
        case .notNeed:
            break
        case .force:
            forceUpdate(model)
        case .normal:
            // 进入非强制升级
            let version = StandardDefaults.object(forKey: DefaultsKey.UpdateVersion) as? String
            if version == lastVersion { return } // 当前版本已经提示过一次升级
            // 进入当前版本没进入过升级
            toUpdateButNotForce(model)
            StandardDefaults.set(lastVersion, forKey: DefaultsKey.UpdateVersion)
        }
    }
    
    class func forceUpdate(_ updateModel: UpdateModel) { // 强制升级只有一个按钮
        let alert = LFAlertView.init(title: updateModel.title, message: updateModel.content, items: [Text.GoToAppStore])
        alert.showInAlertLevel()
        alert.action = { index in
            GlobalAction.toAppStore()
            forceUpdate(updateModel)
        }
    }
    
    class func toUpdateButNotForce(_ updateModel: UpdateModel) { // 非强制升级，可取消
        let alert = LFAlertView.init(title: updateModel.title, message: updateModel.content, items: [Text.Known, Text.GoToAppStore])
        alert.showInAlertLevel()
        alert.action = { index in
            guard index != 0 else {return}
            GlobalAction.toAppStore()
        }
        
    }
    
    
}

class BaseConfigModel: BaseModel {
    var api_version: String?
    var customer_phone: String?
    var business_phone: String?
    var agree_url: String?
    var card_url: String?
    var course_team_url: String?
    var course_personal_url: String?
    var small_course_team_url: String?
    var wechat: String?
    
//    var team_class_url: String?
    var resveration_url: String?

}


class UpdateModel: BaseModel {
    var update_mode: Int = InvalidInteger // 1. 普通更新 2. 强制更新
    var title: String?
    var content: String?
    var version: String?
    var app_code: String?
    var url: String?
    var mode: UpdateMode {
        return UpdateMode.init(rawValue: update_mode) ?? .notNeed
    }
}


enum UpdateMode: Int {
    case notNeed
    case normal = 1
    case force
}

class TimestampModel: BaseModel {
    var localRequsestTime: Int = 0 // 请求时间戳时的本地时间
    var localResponseTime: Int = 0 // 请求返回时间戳时的本地时间
    var serverTime: Int = 0 // 请求时间戳返回的服务器时间
    var timeDelta: Int { // 时间差值
        return Int((localResponseTime - localRequsestTime) / 2 + serverTime - localResponseTime) // 服务器时间戳 - 响应时本地时间
    }
    
}


