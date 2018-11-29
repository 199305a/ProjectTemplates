//
//  MessageModel.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/26.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MessageModel: BaseModel {
    
    var ann_id: String?
    var content: String?
    var is_read: String?
    var create_time: String?
    var gym_name: String?
    
    //是否已读
    var isRead: Bool {
        return is_read == "1"
    }

}

class MessageListModel: BaseModel {
    var has_more: Int = InvalidInteger
    var messageNum: Int = InvalidInteger //是否有未读消息
    var annNum: Int = InvalidInteger //是否有未读公告
    var list: [MessageModel]?
    var hasMore: Bool! {
        return  has_more == 1
    }
    
    var hasMessage: Bool! {
        return messageNum == 1
    }
    
    var hasAnnounce: Bool! {
        return annNum == 1
    }
}
