//
//  BuyTeamCourseHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BuyTeamCourseHeaderView: CourseInfoHeaderView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        amountLabel.isHidden = true
        avatarImageView.isHidden = true
        
        containerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-25)
            make.width.equalTo(Layout.ScreenWidth - 30)
        }
        
        nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(containerView).offset(20)
            make.top.equalTo(containerView).offset(25)
            make.right.lessThanOrEqualTo(containerView).offset(-29)
        }
    }
    
      var courmodel: CourseInfoModel? {
        didSet {
        guard let model = courmodel else { return }
                    avatarImageView.sd_setImage(with: URL.stringURL(model.images.first), placeholderImage: UIImage.init(named: "course_info"))
                    nameLabel.text = model.course_name
                    amountLabel.text = model.wholeAmount
                    timeDetailLabel.text = model.wholeDate
                    placeDetailLabel.text = model.gym_name.nonOptional + model.room_name.nonOptional
                    trainerDetailLabel.text = model.trainer?.isEmpty == true ? "无" : model.trainer
                    addressDetailLabel.text = model.address
                    levelView.level = model.course_intensity
                    addressDetailLabel.setLineSpace(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



