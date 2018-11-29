//
//  CoursesIndexModel.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/13.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import Foundation

class CoursesIndexModel: BaseModel {
    var gym: CoursesGymModel?
    var courses: [CoursesGroupModel] = []
    var trainers: [CoursesTrainerModel] = []
    var banners: [CoursesBannerModel] = []
    var is_new: Int = InvalidInteger
    
    var little_team_courseMSG: String?
    var team_courseMSG: String?
    
    var bracelet: Bracelet? {
        didSet{
            BraceletManager.shared.bracelet = bracelet
            if GlobalAction.isLogin {
                BraceletManager.shared.reportData()
            }
        }
    }
    var isNewUser: Bool {
        return is_new == 1
    }
    var canUseSelfHelpCourse: Bool {
        return gym?.can_schedule == 1
    }
}

class BraceletModel: BaseModel {
    
}

// 首页场馆模型
class CoursesGymModel: BaseModel {
    var distance: String?
    var gym_name: String?
    var city_id: String?
    var city_name: String?
    var gym_id: String?
    var tel: String?
    var bis_status: Int = InvalidInteger
    var bizStatus: GymBusinessStatus {
        return GymBusinessStatus.init(rawValue: bis_status) ?? .unknown
    }
    var can_schedule: Int = InvalidInteger
    
    var isEmpty: Bool {
        if distance == nil,
            gym_name == nil,
            city_id == nil,
            city_name == nil,
            gym_id == nil,
            tel == nil,
            bis_status == InvalidInteger,
            can_schedule == InvalidInteger {
            return true
        }
        return false
    }
}

class CoursesGroupModel: BaseModel, CourseCustomDate, CourseBooking {
    var schedule_id: String?
    var course_name: String?
    var price: String?
    var is_fee: Int = InvalidInteger
    var people_num: String?
    var booked_num: String?
    var start_time: String?
    var end_time: String?
    var images: [String] = []
    var date: String?
    var week: String?
    var isFee: Bool {
        return is_fee == 1
    }
}

class CoursesTrainerModel: BaseModel, CoursePriceProtocol {
    var trainer_name: String?
    var avatar: String?
    var gym_id: String?
    var trainer_id: String?
    var tags: [TagModel] = []
    var max_price: String?
    var min_price: String?
    
    var course_price: String?
}

class TagModel: BaseModel {
    var tag_name: String?
}

class CoursesBannerModel: BaseModel {
    var title: String?
    var img_url: String?
    var load_url: String?
    var load_type: Int = InvalidInteger
    var is_share: Int = InvalidInteger
    var is_login: Int = InvalidInteger
    var bannerType: BannerType {
        return BannerType.init(rawValue: load_type) ?? .unknown
    }
    var bannerNativeType: BannerNativeType {
        if bannerType != .native { return .unknown }
        guard let url = load_url else {
            return .unknown
        }
        return BannerNativeType.init(rawValue: url) ?? .unknown
    }
}

enum BannerType: Int {
    case unknown, HTML5, native
}

enum BannerNativeType: String {
    case unknown
    case card = "card"
}

enum GymBusinessStatus: Int {
    case unknown, preSale, onSale, offSale
}


class CoursesListModel: BaseModel {
    var courses: [CoursesGroupModel] = []
    var can_schedule: Int = InvalidInteger
    var canSchedule: Bool {
        return can_schedule == 1
    }
}

class Bracelet: BaseModel {
    var bracelet_mac: String?
    var bracelet_broadcast_id: String?
    var is_binded: Int = InvalidInteger
    var intensity: Int = InvalidInteger
    var heart_rate: Int = InvalidInteger
    var tel_remind: Int = InvalidInteger
    var wechat_remind: Int = InvalidInteger
    
    var isBind: Bool {
        return is_binded == 1
    }
}

extension Bracelet {
    var filterKeys: [String] {
        var keys = [String]()
        if let macAddress = bracelet_mac?.replacingOccurrencesOfString(":", withString: "").lowercased() {
            keys.append(macAddress)
////            keys.append("cc8555fb3e1e")
////            C3F6A2A0851D
//            keys.append("c3f6a2a0851d")

        }
        if let deviceId = bracelet_broadcast_id?.replacingOccurrencesOfString(":", withString: "").lowercased() {
            keys.append(deviceId)
        }
        return keys
    }
    func recognize(_ device: LSDeviceInfo) -> Bool {
        guard let macAddress = device.macAddress, let broadcastId = device.broadcastId else {
            return false
        }
        let checkMacAddress = filterKeys.contains(macAddress.replacingOccurrencesOfString(":", withString: "").lowercased())
        let checkBroadcastId = filterKeys.contains(broadcastId.replacingOccurrencesOfString(":", withString: "").lowercased())
        return checkMacAddress || checkBroadcastId
    }
}
