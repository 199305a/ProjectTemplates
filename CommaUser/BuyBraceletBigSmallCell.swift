//
//  BuyBraceletBigSmallCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/2.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BuyBraceletBigSmallCell: BaseTableViewCell {
    
    override func customizeInterface() {
        titleLabel = BaseLabel()
        detailLabel = BaseLabel()
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(contentView).offset(-20)
        }
        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold20)
        detailLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.appFontOfSize(15))
    }
    
     func setUpModel(indexPath: IndexPath) {
        var detail: String?
        var title: String?
        switch indexPath.row {
        case 3:
            detail = "颜色随机(商务黑、简约白)"
            title = "颜色"
        case 4:
            detail = "1"
            title = "数量"
        default:
            detail = nil
            title = "领取场馆"
        }
        detailLabel.text = detail
        titleLabel.text = title
    }
}
