//
//  MessageListViewModel.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/26.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageListViewModel: PagingViewModel {
    
    var dataSource = Variable([MessageModel]())
    var mDataSource = Variable([MessagesModel]())
    var msgList: [MessageModel] {
        return dataSource.value
    }
    
    var haveNotices = [Bool]()
    var type = AnnounceType.announce
    
    override func updateDataSourcesByPull(_ pullRefresh: Bool) {
        super.updateDataSourcesByPull(pullRefresh)
        if type == .announce {
            fetchAnnounce(pullRefresh: pullRefresh)
        } else {
            fetchMessage(pullRefresh: pullRefresh)
        }
    }
    
    //MARK: 获取公告
    func fetchAnnounce(pullRefresh: Bool) {
        let params: Dic = ["page": pageModel.currentPage,
                           "gym_id": CurrentGymID]
        
        NetWorker.get(ServerURL.GetMyAnnouncements, params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let model = MessageListModel.parse(dict: dataObj)
            let msgList = model.list ?? [MessageModel]()
            self.haveNotices.removeAll()
            self.haveNotices.append(model.hasAnnounce)
            self.haveNotices.append(model.hasMessage)
            
            self.updateData(&self.dataSource.value, list: msgList, pullRefresh: pullRefresh)
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }
    
    //MARK: 获取消息
    func fetchMessage(pullRefresh: Bool) {
        var params = [String: AnyObject]()
        params["page"] = pageModel.currentPage as AnyObject?
        params["gym_id"] = CurrentGymID as AnyObject
        
        NetWorker.get(ServerURL.MyNoticeList, params: params, success: { (dataObj) in
            self.updateNetSuccess()
            let model = MessagesListModel.parse(dict: dataObj)
            self.haveNotices.removeAll()
            self.haveNotices.append(model.hasAnnounce)
            self.haveNotices.append(model.hasMessage)
            self.updateData(&self.mDataSource.value, list: model.list, pullRefresh: pullRefresh)
        }, error: { (statusCode, message) in
            self.updateNetFailed(message)
        }) { (error) in
            self.updateNetError()
        }
    }

}

