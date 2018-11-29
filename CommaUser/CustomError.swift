//
//  CustomError.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/14.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

// 自定义错误
struct CustomNetError {
    static let Domain = "CustomErrorDomain"
    static let NoResponseButHaveData = "有返回值但是没有服务器没有响应（你确定会有这种鬼？）"
    static let NoResponseButHaveDataCode = -100
    static let SomethingHappend = "发生了一些意外" // 服务器格式不正确的时候报这个
    static let SomethingHappendCode = -200
    
    static let TimeoutErrorCode = 10006
    static let UnauthorizedtokenCode = 10007 //无效的token

    static let ForceLoginErrorCode = 20004
    static let NoCardErrorCode = 60001
}
