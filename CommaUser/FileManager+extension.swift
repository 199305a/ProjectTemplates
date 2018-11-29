//
//  FileManager.swift
//  CommaUser
//
//  Created by yuanchao on 2017/10/12.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

extension FileManager {
    
    // 获取磁盘剩余空间大小(单位：bytes)
    class func freeSizeOfDisk() -> Int64 {

        do{
            let dic = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let number = dic[.systemFreeSize] as? Int64 {
                return number
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return 0
    }
    
    // 获取文件或文件夹大小
    class func size(filePath: String) -> Int64 {
        
        let isDirectory: UnsafeMutablePointer<ObjCBool>? = nil
        guard FileManager.default.fileExists(atPath: filePath, isDirectory: isDirectory) else {
            return 0
        }
    
        if isDirectory?.pointee.boolValue == false {
            return sizeOfFile(filePath)
        }
        
        var size: Int64 = 0
        do {
            let files = try FileManager.default.subpathsOfDirectory(atPath: filePath)
            files.forEach { (file) in
                size += sizeOfFile(filePath + "/" + file)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return size
    }
    
    // 获取单个文件大小
    class func sizeOfFile(_ path: String) -> Int64 {
        
        var fileSize: Int64 = 0
        do {
            if let size = try FileManager.default.attributesOfItem(atPath: path)[.size] as? Int64 {
                 fileSize = size
            }
        } catch {
            debugPrint("计算文件大小失败：\(error.localizedDescription)")
        }
        return fileSize
    }
    
    
    /// 获取文件MD5值
    ///
    /// - Parameter filePath: 文件路径
    class func md5(filePath: String) -> String? {
        let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        return data?.md5().toHexString()
    }
}
