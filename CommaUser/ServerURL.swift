//
//  ServerURL.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import Foundation

struct ServerURL {
    
    //ServerHost
    // 服务器主机地址
    static var ServerHost: String {
        let host: String
        switch AppEnv {
        case .alpha:
            host = "https://alphaapp.commafit.club/"
        case .beta:
            host = "https://betaapp.commafit.club/"
        case .dev:
            host = "https://devapp.commafit.club/"
        case .production:
            host = "https://app.commafit.com/"
        }
        return host
    }
    // 图片服务器主机地址
    static var ImageServerHost: String {
        return DebugMode ? "https://devimg.commafit.club/" : "https://static.commafit.com/"
    }
    
    // MARK: - 后台接口
    
    /** 版本号 */
    static var Version: String { return AppBaseConfig.api_version ?? BaseConfigManager.localConfigModel.api_version! } 
    /** 时间戳 */
    static let TimeStamp = "time"
    /** 验证码 */
    static let Captcha = "sms"
    /** 基础配置接口 */
    static let BaseConfig = "app/config"
    /** 检查更新 */
    static let CheckUpdate = "app/upgrade"
    /** 登录 */
    static let Login = "login"
    /** 登出 */
    static let Logout = "login"
    /** 更新token */
    static let RefreshToken = "login"
    /** 首页接口 */
    static let Index = Version + "/index"
    /** 更新用户信息 */
    static let UpdateUser = Version + "/user"
    /** 私教列表 */
    static let TrainerGym = Version + "/trainer/gym"
    
    
//    /** 团体课列表 */
//    static let CourseGym = Version + "/course/gym"
//    /** 团体课详情 */
//    static let CourseInfo = Version + "/course"
    
    /** 小团课/团操课列表 */
    static let CourseGym = Version + "/course/courses-list" //
    /** 小团课/团操课详情 */
    static let CourseInfo = Version + "/course/course-detail"//
    
    
    /** 按城市查看场馆 */
    static let GetGyms = Version + "/gym"
    /** 私教课详情 */
    static let TrainerInfo = Version + "/trainer"
    /** 收费团体课详情付款 */
    static let CourseChargeInfo = Version + "/order/charge-course"
    /** 预约免费团体课 */
//    static let OrderFreeCourse = Version + "/order/free-course"
    static let OrderFreeCourse = Version + "/team-course/res-teamcourse"

  
    /** 小团课购买获取次数及价格 */
    static let GetlittleCoursePriceList = Version + "/team-course/get-buyprice"  //
    
    /** 优惠券列表 */
    static let FetchCoupon = Version + "/coupon"
    /** 场馆详情 */
    static let GymInfo = Version + "/gym"
    /** 兑换优惠券 */
    static let CouponExchangeCoupon = Version + "/coupon/exchange"
    /** 获取公告列表 */
    static let GetMyAnnouncements = Version + "/ann"
    /** 我的团体课列表 */
    static let TeamCourseList = Version + "/user/course"
    /** 我的私教课列表 */
    static let PersonalCourseList = Version + "/user/trainer"
    /** 获取公告详情 */
    static let GetAnnInfo = Version + "/ann"
    /** 私教课预约详情 */
    static let TrainerReservation = Version + "/order/trainer"
    /** 获取我的个人详情信息 */
    static let UserInfo = Version + "/user/"
    /** 更新个人详情信息 */
    static let UserUpdate = Version + "/user"
    /** 我的订单列表 */
    static let GetOrderList = Version + "/user/order"
    /** 运动数据柱状图 */
    static let SportStats = Version + "/sport/get-user-stat"
    /** 运动数据历史 */
    static let SportHistoryStats = Version + "/sport/user-stat"
    /** 手环历史数据 */
    static let GetBraceletHistoryData = Version + "/sport/bracelet-history"
    /** 私教课订单重新计算接口 */
    static let Calculate = Version + "/order/calculate"
    /** 绑定(解绑)手环到设备 */
    static let BindDevice = Version + "/bracelet/bind"
    /** 获取手环配置信息 */
    static let BraceletConfig = Version + "/bracelet/config"
    /** 购卡列表 */
    static let CardList = Version + "/card"
    /** 购卡详情 */
    static let CardInfo = Version + "/card/"
    /** 会员中心 */
    static let MemberCenter = Version + "/user/user-info"
    /** 获取历史页面顶部导航 */
    static let UserBodyModulesHistory = Version + "/sport/body-modules-history"
    /** 获取体测数据单个字段历史值 */
    static let UserBodyColumnHistory = Version + "/sport/body-column-history"
    /** 会员卡订单提交 */
    static let OrderSubmitCard = Version + "/order/buy-card"
    /** 私教课去支付接口 */
    static let TrainerPay = Version + "/order/course-personal"
    /** 自助排课时间数组 */
    static let GymScheduleInfo = Version + "/course/gym-schedule-info"
    /** 自助排课 */
    static let ScheduleCourse = Version + "/course/add-schedule"
    /** 自助排课列表 */
    static let ScheduleCourseList = Version + "/course/can-schedule-course-list"
    /** 上传手环数据 */
    static let SaveSportData = Version + "/sport/save-sport-data"
    /** 团体课取消 */
    static let CancelTeamCourse = Version + "/order/cancel-course-team"
    /** 获取AliyunOSS的配置 */
    static let GetAliyunOSSConfigure = "sts"
    /** 付费团体课购买提交 */
    static let SubmitCourseConfirm = Version + "/order/charge-course"
    /** 小团课购买 */
    static let BuylittleGroupCourseConfirm = Version + "/team-course/buy-little-course"//
    
