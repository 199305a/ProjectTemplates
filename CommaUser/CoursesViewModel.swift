//
//  CoursesViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/8.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class CoursesViewModel: CollectionViewModel {
    var dataSource: Variable<CoursesIndexModel> = {
        let model = CoursesIndexModel()
        let gym = CoursesGymModel()
        gym.gym_name = Text.Locating
        model.gym = gym
        return Variable.init(model)
    }()
    

    override func updateDataSources() {
        super.updateDataSources()
        let loc = LocationManager.currentLocation ?? LocationModel()
        let params = [
            "longitude": loc.longitude,
            "latitude": loc.latitude,
            "city_id": loc.city_id,
            "district_id": loc.district_id,
            "gym_id": CurrentGymID
        ]
        
        NetWorker.post(ServerURL.Index, params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let model = CoursesIndexModel.parse(dict: dataObj)
            if let gymID = model.gym?.gym_id {
                UserManager.shared.currentGymID = gymID
            }
            if let gym = model.gym {
                UserManager.shared.currentGym = gym
            }
            self.dataSource.value = model
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
        
    }
}
