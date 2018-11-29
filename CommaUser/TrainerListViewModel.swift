//
//  TrainerListViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/14.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrainerListViewModel: PagingViewModel {
    
    var dataSource = Variable.init([CoursesTrainerModel]())

    override func updateDataSourcesByPull(_ pullRefresh: Bool) {
        super.updateDataSourcesByPull(pullRefresh)
        NetWorker.get(ServerURL.TrainerGym.r(CurrentGymID), params: pagingParams, success: { (dataObj) in
            self.updateNetSuccess()
            let list = dataObj.parseList(CoursesTrainerModel.self)
            self.updateData(&self.dataSource.value, list: list, pullRefresh: pullRefresh)
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }

}
