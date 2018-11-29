//
//  Enum.swift
//  CommaUser
//
//  Created by user on 2018/11/7.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import Foundation

//MARK: - 小团体课操作
enum TeamCourseOperation {
    case cancelCourse              //取消预约
    case inClass              //课程进行中
    case endClass              //已上课
    case canceled              //已取消
    case endComment              //已经评论过
    
    var title: String {
        switch self {
        case .cancelCourse:
            return "取消预约"
        case .inClass:
            return "课程进行中"
        case .endClass:
            return "评价本次服务"
        case .endComment:
            return "课程已结束"
        default:
            return ""
        }
    }
}

//MARK: - 私教课操作
enum TrainerCourseOperation {
    case waitCertain          //待确认
    case cancelCourse         //取消预约
    case inClass              //课程进行中
    case noTrainRecord        //等待上传训练记录
    case endClass             //已上课
    case canceled             //已取消
    case endComment           //已经评论过
    case hasFreeze            //已冻结
    
    var title: String {
        switch self {
        case .cancelCourse:
            return "取消预约"
        case .inClass:
            return "课程进行中"
        case .noTrainRecord:
            return "等待上传训练记录"
        case .endClass:
            return "评价本次服务"
        case .endComment:
            return "课程已结束"
        case .hasFreeze:
            return "已冻结"
        default:
            return ""
        }
    }
}

enum MyCourseStatusType: Int {
    case waitCertain = 1
    case waitStart
    case haveFrozen
    case inClass
    case noSettlement
    case settled
    case canceled
    case deduction
    case turnBack
    
    var description: String {
        switch self {
        case .waitCertain:
            return Text.waitConfirm
        case .waitStart:
            return Text.ForClass
        case .haveFrozen:
            return Text.HaveFrozen
        case .inClass:
            return Text.InClass
        case .canceled:
            return Text.Canceled
        default:
            return Text.HaveClass
        }
    }
}


