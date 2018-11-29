//
//  DataStoreManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/19.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreData

class DataStoreManager: NSObject {
    
    // 储存数据到 Defaults
    class func storeDataToDisk() {
        // 用户数据
        let user = NSKeyedArchiver.archivedData(withRootObject: AppUser)
        StandardDefaults.set(user, forKey: DefaultsKey.UserModel)
    }
    
    static let shared = DataStoreManager()
    private override init() {}
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let bundles = [Bundle.init(for: BraceletData.self)]
        guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
            fatalError("model not found")
        }
        let psc = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: StoreURL, options: nil)
        let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }()
    
    private let StoreURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CommaUser.txt")
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var todayDateStr: String {
        return dateFormatter.string(from: Date())
    }
    func dateStr(from utc: Int64) -> String {
        return dateFormatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(utc)))
    }
    
    func getTodayLastBraceletData(mac: String) -> BraceletData? {
        let macAddress = mac.replacingOccurrencesOfString(":", withString: "").lowercased()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BraceletData")
        request.predicate = NSPredicate.init(format: "macAddress = %@ && measureTime BEGINSWITH %@", macAddress, todayDateStr)
        do {
            return try (managedObjectContext.fetch(request) as? [BraceletData])?.last
        } catch {
            dLog(error.localizedDescription)
        }
        return nil
    }
    
    func getBraceletData(mac: String) -> [BraceletData]? {
        let macAddress = mac.replacingOccurrencesOfString(":", withString: "").lowercased()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BraceletData")
        request.predicate = NSPredicate.init(format: "macAddress = %@", macAddress)
        do {
            return try managedObjectContext.fetch(request) as? [BraceletData]
        } catch {
            dLog(error.localizedDescription)
        }
        return nil
    }
    
    func saveBraceletData(_ data: LSPedometerData) {
        guard let mac = BraceletManager.shared.bracelet?.bracelet_mac?.replacingOccurrencesOfString(":", withString: "").lowercased() else {
            return
        }
        let dateStr = self.dateStr(from: data.utc)
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BraceletData")
        request.predicate = NSPredicate.init(format: "macAddress = %@ && measureTime BEGINSWITH %@", mac, dateStr)
        do {
            guard let model = try (managedObjectContext.fetch(request) as? [BraceletData])?.last else {
                insertBraceletData(data)
                return
            }
            model.measureTime = dateStr
            model.stepNum = NSNumber.init(value: data.walkSteps)
            model.distance = NSNumber.init(value: data.distance)
            model.kcal = NSNumber.init(value: data.calories)
            do {
                try managedObjectContext.save()
            } catch  {
                dLog("更新手环数据失败：\(error.localizedDescription)")
            }
        } catch {
            dLog(error.localizedDescription)
        }
    }
    
    func insertBraceletData(_ data: LSPedometerData) {
        guard let mac = BraceletManager.shared.bracelet?.bracelet_mac?.replacingOccurrencesOfString(":", withString: "").lowercased() else {
            dLog("找不到macAddress")
                return
        }
        let model = NSEntityDescription.insertNewObject(forEntityName: "BraceletData", into: managedObjectContext) as! BraceletData
        model.macAddress = mac
        model.stepNum = NSNumber.init(value: data.walkSteps)
        model.distance = NSNumber.init(value: data.distance)
        model.kcal = NSNumber.init(value: data.calories)
        model.measureTime = dateStr(from: data.utc)
        do {
            try managedObjectContext.save()
        } catch  {
            dLog("保存手环数据失败：\(error.localizedDescription)")
        }
    }
    
    func deleteBraceletData(mac: String, timeStr: String) {
        let macAddress = mac.replacingOccurrencesOfString(":", withString: "").lowercased()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BraceletData")
        request.predicate = NSPredicate.init(format: "macAddress = %@ && measureTime = %@", macAddress, timeStr)
        do {
            guard let model = try (managedObjectContext.fetch(request) as? [BraceletData])?.last else {
                return
            }
            managedObjectContext.delete(model)
            do {
                try managedObjectContext.save()
            } catch  {
                debugPrint("删除手环数据失败：\(error.localizedDescription)")
            }
        } catch {
            dLog(error.localizedDescription)
        }
    }
    
}
