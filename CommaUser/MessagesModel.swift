//
//  MessagesModel.swift
//  CommaUser
//
//  Created by user on 2018/10/31.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MessagesModel: BaseModel {
    var alert = ""
    var content = ""
    var is_read = ""
    var create_time = ""
    var schedule_id = ""
    var msg_url = ""
    var msg_type = ""  //类型：String  必有字段  备注：类型 1-系统通知， 2-私教课通知， 3-团体课通知
    
    var isRead: Bool {
        return is_read == "1"
    }
    
}

class MessagesListModel: BaseModel {
    var list: [MessagesModel] = []
    var has_more: Int = InvalidInteger
    var messageNum: Int = InvalidInteger //是否有未读消息
    var annNum: Int = InvalidInteger //是否有未读公告
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
