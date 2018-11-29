//
//  TrainerInfoViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrainerInfoViewModel: BaseViewModel {
    var dataSource = Variable.init(TrainerInfoModel())

    var trainerID: String!
    
    override func updateDataSources() {
        showHUD()
        var params: [String: Any] = [:]
        params["gym_id"] = CurrentGymID
        params["longitude"] = LocationManager.currentLocation?.longitude ?? "0"
        params["latitude"] = LocationManager.currentLocation?.latitude ?? "0"
        NetWorker.get(ServerURL.TrainerInfo.r(trainerID), params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let model = TrainerInfoModel.parse(dict: dataObj)
            self.dataSource.value = model
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }
    


    
}
