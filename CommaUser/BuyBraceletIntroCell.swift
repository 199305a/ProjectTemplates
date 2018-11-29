//
//  BuyBraceletIntroCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/2.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BuyBraceletIntroCell: BaseTableViewCell {
    
    override var dataSource: AnyObject? {
        didSet {
            guard let model = dataSource as? BuyBraceletModel else {
                return
            }
            titleLabel.text = model.name
            detailLabel.text = model.desc
            detailLabel.setLineSpace(6)
        }
    }
    
    override func customizeInterface() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-30)
            make.width.equalTo(Layout.ScreenWidth - 30)
        }
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.white
        contentView.insertSubview(shadowView, belowSubview: containerView)
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        shadowView.layer.cornerRadius = 6
        containerView.layer.cornerRadius = 6
        shadowView.shadow()
        
        let grayView = UIView()
        grayView.backgroundColor = UIColor.hexColor(0xd8d8d8).withAlphaComponent(0.1)
        containerView.addSubview(grayView)
        grayView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(containerView)
            make.height.equalTo(215)
        }
        avatarImageView = BaseImageView()
        avatarImageView.image = UIImage.init(named: "bracelet_intro")
        grayView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.center.equalTo(grayView)
        }
        
        titleLabel = BaseLabel()
        detailLabel = BaseLabel()
        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.DINProBoldFontOf(size: 20))
        detailLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.appFontOfSize(15))
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(20)
            make.top.equalTo(grayView.snp.bottom).offset(20)
        }
        detailLabel.numberOfLines = 0
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(20)
            make.right.equalTo(containerView).offset(-25)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(containerView).offset(-21)
        }
    }
    
}
