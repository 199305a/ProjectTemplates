//
//  BuyPrivateHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BuyPrivateHeaderView: BaseView {
    
    var trainerModel: BuyPrivateModel? {
        didSet {
            guard let model = trainerModel  else {
                return
            }
            nameLabel.text = (model.trainer_name ?? "-") + "的私教课"
            peopleDetailLabel.text = model.people_num
            timeDetailLabel.text = (model.courses.first?.duration ?? "-") + " min"
            placeDetailLabel.text = model.gym?.gym_name
            addressDetailLabel.text = model.gym?.address
        }
    }
    
    
    let nameLabel = BaseLabel()
    
    let timeLabel     = BaseLabel()
    let placeLabel    = BaseLabel()
    let peopleLabel  = BaseLabel()
    let addressLabel    = BaseLabel()
    
    let timeDetailLabel     = BaseLabel()
    let placeDetailLabel    = BaseLabel()
    let peopleDetailLabel  = BaseLabel()
    let addressDetailLabel    = BaseLabel()
    
    
    let containerView = UIView()
    
    override func customizeInterface() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-25)
            make.width.equalTo(Layout.ScreenWidth - 30)
        }
        

        containerView.shadow()
        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(placeLabel)
        containerView.addSubview(peopleLabel)
        containerView.addSubview(addressLabel)
        
        containerView.addSubview(timeDetailLabel)
        containerView.addSubview(placeDetailLabel)
        containerView.addSubview(peopleDetailLabel)
        containerView.addSubview(addressDetailLabel)
        
        setUp(label: timeLabel)
        setUp(label: placeLabel)
        setUp(label: peopleLabel)
        setUp(label: addressLabel)
        
        setUp(detailLabel: timeDetailLabel)
        setUp(detailLabel: placeDetailLabel)
        setUp(detailLabel: peopleDetailLabel)
        setUp(detailLabel: addressDetailLabel)
        
        peopleLabel.text = "上课人数："
        timeLabel.text = "单节课时长："
        placeLabel.text = "上课场馆："
        addressLabel.text = Text.Address + "："
        

        
        
        nameLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold20)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(containerView).offset(15)
            make.top.equalTo(containerView).offset(25)
            make.right.equalTo(containerView).offset(-19)
        }
        
        
        peopleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
        }
        
        peopleDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(peopleLabel.snp.right).offset(7)
            make.top.equalTo(peopleLabel)
            make.right.equalTo(containerView).offset(-19.reW_less_4_7)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(peopleDetailLabel.snp.bottom).offset(15)
        }
        
        timeDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(7)
            make.top.equalTo(timeLabel)
            make.right.equalTo(containerView).offset(-19.reW_less_4_7)
        }
        
        placeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeDetailLabel.snp.bottom).offset(15)
        }
        
        placeDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(placeLabel.snp.right).offset(7)
            make.top.equalTo(placeLabel)
            make.right.equalTo(containerView).offset(-19.reW_less_4_7)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(placeDetailLabel.snp.bottom).offset(15)
        }
        
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel.snp.right).offset(7)
            make.top.equalTo(addressLabel)
            make.right.equalTo(containerView).offset(-19.reW_less_4_7)
            make.bottom.equalTo(containerView).offset(-32)
        }
        
    }
    
    func setUp(label: UILabel) {
        label.textColor = UIColor.hx9b9b9b
        label.font = UIFont.bold15
    }
    
    func setUp(detailLabel: UILabel) {
        detailLabel.textColor = UIColor.hx5c5e6b
        detailLabel.font = UIFont.bold15
        detailLabel.numberOfLines = 0
    }
    
    
}

