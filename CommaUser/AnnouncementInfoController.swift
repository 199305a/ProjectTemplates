//
//  AnnouncementInfoController.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/17.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 描述 公告详情
class AnnouncementInfoController: BaseController {
    
    var annId = ""
    
    let titleLabel = BaseLabel()
    let msgLabel = BaseLabel()
    let dateLabel = BaseLabel()
    var scrollView: UIScrollView!
    var readSuccess: ((String) -> Void)?
    let contentAttrbutes: [NSAttributedStringKey:Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        return [.font: UIFont.appFontOfSize(15),
         .foregroundColor: UIColor.hx5c5e6b,
         .paragraphStyle: paragraphStyle]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.AnnouncementInfo
        
        scrollView = UIScrollView.init(frame: view.bounds)
        scrollView.contentSize.width = view.bounds.width
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        msgLabel.numberOfLines = 0
        dateLabel.textColor = UIColor.hx9b9b9b
        dateLabel.font = UIFont.appFontOfSize(15)
        dateLabel.textAlignment = .right
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(msgLabel)
        scrollView.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.top.equalTo(20)
            make.right.equalTo(view.snp.right).offset(-15)
        }
        msgLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-15)
            make.top.equalTo(msgLabel.snp.bottom).offset(18)
        }
        
    }
    
    func requestData() {
        showLoading()
        NetWorker.get(ServerURL.GetAnnInfo.r(annId), success: { (dataObj) in
            self.hideHUD()
            let ann = MessageModel.parse(dict: dataObj)
            self.titleLabel.text = ann.gym_name
            self.msgLabel.attributedText = NSAttributedString.init(string: ann.content.nonOptional, attributes: self.contentAttrbutes)
            self.dateLabel.text = ann.create_time
            self.scrollView.contentSize.width = self.view.bounds.width
            self.readSuccess?(self.annId)
        }, error: { (code, msg) in
            self.showErrorWithMessage(msg)
        }) { (error) in
            self.showNetErrorMessage()
        }
    }
}
