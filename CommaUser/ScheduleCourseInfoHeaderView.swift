//
//  ScheduleCourseInfoHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class ScheduleCourseInfoHeaderView: BaseView {
    
    var model:ScheduleCourseModel! {
        
        didSet {
            if model == nil { return }
            logoImageView.lf_setAnimatingImage(with: model.img.first?.url.toURL, placeholderImage: UIImage.PlaceHolderGym)
            timeLabel.text = "时长：" + model.timeLength
            if let level = model.intensity.intValue {
                levelView.level = level
            }
        }
    }
    
    let logoImageView  = FillImageView()
    let timeLabel      = Font14Label()
    let levelLabel     = Font14Label()
    let levelView      = ClassLevelView()
    let lineView       = BaseView()
    let typeImageView  = TypeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(logoImageView)
        addSubview(timeLabel)
        addSubview(levelLabel)
        addSubview(levelView)
        addSubview(lineView)

        logoImageView.contentMode = .scaleAspectFill
        logoImageView.clipsToBounds = true
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(230)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
        }
        
        levelLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(15)
        }
        levelLabel.text = "强度："
        
        levelView.snp.makeConstraints { (make) in
            make.centerY.equalTo(levelLabel)
            make.left.equalTo(levelLabel.snp.right)
            make.size.equalTo(CGSizeMake(177, 14))
        }
        
        lineView.backgroundColor = UIColor.backgroundColor
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(10)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
