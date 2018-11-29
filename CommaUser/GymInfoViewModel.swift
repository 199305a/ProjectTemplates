//
//  GymInfoViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GymInfoViewModel: BaseViewModel {
    var dataSource = Variable.init(GymInfoModel())
    
    func updateDataSources(_ gymID: String) {
        showHUD()
        NetWorker.get(ServerURL.GymInfo.r(gymID), success: { (dataObj) in
            self.updateNetSuccess()
            let model = GymInfoModel.parse(dict: dataObj)
            self.dataSource.value = model
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
        
    }
}
