//
//  BuyTeamCourseViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyTeamCourseViewModel: PayViewModel {
    var dataSource = Variable.init(CourseInfoModel())
    var scheduleID: String!
    
    override func updateDataSources() {
        showHUD()
        NetWorker.get(ServerURL.CourseChargeInfo.r(scheduleID), success: { (dataObj) in
            self.updateNetSuccess()
            let model = CourseInfoModel.parse(dict: dataObj)
            self.dataSource.value = model
        }, error: { (statusCode, message) in
            self.updateNetFailed(statusCode, message: message)
        }) { (error) in
            self.updateNetError()
        }
    }
}
