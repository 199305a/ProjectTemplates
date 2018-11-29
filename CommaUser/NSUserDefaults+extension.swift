//
//  NSUserDefaults+extension.swift
//  NewChama
//
//  Created by Levi on 16/5/26.
//  Copyright © 2016年 com.NewChama. All rights reserved.
//

import Foundation

extension UserDefaults {
    // 不需要被清除的key
    var filterKeys: [String] {
        return [DefaultsKey.UUID, DefaultsKey.UpdateVersion, DefaultsKey.CurrentVersion, DefaultsKey.DeviceToken]
    }
    
    func removeAll() {
        StandardDefaults.dictionaryRepresentation().keys.forEach { (key) in
            // 过滤掉不会被清除的key
            if !filterKeys.contains(key) {
                StandardDefaults.removeObject(forKey: key)
            }
        }
    }
}
