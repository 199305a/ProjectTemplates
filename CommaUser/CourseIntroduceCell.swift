//
//  CourseIntroduceCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class CourseIntroduceCell: BaseTableViewCell {
    
    var model: ScheduleCourseModel! {
        didSet{
            introduceLabel.text = model.desc
            
            if model.tags.isEmpty {
                intensityLabel.isHidden = true
                introduceLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(intensityLabel)
                    make.top.equalTo(intensityLabel.snp.top)
                    make.right.equalTo(contentView).offset(-15)
                    make.bottom.equalTo(contentView).offset(-15)
                }
            } else {
                intensityLabel.isHidden = false
                intensityLabel.text = String.tagsToString(model.tags)
                introduceLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(intensityLabel)
                    make.top.equalTo(intensityLabel.snp.bottom).offset(15)
                    make.right.equalTo(contentView).offset(-15)
                    make.bottom.equalTo(contentView).offset(-15)
                }
            }
        }
    }
    
    var intensityLabel: BaseLabel!
    var introduceLabel: BaseLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let xline = BaseView()
        contentView.addSubview(xline)
        xline.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        xline.backgroundColor = UIColor.backgroundColor
        
        self.selectionStyle = .none
        let titleLabel = Font15Label()
        titleLabel.text = "课程介绍"
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(15)
        }
        
        intensityLabel = Font15Label()
        contentView.addSubview(intensityLabel)
        intensityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        intensityLabel.textColor = UIColor.hx129faa
        intensityLabel.adjustsFontSizeToFitWidth = true
        
        introduceLabel = Font14Label()
        contentView.addSubview(introduceLabel)
        introduceLabel.numberOfLines = 0
        introduceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(intensityLabel)
            make.top.equalTo(intensityLabel.snp.bottom).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
