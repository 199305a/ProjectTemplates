//
//  ProfileFooterView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/12.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class ProfileFooterView: BaseView {
    
    let imageView = UIImageView.init(image: UIImage.init(named: "profile_card_footer"))
    let topLabel = BaseLabel()
    let bottomLabel = BaseLabel()
    
    override func customizeInterface() {
        frame = CGRectMake(0, 0, Layout.ScreenWidth, 130)
        clipsToBounds = false
        backgroundColor = UIColor.clear
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(-5)
        }
        imageView.addSubview(topLabel)
        imageView.addSubview(bottomLabel)
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView).offset(43)
            make.centerX.equalTo(imageView)
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.centerX.equalTo(imageView)
        }
        topLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold20)
        bottomLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.bold15)
        topLabel.text = "成为会员"
        bottomLabel.text = "开启COMMA之旅"
        topLabel.setWordSpace(15)
        bottomLabel.setWordSpace(10)
    }
}
