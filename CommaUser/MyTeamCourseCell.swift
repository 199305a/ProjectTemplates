//
//  MyTeamCourseCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MyTeamCourseCell: NoSelectStyleCell {
    
    var model: MyTeamCourseModel! {
        didSet {
            titleLabel.text = model.course_name
            timeLabel.text = model.timeDesc
            gymLabel.text = model.locDesc
            statusLabel.text = model.courseStatus?.description
            descLabel.isHidden = model.courseStatus != .doing
            opeBtn.isHidden = !model.cancelEnable
            if model.schedule_type == "2" { // 自助
                feeLabel.text = Text.SelfHelp
            } else {
                let attributedText = NSMutableAttributedString.init(attributedString: priceSignAttributedText)
                    attributedText.append(NSAttributedString.init(string: model.price.nonOptional, attributes: [.font: UIFont.bold20]))
                feeLabel.attributedText = attributedText
            }
            
            if model.courseStatus == .notStart || model.courseStatus == .doing {
                feeLabel.textColor = UIColor.hx129faa
                statusLabel.textColor = UIColor.hx129faa
            } else {
                feeLabel.textColor = UIColor.hx9b9b9b
                statusLabel.textColor = UIColor.hx9b9b9b
            }
        }
    }
    
    var opeBtnClick: EmptyClosure?
    
    let timeLabel = BaseLabel()
    let gymLabel = BaseLabel()
    let statusLabel = BaseLabel()
    let opeBtn = BaseButton()
    let descLabel = BaseLabel()
    let feeLabel = BaseLabel()
    
    let priceSignAttributedText = NSMutableAttributedString.init(string: "¥", attributes: [.font: UIFont.bold12])
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.backgroundColor
        containerView.backgroundColor = UIColor.white
        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 6
        containerView.layer.shadowColor = UIColor.hx129faa.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOffset = CGSizeMake(0, 3)
        titleLabel = BaseLabel()
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.boldAppFontOfSize(20)
        titleLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.hx9b9b9b
        timeLabel.font = UIFont.boldAppFontOfSize(12)
        gymLabel.textColor = UIColor.hx9b9b9b
        gymLabel.font = UIFont.boldAppFontOfSize(12)
        statusLabel.font = UIFont.boldAppFontOfSize(20)
        descLabel.textColor = UIColor.hx9b9b9b
        descLabel.font = UIFont.appFontOfSize(15)
        descLabel.text = "进行中的课程不能取消"
        opeBtn.setTitle(Text.Cancel, for: .normal)
        opeBtn.setTitleColor(UIColor.hx5c5e6b, for: .normal)
        opeBtn.titleLabel?.font = UIFont.appFontOfSize(15)
        opeBtn.layer.borderWidth = 1
        opeBtn.layer.cornerRadius = 5
        opeBtn.layer.borderColor = UIColor.hx5c5e6b.cgColor
        feeLabel.font = UIFont.boldAppFontOfSize(15)
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(gymLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(opeBtn)
        containerView.addSubview(feeLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(7.5, 15, 7.5, 15))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(20)
            make.right.equalTo(feeLabel.snp.left).offset(10)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        gymLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gymLabel)
            make.top.equalTo(gymLabel.snp.bottom).offset(13)
            make.bottom.equalTo(-20)
        }
        feeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLabel)
            make.right.equalTo(-20)
        }
        opeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(feeLabel)
            make.centerY.equalTo(statusLabel)
            make.size.equalTo(CGSize.init(width: 60, height: 30))
        }
        descLabel.snp.makeConstraints { (make) in
            make.right.equalTo(feeLabel)
            make.centerY.equalTo(statusLabel)
        }
        
        opeBtn.rx.tap.bind { [unowned self] in
            self.opeBtnClick?()
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
