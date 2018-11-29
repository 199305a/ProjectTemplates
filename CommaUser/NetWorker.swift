//
//  NetWorker.swift
//  CommaUser
//
//  Created by Marco Sun on 16/4/18.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftRandom
import CryptoSwift
import UIDeviceIdentifier

typealias ErrorClosure = (_ statusCode: Int, _ message: String) -> Void
typealias SuccessedClosure = (_ dataObj: [String: AnyObject]) -> Void
typealias FailedClosure = (_ error: Error) -> Void


struct NetWorker {

    static let _innerKey = "_inner_key"
    
    static var isSyncTimestamp = false
    static var group = DispatchGroup()
    
    static let sharedInstance: SessionManager = { // 默认Manager
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 自定义请求超时时间
        return SessionManager(configuration: configuration)
    }()
    
    
    static let configManager: SessionManager = { // 时间戳和基础配置专用
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6 // 自定义请求超时时间
        return SessionManager(configuration: configuration)
    }()
    
    
    // MARK: - requests
    
    
    static func obtainHttpHeader(type: Alamofire.HTTPMethod, urlStr: String, params: [String: Any]) -> HTTPHeaders {
        
        var header = HTTPHeaders()
        // 以上所有字段都是必传字段, 签名另外处理
        let requestID = String(Randoms.randomInt(100000000, 999999999))
        
        header["app-id"] = AppKey.ServerAppID
        header["app-version"] = AppVersion
        header["request-id"] = requestID
        header["platform"] = AppKey.AppPlatform
        header["device-name"] =  UIDeviceHardware.platformString()
        header["os-version"] = GlobalAction.deviceVersion
        header["token"] = AppUser.token ?? "" // 可以是空字符串，但是不可以不传
        header["app-code"] =  AppBuildVersion
        header["user-agent"] = "comma/ios"
        
        // 为时间戳专门设置
        let requestTime = GlobalAction.serverTimestamp
        if urlStr == ServerURL.TimeStamp {
            AppTimestamp.localRequsestTime = requestTime - AppTimestamp.timeDelta
            header["request-time"] = "0"
        } else {
            header["request-time"] = String(requestTime)
        }
        
        var fullUrl = urlStr.hasPrefix("/") ? urlStr : ("/" + urlStr)
        let paramJsonString: String
        if type == .get {
            paramJsonString = ""
            let queryStr = NetWorker.query(params as [String : AnyObject])
            if !queryStr.isEmpty {
                fullUrl += ("?" + queryStr)
            }
        } else {
            paramJsonString = (params.jsonString ?? "")
            header["content-type"] = "application/json"
        }
        
        header["signature"] = [fullUrl, paramJsonString, AppKey.AppKey, header["request-time"]!, requestID].sorted().joined().sha1()
        return header
    }
    
    static func obtainManager(urlStr: String) -> SessionManager {
        if urlStr.contains(ServerURL.TimeStamp) || urlStr.contains(ServerURL.BaseConfig) {
            return configManager
        }
        return sharedInstance
    }
    
