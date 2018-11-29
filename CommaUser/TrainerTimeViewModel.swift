//
//  TrainerTimeViewModel.swift
//  CommaUser
//
//  Created by macbook on 2018/11/8.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class TrainerTimeViewModel: ListViewModel {
    
    let dataSource = Variable([TrainerTimeModel]())
    var trainerID: String!
    override func updateDataSources() {
        self.showHUD()
        var params: [String: Any] = [:]
        params["trainer_id"] = self.trainerID
        NetWorker.get(ServerURL.TrainerSubscribeTime,params: params,  success: { (dataObj) in
            let model = [TrainerTimeModel].parse(dataObj[NetWorker._innerKey] as!  [Any])
            self.updateData(&self.dataSource.value, list: model)
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }
}
