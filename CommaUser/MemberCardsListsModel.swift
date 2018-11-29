//
//  MemberCardsListsModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MyOrderListsModel: BaseModel {
    var list: [MyOrderModel]!
    var has_more: Int = InvalidInteger
    var hasMore: Bool! {
        return has_more == 1
    }
}

class MyOrderModel: BaseModel {
    var order_state: Int = InvalidInteger
    var price: String?
    var pay_type: String?
    var order_type: String?
    var order_id: String?
    var order_time: String?
    var gym_name: String?
    var good_name: String?
    
    var orderDesc: String {
        return "订单号：" + order_id.nonOptional
    }
    var gymDesc: String {
        return "场馆：" + gym_name.nonOptional
    }
    var timeDesc: String {
        return "购买时间：" + order_time.nonOptional
    }

    var orderStatus: OrderStatus? {
        return OrderStatus.init(rawValue: order_state)
    }
    
    enum OrderType: Int {
        case card = 1
        case teamCourse
        case privateCourse
        case waterFee
        case sportEquipment
        
        var description: String {
            switch self {
            case .card:
                return "会员卡"
            case .teamCourse:
                return "团体课"
            case .privateCourse:
                return "私教课"
            case .waterFee:
                return "水费"
            case .sportEquipment:
                return "运动装备"
            }
        }
    }
    enum PayType: Int {
        case wx = 1
        case alipay
        case balance
        case free
        case pos
        
        var description: String {
            switch self {
            case .wx:
                return "微信支付"
            case .alipay:
                return "支付宝支付"
            case .balance:
                return "余额支付"
            case .free:
                return "免金额支付"
            case .pos:
                return "pos机支付"
            }
        }
    }
    enum OrderStatus: Int {
        case done = 1, canceled
        var description: String {
            switch self {
            case .done:
                return Text.Paid
            case .canceled:
                return Text.Canceled
            }
        }
    }
}

enum OrderListPayType: Int {
    case unknown = 0
    case card = 3
    case water
}

enum MemberCardInfoStatus: Int {
    case paid = 1
}

enum MemberCardBuyType: Int {
    case new = 1
    case renew
    case update
    
    func description() -> String {
        return MemberCardBuyType.string(self.rawValue)!
    }
    
    static func string(_ rawValue: Int) -> String? {
        switch rawValue {
        case 1:
            return Text.BuyCard
        case 2:
            return Text.CardRenewal
        case 3:
            return Text.CardUpgrade
        default:
            return nil
        }
    }
    
    static func stringType(_ rawValue: Int) -> String? {
        switch rawValue {
        case 1:
            return Text.Buy
        case 2:
            return Text.Renewal
        case 3:
            return Text.Upgrade
        default:
            return nil
        }
    }
}
