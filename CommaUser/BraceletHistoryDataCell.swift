//
//  BraceletHistoryDataCell.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/27.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BraceletHistoryDataCell: BaseTableViewCell {

    var model: BraceletHistoryModel! {
        didSet {
            timeLabel.text = model.measure_time
            stepLabel.text = model.step_num
            distanceLabel.text = model.distance
            heatLabel.text = model.kcal
        }
    }
    
    let timeLabel = BaseLabel()
    let stepLabel = BaseLabel()
    let distanceLabel = BaseLabel()
    let heatLabel = BaseLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 6
        contentView.layer.shadowColor = UIColor.hx129faa.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 12
        contentView.layer.shadowOffset = CGSizeMake(0, 4)
        
        timeLabel.textColor = UIColor.hx5c5e6b
        timeLabel.font = UIFont.DINProBoldFontOf(size: 20)
        let stepDescLabel = BaseLabel()
        stepDescLabel.text = "步数(Steps)"
        stepDescLabel.textColor = UIColor.hx5c5e6b
        stepDescLabel.font = UIFont.boldAppFontOfSize(12)
        stepLabel.textColor = UIColor.hx129faa
        stepLabel.font = UIFont.DINProBoldFontOf(size: 20)
        let distanceDescLabel = BaseLabel()
        distanceDescLabel.text = "距离(Km)"
        distanceDescLabel.textColor = UIColor.hx5c5e6b
        distanceDescLabel.font = UIFont.boldAppFontOfSize(12)
        distanceLabel.textColor = UIColor.hx129faa
        distanceLabel.font = UIFont.DINProBoldFontOf(size: 20)
        let heatDescLabel = BaseLabel()
        heatDescLabel.text = "热量(Kcal)"
        heatDescLabel.textColor = UIColor.hx5c5e6b
        heatDescLabel.font = UIFont.boldAppFontOfSize(12)
        heatLabel.textColor = UIColor.hx129faa
        heatLabel.font = UIFont.DINProBoldFontOf(size: 20)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(stepDescLabel)
        contentView.addSubview(stepLabel)
        contentView.addSubview(distanceDescLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(heatDescLabel)
        contentView.addSubview(heatDescLabel)
        contentView.addSubview(heatDescLabel)
        contentView.addSubview(heatLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(7.5, 15, 7.5, 15))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
        }
        stepLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width).dividedBy(3).offset(-40.0/3)
        }
        stepDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stepLabel)
            make.top.equalTo(stepLabel.snp.bottom).offset(4)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stepLabel.snp.right)
            make.width.centerY.equalTo(stepLabel)
        }
        distanceDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceLabel)
            make.top.equalTo(distanceLabel.snp.bottom).offset(4)
        }
        heatLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceLabel.snp.right)
            make.centerY.width.equalTo(distanceLabel)
        }
        heatDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(heatLabel)
            make.top.equalTo(heatLabel.snp.bottom).offset(4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
