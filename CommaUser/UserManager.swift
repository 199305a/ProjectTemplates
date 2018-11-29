//
//  UserManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/19.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit


class UserManager: NSObject {
    
    static let shared = UserManager() // 单例
    fileprivate override init() {
        let id = user.hasGym ? user.gym_id! : DefaultGymID
        currentGymID = id
        super.init()
    }
    
    var user: UserModel = UserManager.userModel // 用户模型数据
    
    var currentGym = CoursesGymModel() // 当前首页场馆展示的场馆模型
    var currentGymID: String { // 初始化之后赋值, 用于请求首页的ID
        didSet {
            if oldValue == currentGymID { return }
            NotificationCenter.default.post(name: NotiKey.ChangedStore, object: nil)
        }
    }
    
    
    fileprivate static var userModel: UserModel { // 用来获取模型数据的数据
        let data = StandardDefaults.object(forKey: DefaultsKey.UserModel) as? Data
        guard let _ = data else {
            return UserModel()
        }
        let model = NSKeyedUnarchiver.unarchiveObject(with: data!) as? UserModel
        if let _ = model {
            return model!
        }
        return UserModel()
    }
    
    class func saveDefaultUser(_ user: UserModel) { // 把网络获取的数据存到本地
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        StandardDefaults.set(data, forKey: DefaultsKey.UserModel)
        UserManager.shared.user = user // 更换内存中的usermodel
    }
    
    class func setUserModel(_ loginModel: LoginModel) { // 对网络数据进行处理
        let user = UserModel()
        user.token = loginModel.token ?? ""
        user.refresh_token = loginModel.refresh_token ?? ""
        user.user_name = loginModel.user_name ?? ""
        user.is_new = loginModel.is_new as NSNumber
        user.user_gender = loginModel.user_gender as NSNumber
        user.phone = loginModel.phone ?? ""
        user.avatar = loginModel.avatar ?? ""
        user.gym_id = loginModel.gym_id
        saveDefaultUser(user)
    }
    
    class func resetUserModel() {
        // 删掉缓存
        StandardDefaults.removeObject(forKey: DefaultsKey.UserModel)
        // 覆盖新的
        saveDefaultUser(UserModel())
    }
    
    class func resettingCurrentGymID() {
        UserManager.shared.currentGymID = DefaultGymID
    }
    
    class func setUpCurrentGymID() {
        if AppUser.hasGym {
            UserManager.shared.currentGymID = AppUser.gym_id!
        }
        
    }
    
    
}
