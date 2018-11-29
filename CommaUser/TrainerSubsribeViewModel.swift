//
//  TrainerSubsribeViewModel.swift
//  CommaUser
//
//  Created by macbook on 2018/11/8.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class TrainerSubsribeViewModel: PayViewModel {
    let dataSource = Variable(BuyPrivateModel())
    var trainerID: String!
    
    override func updateDataSources() {
         super.updateDataSources()
        let params:Dic = ["trainer_id":trainerID!,"gym_id":CurrentGymID]
        
        NetWorker.get(ServerURL.TrainerSubscribeInfo, params: params, success: { (dataObj) in
            self.updateNetSuccess()
            self.dataSource.value = BuyPrivateModel.parse(dictionary: dataObj as NSDictionary)
        }, error: { (code, msg) in
            self.updateNetFailed(msg)
        }) { (error) in
            self.updateNetError()
        }
    }
}
