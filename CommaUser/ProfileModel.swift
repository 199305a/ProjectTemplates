//
//  ProfileModel.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/2.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class ProfileModel: BaseModel {

    var gym_name: String?
    var coupon_num: String?
    var card_status: Int = InvalidInteger
    var day: Int = InvalidInteger
    var color: Int = InvalidInteger
    var renew: Int = InvalidInteger
    var message_num: Int = InvalidInteger //公告消息数
    var course_num: Int = InvalidInteger //我的预约未读数
    var cards: [CardsListModel] = []
    var cardStatus: ProfileUserCardStatus {
        if !GlobalAction.isLogin { return .noCard }
        return ProfileUserCardStatus.init(rawValue: card_status) ?? .unknown
    }
    var memberType: MemberVipType {
        return MemberVipType.init(cardStatus: card_status, color: color) ?? .unknown
    }
    var showRenewButton: Bool {
        return renew == 1
    }
}


enum ProfileUserCardStatus: Int {
    case unknown, noCard, member, expired
}

enum CardColor: Int {
    case black = 1
    case blue, purple
}
