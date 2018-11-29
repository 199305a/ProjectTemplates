//
//  CourseInfoViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseInfoViewModel: PayViewModel {
    var dataSource = Variable.init(CourseItemInfoModel())
    
    var priceListSource = Variable.init(CourseMemberModel())

    var collectionDataSource = Variable.init([String]())
    var scheduleID: String?
    
   override func updateDataSources() {
        showHUD()
    let params:Dic = ["schedule_id":scheduleID!]
        NetWorker.get(ServerURL.CourseInfo,params:params , success: { (dataObj) in
            self.updateNetSuccess()
            
            let model = CourseItemInfoModel.parse(dict: dataObj)
            self.dataSource.value = model
            self.collectionDataSource.value = model.gym_images
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }
    
    
    func getPriceListWithScheduleID(success:SuccessedClosure?, error: ErrorClosure?, failed: FailedClosure?){
        NetWorker.get(ServerURL.GetlittleCoursePriceList, success: { (dataObj) in
            success?(dataObj)
        }, error: { (code, msg) in
            error?(code,msg)
        }) { (error) in
            failed?(error)
        }
    }
    
    
    
}
