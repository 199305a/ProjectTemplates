//
//  CouponModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class CouponModel: BaseModel {
    var coupon_code: String?
    var title: String?
    var date: String?
    var price: String?
    var use_condition: String?
    var available_time: String?
    var desc: String?
    var status_label: String?
    var reason: String?
    var coupon_status: Int = InvalidInteger
    var isAvailable: Bool {
        return coupon_status == 1
    }
    var gyms: String?
}


class CouponValidModel: BaseModel {
    var gymID: String?
    var amount: String?
    var type: PurchasingType?
    var subID: String?
    
    var json: String? {
        var params = [String: Any]()
        params["gym_id"] = gymID
        params["amount"] = amount
        params["aim"] = type?.couponCode
        params["sub_id"] = subID
        if params.count == 4 {
            return params.jsonString
        }
        return nil
    }
    
    class func with(gymID: String?, amount: String?, type: PurchasingType?, subID: String?) -> CouponValidModel {
        let model = CouponValidModel()
        model.gymID = gymID
        model.amount = amount
        model.type = type
        model.subID = subID
        return model
    }
    
    func setUp(params: [String: Any]) -> [String: Any] {
        guard gymID != nil, amount != nil, type?.couponCode != nil, subID != nil else {
            return params
        }
        var params = params
        params["gym_id"] = gymID
        params["amount"] = amount
        params["aim"] = type?.couponCode
        params["sub_id"] = subID
        return params
    }
}
