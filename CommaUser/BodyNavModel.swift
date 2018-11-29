//
//  BodyNavModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BodyNavModel: BaseModel {
    var nav_data: [BodyNavInfoModel]?
    var history_data: [BodyAnalyseDataModel]?
    var title: String?
}

class BodyNavInfoModel: BaseModel {
    var column: String? // 字段名,用于获取历史记录值
    var chinese_name: String?
    var english_name: String?
    var unit: String?
}


class BodyAnalyseDataModel: BaseModel {
    var value: Double = InvalidDouble
    var body_time: String?
}
