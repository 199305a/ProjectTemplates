//
//  AliyunOSSManager.swift
//  CommaUser
//
//  Created by yuanchao on 2018/5/7.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class AliyunOSSManager: NSObject {
    
    static let shared = AliyunOSSManager()
    var config: AliyunOSSModel?
    var client: OSSClient?
    
    func uploadImage(_ image: UIImage, success: ((String)->Void)?, failure: ErrorClosure?) {
        requestConfigure {
            DispatchQueue.global().async {
                let newImage = image.compressImage(500)
                guard let data = UIImagePNGRepresentation(newImage) else {
                    DispatchQueue.main.async(execute: {
                        HitMessage.showErrorWithMessage(Text.UploadError)
                    })
                    return
                }
                DispatchQueue.main.async {
                    self.uploadData(data, success: success, failure: failure)
                }
                
            }
        }
    }
    
    private func requestConfigure(success: EmptyClosure?) {
        NetWorker.get(ServerURL.GetAliyunOSSConfigure, success: { (dataObj) in
            self.config = AliyunOSSModel.parse(dict: dataObj)
            dLog("获取AliyunOSS配置成功")
            self.initOSSClient()
            success?()
        }, error: { (code, msg) in
            dLog("获取AliyunOSS配置失败：\(msg)")
        }) { (error) in
            dLog("获取AliyunOSS配置失败")
        }
    }
    
    private func initOSSClient() {
        guard let accessKey = config?.access_id, let secretKey = config?.access_secret,
              let securityToken = config?.security_token,
              let endPoint = config?.end_point
              else {
            #if DEBUG
                fatalError("AliyunOSS的配置信息不全")
            #else
                HitMessage.showErrorWithMessage(Text.UploadError)
                return
            #endif
        }
        
        let credential = OSSStsTokenCredentialProvider.init(accessKeyId: accessKey, secretKeyId: secretKey, securityToken: securityToken)
        client = OSSClient.init(endpoint: endPoint, credentialProvider: credential)
        
    }
    
    private func uploadData(_ data: Data, success: ((String)->Void)?, failure: ErrorClosure?) {
        guard let bucketName = config?.bucket,
              let filePath = config?.file_path,
              let fileName = config?.file_name else {
                #if DEBUG
                fatalError("AliyunOSS的配置信息不全")
                #else
                HitMessage.showErrorWithMessage(Text.UploadError)
                return
                #endif
        }
        let file = filePath + fileName + ".png"
        let put = OSSPutObjectRequest()
        put.bucketName = bucketName
        put.objectKey = file
        put.uploadingData = data
        put.uploadProgress = { (bytesSent, totalByteSent, totalBytesExpectedToSend) in
            
        }
        let putTask = client?.putObject(put)
        putTask?.continue({ (task) in
            DispatchQueue.main.async {
                if let error = task.error as NSError? {
                    dLog("上传图片失败：\(error.localizedDescription)")
                    failure?(error.code, error.localizedFailureReason ?? "")
                    return
                }
                dLog("上传图片成功")
                success?(file)
                
            }
            return nil
        })
    }
}
