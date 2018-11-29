//
//  MyTrainingCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/19.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class MyTrainingCell: BaseTableViewCell {

    override func customizeInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.shadow()
        containerView.layer.cornerRadius = 6
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
            make.bottom.right.equalTo(contentView).offset(-15)
        }
        titleLabel = BaseLabel()
        detailLabel = BaseLabel()
        avatarImageView = BaseImageView()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        containerView.addSubview(avatarImageView)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.right.equalTo(containerView).offset(-35.layout)
        }
        
        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold20)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).offset(57)
            make.left.equalTo(containerView).offset(35)
        }
        
        detailLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.appFontOfSize(12))
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
        }
    }
    
     func setUp(indexPath: IndexPath) {
        let item = indexPath.row
        titleLabel.text = item == 0 ? "体测数据" : "运动数据"
        detailLabel.text = item == 0 ? "帮助你更有目的的锻炼" : "记录你挥洒的汗水"
        avatarImageView.image = item == 0 ? UIImage(named: "body_data") : UIImage(named: "train_data")
    }

}
