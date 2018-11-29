//
//  CouponListViewModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CouponListViewModel: PagingViewModel {
    var dataSource = Variable.init([CouponModel]())
    var isHistory = false
    var validModel: CouponValidModel?
    
    override func updateDataSourcesByPull(_ pullRefresh: Bool) {
        super.updateDataSourcesByPull(pullRefresh)
        
        var params = [String: Any]()
        params["history"] = isHistory ? 1 : 0
        if let model = validModel {
            params = model.setUp(params: params)
        } else {
            params["page"] = pageModel.currentPage
        }
        
        NetWorker.get(ServerURL.FetchCoupon, params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let model = [CouponModel].parse(dataObj.parseList)
            self.updateData(&self.dataSource.value, list: model, pullRefresh: pullRefresh)
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }
}
