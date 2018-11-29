//
//  CustomViewCell.swift
//  ScrollCardDemo
//
//  Created by 陈晓龙 on 2017/7/17.
//  Copyright © 2017年 陈晓龙. All rights reserved.
//

import UIKit
import SDCycleScrollView

class CustomViewCell: BaseCollectionViewCell {
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        imageView.layer.cornerRadius = 12
//        imageView.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView)
//            make.centerX.equalTo(contentView)
//            make.width.equalTo(Layout.ScreenWidth - 40)
//            make.height.equalTo(160)
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func customizeInterface() {
        avatarImageView = FillImageView()
        contentView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 12
        avatarImageView.image = UIImage.init(named: "testpic")
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.width.equalTo(Layout.ScreenWidth - 40)
            make.height.equalTo(160)
        }
    }
    
}
