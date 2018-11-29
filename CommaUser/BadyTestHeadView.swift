//
//  BadyTestHeadView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BadyTestHeadView: BaseView {
    
    var userInfo: UserDataModel! {
        didSet{
            if userInfo == nil { return }
            avatorImageView.lf_setImage(with: URL.init(string: userInfo.avatar.nonOptional), placeholderImage: AppUser.gender.userPlaceholderImage)
            nameLabel.text = userInfo.name
            genderSign.image = userInfo.sexIcon
            heightLabel.text = userInfo.heightDesc
            ageLabel.text = userInfo.ageDesc
        }
    }

    let userInfoView = BaseView()
    let avatorImageView = BaseImageView()
    let nameLabel = BaseLabel()
    let maleImg = UIImage.init(named: "user_gender_male")
    let femaleImg = UIImage.init(named: "user_gender_female")
    let genderSign = BaseImageView(image: UIImage.init(named: "user_gender_male"))
    let ageLabel = BaseLabel()
    let heightLabel = BaseLabel()
    let timeLabel = BaseLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size = CGSize.init(width: Layout.ScreenWidth, height: 132.5)
        backgroundColor = UIColor.clear
        userInfoView.backgroundColor = UIColor.white
        avatorImageView.layer.cornerRadius = 22.5
        avatorImageView.layer.masksToBounds = true
        avatorImageView.contentMode = .scaleAspectFill
        nameLabel.textColor = UIColor.hx5c5e6b
        nameLabel.font = UIFont.appFontOfSize(15)
        ageLabel.textColor = UIColor.hx129faa
        ageLabel.font = UIFont.bold15
        heightLabel.textColor = UIColor.hx129faa
        heightLabel.font = UIFont.bold15
        timeLabel.textColor = UIColor.hx9b9b9b
        timeLabel.font = UIFont.appFontOfSize(12)
        genderSign.image = nil
        
        addSubview(userInfoView)
        userInfoView.addSubview(avatorImageView)
        userInfoView.addSubview(nameLabel)
        userInfoView.addSubview(genderSign)
        userInfoView.addSubview(ageLabel)
        userInfoView.addSubview(heightLabel)
        addSubview(timeLabel)
        
        userInfoView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(85)
            make.width.equalTo(self)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoView.snp.bottom).offset(18)
        }
        avatorImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(userInfoView)
            make.size.equalTo(CGSizeMake(45))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatorImageView)
            make.left.equalTo(avatorImageView.snp.right).offset(20)
        }
        genderSign.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(8)
            make.right.lessThanOrEqualTo(-15)
            make.size.equalTo(maleImg!.size)
            make.centerY.equalTo(nameLabel)
        }
        ageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(avatorImageView)
        }
        heightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ageLabel.snp.right).offset(12)
            make.centerY.equalTo(ageLabel)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(userInfoView.snp.bottom).offset(18)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
