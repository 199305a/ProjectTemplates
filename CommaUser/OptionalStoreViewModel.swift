//
//  OptionalStoreViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OptionalStoreViewModel: ListViewModel {
    var dataSource = Variable.init([ScanStoresModel]())
    var cityId: String?
    var hasCard = Variable(false)
    
    override func updateDataSources() {
        var (lat, lng) = ("0", "0")
        if let loc = LocationManager.currentLocation, cityId == loc.city_id {
            (lat, lng) = (loc.latitude, loc.longitude)
        }
        let params = ["city_id":  cityId ?? Text.UnknowCityID,
                      "longitude": lng,
                      "latitude": lat]
        self.showHUD()
        NetWorker.get(ServerURL.GetGyms, params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let gyms = [ScanStoresModel].parse(dataObj.parseList)
            self.hasCard.value = (dataObj["has_card"] as? Int) == 1
            self.updateData(&self.dataSource.value, list: gyms)
        }, error: { (code, msg) in
            self.updateNetFailed(msg)
        }) { (_) in
            self.updateNetError()
        }
    }
    
}
