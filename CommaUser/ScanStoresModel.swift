//
//  ScanStoresModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit


class ScanStoresModel: BaseModel {
    var gym_id: String?
    var gym_name: String?
    var address: String?
    var distance: String?
    var images: [String]?
    var is_all_day: Int = 0
    var img: String? {
        return images?.first
    }
    var isWholeDay: Bool {
        return is_all_day == 1
    }
}
