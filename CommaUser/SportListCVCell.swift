//
//  SportListCVCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/9/19.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import TextAttributes

class SportListCV0Cell: BaseCollectionViewCell {
    
    let attr = TextAttributes()
    
    let imageView = UIImageView()
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        titleLabel = BaseLabel()
        titleLabel.font = UIFont.boldAppFontOfSize(14)
        titleLabel.textColor = UIColor.hexColor(0xf5f5f5)
        detailLabel = BaseLabel()
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(25)
            make.centerY.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(18)
            make.centerY.equalTo(imageView)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-25)
            make.centerY.equalTo(imageView)
            
        }
    }
    
    override func setUpModel(_ aModel: AnyObject?, atIndexPath indexPath: IndexPath) {
        guard let model = aModel as? SportListWeekMonthDataModel else {
            return
        }
        
        let unit: String
        let detail: String
        let title: String
        var image: UIImage?
        switch indexPath.row {
        case 0:
            unit = "  Mins"
            title = Text.ExerciseDuration
            detail = model.total_seconds ?? "-"
            image = UIImage.init(named: "sport_time")
        case 1:
            unit = "  Days"
            title = Text.KeepSportDays
            detail = model.total_day ?? "-"
            image = UIImage.init(named: "sport_calendar")
        case 2:
            unit = "  Kcal"
            title = Text.BurnCal
            detail = model.total_cal ?? "-"
            image = UIImage.init(named: "sport_cal")
        default:
            unit = "  Times"
            title = Text.DoneSportTimes
            detail = model.total_time ?? "-"
            image = UIImage.init(named: "sport_goal")
        }
        
        attr.font(UIFont.init(name: Text.Impact, size: 25)).foregroundColor(UIColor.hx34c86c)
        let detail0 = NSAttributedString.init(string: detail, attributes: attr)
        attr.font(UIFont.init(name: Text.Impact, size: 12)).foregroundColor(UIColor.hexColor(0xf5f5f5))
        let detail1 = NSAttributedString.init(string: unit, attributes: attr)
        
        let detailStr = NSMutableAttributedString.init(attributedString: detail0)
        detailStr.append(detail1)
        
        imageView.image = image
        titleLabel.text = title
        detailLabel.attributedText = detailStr
    }
}


class SportListCV1Cell: SportListCV0Cell {
    
    let rightLabel = BaseLabel()
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        titleLabel = BaseLabel()
        titleLabel.font = UIFont.boldAppFontOfSize(14)
        titleLabel.textColor = UIColor.hexColor(0xf5f5f5)
        detailLabel = BaseLabel()
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(rightLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(25)
            make.centerY.equalTo(imageView)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.left).offset(110)
            make.centerY.equalTo(contentView)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-25)
            make.centerY.equalTo(titleLabel)
        }
        
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(rightLabel.snp.left).offset(-35)
            make.centerY.equalTo(titleLabel)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8)
        }
        
    }
    
    override func setUpModel(_ aModel: AnyObject?, atIndexPath indexPath: IndexPath) {
        guard let model = aModel as? SportListWeekMonthDataModel else {
            return
        }
        
        let unit: String
        let detail: String
        let title: String
        let right: String
        var image: UIImage?
        switch indexPath.row {
        case 0:
            unit = "  Km"
            title = Text.RunStep
            detail = model.run_distance ?? "-"
            right = model.run_time ?? "-"
            image = UIImage.init(named: "sport_run")
        case 1:
            unit = "  Times"
            title = Text.PowerTraining
            detail = model.smartspot_exercise ?? "-"
            right = model.smartspot_time ?? "-"
            image = UIImage.init(named: "sport_SMARTSPOT")
        case 2:
            unit = "  Times"
            title = Text.GroupClass
            detail = model.course ?? "-"
            right = model.course_time ?? "-"
            image = UIImage.init(named: "sport_course")
        default:
            unit = "  Times"
            title = Text.PrivateClass
            detail = model.personal ?? "-"
            right = model.personal_time ?? "-"
            image = UIImage.init(named: "sport_trainer")
        }
        
        attr.font(UIFont.init(name: Text.Impact, size: 25)).foregroundColor(UIColor.hx34c86c)
        let detail0 = NSAttributedString.init(string: detail, attributes: attr)
        let right0 = NSAttributedString.init(string: right, attributes: attr)
        attr.font(UIFont.init(name: Text.Impact, size: 12)).foregroundColor(UIColor.hexColor(0xf5f5f5))
        let detail1 = NSAttributedString.init(string: unit, attributes: attr)
        let right1 = NSAttributedString.init(string: "  Mins", attributes: attr)
        
        let detailStr = NSMutableAttributedString.init(attributedString: detail0)
        detailStr.append(detail1)
        
        let rightStr = NSMutableAttributedString.init(attributedString: right0)
        rightStr.append(right1)
        
        imageView.image = image
        titleLabel.text = title
        detailLabel.attributedText = detailStr
        rightLabel.attributedText = rightStr
    }
}