    /** 手环详情 */
    static let BuyBraceletInfo = Version + "/order/bracelet"
    /** 购买手环 */
    static let BuyBracelet = Version + "/order/bracelet"
    /** 登录成功后上传设备信息 */
    static let UserDevice = Version + "/user/record-device"
    /** 成为教练 */
    static let JoinApply = Version + "/join"
    /** 获取用户体测数据 */
    static let GetUserBodyData = Version + "/sport/body"
    /** 获取已开通城市列表 */
    static let GetOpenCityList = Version + "/gym/open"
    /** 获取蓝牙开门信息 */
    static let GetOpenDoorInfo = Version + "/visit/mac"
    /** 获取蓝牙开门指令所需要发送的内容 */
    static let GetOpenDoorContent = Version + "/visit/open"
    /** 检查用户是否有体验次数 */
    static let CheckUserVisit = Version + "/user/check-user-visit"
    /** 获取手环固件信息 */
    static let GetBraceletFirmwareInfo = Version + "/index/upgrade"
    
    /** 小团课/团操课预约 */
    static let SubscribeCoursesInfo = Version + "/team-course/res-littleteam-course"
    /** 小团课购买 */
    static let BuyLittleGroupCourse = Version + "/team-course/buy-little-course"
    /**私教课获取预约时间*/
    static let  TrainerSubscribeTime = Version + "/personal-time"
    /**私教课预约详情*/
    static let  TrainerSubscribeInfo = Version + "/course-personal/get-remain-course"
    /**私教课预约提交*/
    static let  PostTrainerSubscribe = Version + "/course-personal/res-personal-course"
    
    /** 个人中心-我的预约列表 */
    static let MyScheduleList = Version + "/user/schedule"
    
    /** 个人中心-消息 */
    static let MyNoticeList = Version + "/message"
    
    /** 个人中心-课程详情 */
    static let CourseDetail = Version + "/user/course-info"
    
    /** 个人中心- 私教课课程详情 */
    static let TrainerCourseDetail = Version + "/user/trainer-course"
    
    /** 个人中心- 私教课-接受预约 */
    static let AcceptAppointment = Version + "/user/accept"
    
    /** 个人中心- 私教课-拒绝预约 */
    static let RefuseAppointment = Version + "/user/refuse"
    
    /** 个人中心-取消预约 */
    static let CanceledSchedule = Version + "/course/cancel"
    
    /** 个人中心-评价 */
    static let CommentCourse = Version + "/course/evaluation"
    
    
    static let GETAPI: [String: String] = [TimeStamp: "时间戳", TrainerGym: "私教列表", CourseGym: "团体课列表", CourseInfo: "团体课详情", TrainerInfo: "私教课详情", CourseChargeInfo: "收费团体课详情付款", FetchCoupon: "优惠券列表", BaseConfig: "基础配置", GymInfo: "获取场馆详情", TrainerReservation: "私教课预约详情", UserInfo: "获取我的个人详情信息", SportStats: "运动数据柱状图", GetOrderList: "获取我的订单列表", SportHistoryStats: "运动数据历史", GetBraceletHistoryData: "手环历史数据", Calculate: "私教课订单重新计算接口", CardList: "购卡列表", MemberCenter: "会员中心", GetUserBodyData: "获取用户体测数据", UserBodyModulesHistory: "获取历史页面顶部导航", UserBodyColumnHistory: "获取体测数据单个字段历史值", CardInfo: "购卡详情", CheckUpdate: "检查更新", BuyBraceletInfo: "手环详情", GetAnnInfo: "获取公告详情", PersonalCourseList: "我的私教课列表", TeamCourseList: "我的团体课列表", GetOpenDoorInfo: "获取蓝牙开门信息", CheckUserVisit: "检查用户是否有体验次数", GetBraceletFirmwareInfo: "获取手环固件信息"]
    static let POSTAPI: [String: String] = [Index: "首页", Login: "登录", OrderFreeCourse: "预约免费团体课", CouponExchangeCoupon: "兑换优惠券", OrderSubmitCard: "会员卡订单提交", TrainerPay: "私教课去支付接口", Captcha: "验证码", SubmitCourseConfirm: "付费团体课购买提交", BuyBracelet: "购买手环", UserDevice: "登录成功后上传设备信息", JoinApply: "成为教练", GetAliyunOSSConfigure: "获取AliyunOSS的配置"]
    static let PUTAPI: [String: String] = [UpdateUser: "更新用户信息", RefreshToken: "更新token", BindDevice: "绑定(解绑)手环到设备",BraceletConfig:"获取手环配置信息"]
    static let DELETEAPI: [String: String] = [Logout: "退出登录"]
}

extension String {
    
    func r(_ route: String) -> String {
        var r = self
        while r.hasSuffix("/") {
            r.remove(at: index(before: endIndex))
        }
        return r + "/" + route
    }
    
}

