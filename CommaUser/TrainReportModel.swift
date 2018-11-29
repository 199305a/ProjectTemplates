//
//  TrainReportModel.swift
//  CommaUser
//
//  Created by user on 2018/11/8.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class TrainReportModel: BaseModel {
    var report_id = ""      //训练记录 ID
    var times = ""          //次数
    var weight = ""         //重量
    var duration = ""       //持续时间
    var action_name = ""    //项目名称
    var pid = ""            //训练记录父 ID
}

class TrainReportListModel: BaseModel {
    var action_name = ""
    var list: [TrainReportModel] = []
}

class TrainReportsListModel: BaseModel {
    var title = ""
    var list: [TrainReportListModel] = []
}

class MyTrainCoureseDetailModel: BaseModel {
    var course_status = -1
    var course_name = ""
    var trainer_name = ""
    var people_num = -1
    var remark = ""
    var advance_end_reason = ""
    var having_remark = ""
    var cancel_reason = ""
    var day = ""
    var week = ""
    var time = ""
    var gym_name = ""
    var address = ""
    var report: [TrainReportsListModel] = []
    var is_report = -1
    var is_evaluate = ""
    
    var has_report: Bool {
        return is_report == 1
    }
    
    var courseStatus: MyCourseStatusType? {
        return MyCourseStatusType(rawValue: course_status)
    }
}
