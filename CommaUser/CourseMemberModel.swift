//
//  CourseMemberModel.swift
//  CommaUser
//
//  Created by macbook on 2018/10/29.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CourseMemberModel: BaseModel {
    var times:[CourseMemberinfoModel] = []
    var duration:[CourseMemberinfoModel] = []
}

class CourseMemberinfoModel: BaseModel {
    var title:String?
    var price:String?
    var selected:Bool = false
}
