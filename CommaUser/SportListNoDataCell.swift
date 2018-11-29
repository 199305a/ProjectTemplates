//
//  SportListNoDataCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/27.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class SportListNoDataCell: BaseTableViewCell {

    override func customizeInterface() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
        }
        
        let view = UIView()
        containerView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(containerView)
        }
        avatarImageView = BaseImageView()
        titleLabel = BaseLabel()
        avatarImageView.image = UIImage.init(named: "error-no-sportdata")
        titleLabel.text = "无锻炼数据"
        titleLabel.setUp(textColor: UIColor.hx91b6b9, font: UIFont.bold20)
        
        view.addSubview(avatarImageView)
        view.addSubview(titleLabel)
        avatarImageView.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(view)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(view)
            make.top.equalTo(avatarImageView.snp.bottom)
        }
    }

}
