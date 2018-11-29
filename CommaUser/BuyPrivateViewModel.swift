//
//  BuyPrivateViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyPrivateViewModel: PayViewModel {
    
    var dataSource = Variable.init(BuyPrivateModel())
    
    var timeSource = Variable.init([TrainerTimeModel]())

    var trainerID: String!
    
    
    override func updateDataSources() {
        showHUD()
        var params = [String: Any]()
        params["gym_id"] = CurrentGymID
        NetWorker.get(ServerURL.TrainerReservation.r(trainerID), params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let model = BuyPrivateModel.parse(dict: dataObj)
            self.dataSource.value = model
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
        
    }
    
}
