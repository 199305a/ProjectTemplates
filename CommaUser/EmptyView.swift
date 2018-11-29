//
//  EmptyView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class EmptyView: BaseView {
    
    var turnToFirstBtn: BaseButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgV = UIImageView(image: UIImage(named: "error-no-course"))
        addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Layout.layoutScaleHeight(132))
            make.centerX.equalTo(self)
        }
        
        let descLabel = Font14Label()
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom).offset(15)
            make.centerX.equalTo(imgV)
        }
        descLabel.textColor = UIColor.hx596167
        descLabel.textAlignment = .center
        descLabel.text = "当前时间预留教练排团体课"
        
        turnToFirstBtn = BaseButton()
        addSubview(turnToFirstBtn)
        turnToFirstBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(Layout.layoutScaleHeight(35))
            make.centerX.equalTo(descLabel)
            make.size.equalTo(CGSizeMake(200, 40))
        }
        turnToFirstBtn.setTitle("前往首页查看数据", for: .normal)
        turnToFirstBtn.setTitleColor(UIColor.white, for: .normal)
        turnToFirstBtn.titleLabel?.font = UIFont.appFontOfSize(14)
        turnToFirstBtn.backgroundColor = UIColor.hx129faa
        turnToFirstBtn.layer.cornerRadius = 5
        turnToFirstBtn.layer.shadowOpacity = 0.5
        turnToFirstBtn.layer.shadowColor = UIColor.hx129faa.cgColor
        turnToFirstBtn.layer.shadowOffset = CGSize(width: 0,height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
