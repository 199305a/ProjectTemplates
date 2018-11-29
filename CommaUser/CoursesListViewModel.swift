//
//  CoursesListViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/16.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CoursesListViewModel: PagingViewModel {
    
    var dataSource = Variable.init(CoursesIndexListModel())
    
    var classType: ClassType!

    override func updateDataSourcesByPull(_ pullRefresh: Bool) {
        super.updateDataSourcesByPull(pullRefresh)
        
        let params:Dic = ["gym_id":CurrentGymID.intValue!,"course_category":self.classType.rawValue]
        
        NetWorker.get(ServerURL.CourseGym, params: params, success: { (dataObj) in
            let data = CoursesIndexListModel.parse(dict: dataObj)
            self.updateData(&self.dataSource.value.list, list: data.list, pullRefresh: pullRefresh)
            data.list = self.dataSource.value.list
            if data.list.count > 0 {
            self.dataSource.value = data
            }
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }
    
}