    static func obtainParameterEncoding(type: Alamofire.HTTPMethod) -> ParameterEncoding {
        return type == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    /**
     请求方法完全体
     
     - parameter type:      请求类型
     - parameter urlStr:    URL
     - parameter parameter: 参数
     - parameter needToken: 是否需要登录
     - parameter success:   成功回调
     - parameter failed:    失败回调
     - parameter error:     错误回调
     
     - returns: 本次请求
     */
    
    @discardableResult
    static func privateRequest(_ type: Alamofire.HTTPMethod, urlStr: String, params:Dic, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request {
        
        let URL = (urlStr.hasPrefix("http://") || urlStr.hasPrefix("https://")) ? urlStr : (ServerURL.ServerHost + urlStr)
        let api = log(type: type, urlStr: urlStr, URL: URL, params: params)
        let params = params ?? [:]
        let manager = obtainManager(urlStr: urlStr)
        let encoding = obtainParameterEncoding(type: type)
        let header = obtainHttpHeader(type: type, urlStr: urlStr, params: params)
        
        return manager.request(URL, method: type, parameters: params, encoding: encoding, headers: header).responseJSON(completionHandler: { responseJSON  in
            /*** 进入服务器响应阶段 ***/
            
            // 请求失败处理
            responseJSON.result.withError { (error) in
                // 返回请求失败
                failed?(error)
                // 打印错误
                handleRequestFailed(api: api, error: error)
            }
            // 服务器有响应的处理
            .withValue { (value) in
                // 有返回值但是没有响应（虽然这一步这里做了判断，但是实际上不会出现没有response的情况）
                guard let response = responseJSON.response else {
                    // 返回请求失败（自定义错误）
                    let error = NSError.init(domain: CustomNetError.Domain, code: CustomNetError.NoResponseButHaveDataCode, userInfo: [NSLocalizedDescriptionKey: CustomNetError.NoResponseButHaveData])
                    failed?(error)
                    // 打印错误
                    handleRequestFailed(api: api, error: error)
                    return
                }
                
                let httpStatusCode = response.statusCode
                // 此时请求成功，但服务器返回格式有可能异常
                if httpStatusCode == 200 {
                    // 判断服务器是否格式正确，是否返回了必含字段
                    guard let validateValue = validateResponse(value: value) else {
                        error?(CustomNetError.SomethingHappendCode, CustomNetError.SomethingHappend)
                        dLog("\(api)请求异常(服务器格式异常):\nURL:\(response.url!.absoluteString)\n请求方法:\(type.rawValue), 状态码:\(httpStatusCode)\n结果:\n\(value)")
                        return
                    }
                    
                    let data = validateValue.data
                    let message = validateValue.message
                    let code = validateValue.code
                    let resp = validateValue.respData
                    
                    // 此时服务器返回的字段正确，但是如果code不等于0，说明业务异常
                    guard code == 0 else  {
                        // 此时返回业务异常
                        error?(code, message)
                        dLog("\(api)请求异常:\nURL:\(response.url!.absoluteString)\n请求方法:\(type.rawValue), 状态码:\(httpStatusCode)\n结果:\n\(resp.debugString)")
                        // 如果业务异常为强制登录，让用户去登录
                        if code == CustomNetError.ForceLoginErrorCode {
                            Jumper.jumpToLogin()
                        }
                        
                        return
                    }
                    
                    // 此处终于进入业务返回正常，将返回值返回
                    dLog("\(api) 请求成功!\n结果:\n\(resp.debugString)")
                    success?(data)
                    return
                }
                
                // 进入状态码非200的操作
                // 服务器格式异常
                guard let validateValue = validateErrorResponse(value) else {
                    error?(CustomNetError.SomethingHappendCode, CustomNetError.SomethingHappend)
                    dLog("\(api)请求异常(服务器格式异常):\nURL:\(response.url!.absoluteString)\n请求方法:\(type.rawValue), 状态码:\(httpStatusCode)\n结果:\n\(value)")
                    return
                }
                
                let message = validateValue.message
                let code = validateValue.code
                let resp = validateValue.respData
                dLog("\(api)请求异常:\nURL:\(response.url!.absoluteString)\n请求方法:\(type.rawValue), 状态码:\(httpStatusCode)\n结果:\n\(resp.debugString)")
                
                switch httpStatusCode {
                case 401: // token鉴权失败
                    guard String.isNotEmptyString(AppUser.refresh_token) else {
                        error?(code, message)
                        // 跳登录页
                        tokenExpiredHandle()
                        return
                    }
                    NetWorker.put(ServerURL.RefreshToken, params: ["refresh_token": AppUser.refresh_token!], success: { (dataObj) in
                        let model = LoginModel.parse(dict: dataObj)
                        guard String.isNotEmptyString(model.token) &&
                            String.isNotEmptyString(model.refresh_token) else {
                                // 跳登录页
                                error?(code, message)
                                tokenExpiredHandle()
                                return
                        }
                        AppUser.token = model.token
                        AppUser.refresh_token = model.refresh_token
                        privateRequest(type, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
                    }, error: { (statusCode, message) in
                        error?(statusCode , message)
                    }, failed: { error in
                        failed?(error)
                    })
                case 403: // 非业务异常
                    if code == CustomNetError.TimeoutErrorCode {
                        NetWorker.syncTimestamp {
                            privateRequest(type, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
                        }
                        return
                    }else if  code == CustomNetError.UnauthorizedtokenCode {
                        error?(code, message)
                        tokenExpiredHandle()
                        return
                    }
                    error?(code, message)
                case 404: // uri not exist
                    error?(code, message)
                case 500: // 服务器错误
                    error?(code, message)
                default: // 其他状态码
                    error?(code, message)
                }
            }
        })
    }
    
    static func tokenExpiredHandle() {
        AppUser.token = nil
        AppUser.refresh_token = nil
        HitMessage.dismiss()
        Jumper.jumpToLogin(true)
    }
    
    // 验证服务器字段
    static func validateResponse(value: Any) -> (code: Int, message: String, data: [String: AnyObject], respData: [String: AnyObject])? {
        guard // 判断服务器是否格式正确，返回了必含字段
            let resp = value as? [String: AnyObject],
            let statusCode = resp["code"] as? Int,
            let message = resp["msg"] as? String,
            let respData = resp["data"]
            else {
                return nil
        }
        
        let data: [String: AnyObject]
        if let respData = respData as? [String: AnyObject] {
            data = respData
        } else if let respData = respData as? [AnyObject] {
            data = [NetWorker._innerKey: respData as AnyObject]
        } else {
            return nil
        }
        
        return (statusCode, message, data, resp)
    }
    
    // 验证状态码非200时服务器字段
    static func validateErrorResponse(_ value: Any) -> (code: Int, message: String, respData: [String: AnyObject])? {
        guard // 判断服务器是否格式正确，返回了必含字段
            let resp = value as? [String: AnyObject],
            let statusCode = resp["code"] as? Int,
            let message = resp["msg"] as? String
            else {
                return nil
        }
        return (statusCode, message, resp)
    }
    
    /**
     添加请求任务同步
     */
    @discardableResult
    static func requestSync(_ type: Alamofire.HTTPMethod, urlStr: String, params:Dic, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request? {
        
        if isSyncTimestamp && urlStr != ServerURL.TimeStamp {
            (group).notify(queue: DispatchQueue.main, execute: {
                privateRequest(type, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
            })
            return nil
        }
        return privateRequest(type, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
    }
    
    
    /**
     新版默认方法
     */
    @discardableResult
    static func request(_ httpMethod: Alamofire.HTTPMethod, urlStr: String, params:Dic, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request? {
        return requestSync(httpMethod, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
    }
    
    /**
     GET 请求
     */
    @discardableResult
    static func get(_ urlStr: String, params:Dic = nil, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request? {
        return request(.get, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
    }
    
    /**
     POST 请求
     */
    @discardableResult
    static func post(_ urlStr: String, params: Dic = nil, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request? {
        return request(.post, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
    }
    
    /**
     PUT 请求
     */
    @discardableResult
    static func put(_ urlStr: String, params: Dic = nil, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request? {
        return request(.put, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
    }
    
    /**
     DELETE 请求
     */
    @discardableResult
    static func delete(_ urlStr: String, params:Dic = nil, success: SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?) -> Request? {
        return request(.delete, urlStr: urlStr, params: params, success: success, error: error, failed: failed)
    }
    
    
    // 当请求失败（服务器没有响应）的时候调用的方法
    static func handleRequestFailed(api: String, error: Error) {
        #if DEBUG
        let error = error as NSError
        let errorCode = error.code
        let message: String
        switch errorCode {
        case NSURLErrorTimedOut:
            message = "请求超时"
        default:
            message = error.localizedDescription
        }
        
        dLog("\(api) 请求失败!\n失败原因:\n\(message)")
        if errorCode != NSURLErrorTimedOut {
            dLog(error)
        }
        #endif
    }
    
}


// MARK: - 下载文件
extension NetWorker {
    static func download(urlStr: String, destPath: String, success: EmptyClosure?, failed: ((Error?) -> Void)?) {
        guard let url = URL(string: urlStr) else {
            failed?(nil)
            return
        }
        let manager = obtainManager(urlStr: urlStr)
        let request = URLRequest(url: url)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (URL(fileURLWithPath: destPath), .removePreviousFile)
        }
        manager.download(request, to: destination).response { (resp) in
            if let err = resp.error {
                failed?(err)
                return
            }
            success?()
        }
    }
}


// Log
extension NetWorker {
    
    // 打印日志
    fileprivate static func apiName(_ type: Alamofire.HTTPMethod, urlStr: String) -> String {
        var apis: [String: String]
        
        switch type {
        case .get:
            apis = ServerURL.GETAPI
        case .post:
            apis = ServerURL.POSTAPI
        case .put:
            apis = ServerURL.PUTAPI
        case .delete:
            apis = ServerURL.DELETEAPI
        default:
            apis = [:]
        }
        
        for (key, value) in apis {
            if urlStr.contains(key) {
                return value
            }
        }
        return "[未明确]"
    }
    
    
    static func log(type: Alamofire.HTTPMethod, urlStr: String, URL: String, params:Dic) -> String {
        #if DEBUG
        let api = apiName(type, urlStr: urlStr)
        #else
        let api = ""
        #endif
        dLog("请求 \(api)\nURL: \(URL)\n参数 \(params ?? [:])")
        return api
    }
    
}

// 同步时间戳
extension NetWorker {
    
    static func syncTimestamp(_ complete: EmptyClosure?) {
        addGroupTask()
        NetWorker.get(ServerURL.TimeStamp, success: { (dataObj) in
            guard let timestamp = (dataObj["timestamp"] as? String)?.intValue else {
                leaveGroup()
                complete?()
                return
            }
            AppTimestamp.serverTime = timestamp
            AppTimestamp.localResponseTime = Int(NSDate().timeIntervalSince1970)
            leaveGroup()
            complete?()
        }, error: { (statusCode, message) in
            leaveGroup()
            complete?()
        }) { (error) in
            leaveGroup()
            complete?()
        }
    }
    
    static func leaveGroup() {
        NetWorker.group.leave()
        NetWorker.isSyncTimestamp = false
    }
    
    static func addGroupTask() {
        NetWorker.group.enter()
        NetWorker.isSyncTimestamp = true
    }
    
}

// 从alamofire里拷贝出来的三个方法
extension NetWorker {
    
    fileprivate static func query(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    
    fileprivate static func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    fileprivate static func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = String(string[range])
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}


