//
//  CoursesListItemCell.swift
//  CommaUser
//
//  Created by macbook on 2018/10/22.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

//预约cell
class CoursesListItemCell: BaseTableViewCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let timeLabel = BaseLabel()
    let priceLab = BaseLabel()
    let subacribeBtn = BaseButton()
    let tagView = TagView()
    
    var btnClick:EmptyClosure?
    
    
    override func customizeInterface() {
        contentView.addSubview(containerView)
        containerView.shadow()
        containerView.layer.cornerRadius = 6
        
        avatarImageView = BaseImageView()
        avatarImageView.layer.cornerRadius = 6
        avatarImageView.clipsToBounds = true
        titleLabel = BaseLabel()

        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold15)
        timeLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.font15)
        priceLab.setUp(textColor: UIColor.hx129faa, font: UIFont.bold15)
        
        subacribeBtn.titleLabel?.font = UIFont.font15
        subacribeBtn.setTitle("预约", for: .normal)
        subacribeBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        subacribeBtn.layer.borderWidth = 1
        subacribeBtn.layer.borderColor = UIColor.hx129faa.cgColor
        subacribeBtn.layer.cornerRadius = 5
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(tagView)

        containerView.addSubview(timeLabel)
        containerView.addSubview(priceLab)
        containerView.addSubview(subacribeBtn)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.bottom.right.equalTo(-15)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(11)
            make.top.equalTo(avatarImageView).offset(5)
        }
        
        priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(11)
            make.bottom.equalTo(avatarImageView).offset(-5)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(11)
            make.bottom.equalTo(priceLab.snp.top).offset(-5)
        }
        
        subacribeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-5)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        tagView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(avatarImageView.snp.right).offset(11)
            make.right.equalTo(-15)
        }
        
        avatarImageView.backgroundColor = UIColor.hx9b9b9b
        
        titleLabel.text = ""
        timeLabel.text = ""
        priceLab.text = ""
        
        subacribeBtn.isUserInteractionEnabled = false
        subacribeBtn.rx.tap.bind {
            if self.btnClick != nil {
                self.btnClick?()
            }
        }.disposed(by: disposeBag)
        
    }
    override func setUpModel(_ aModel: AnyObject) {
        if let model = aModel as? CoursesListContentModel {
            self.titleLabel.text = model.course_name.nonOptional
            self.avatarImageView.sd_setImage(with: URL.stringURL(model.images), placeholderImage: nil)
            self.timeLabel.text = model.course_time.nonOptional
            
            self.priceLab.text = "￥\(model.course_price.nonOptional)/课时"
            if model.course_price?.intValue == 0 {
                self.priceLab.text = " FREE"
            }
            
              tagView.createCloudTagsWithTitles(model.course_tag)

//            tagView.layoutTagsWithTitles(model.course_tag)
            if model.course_reservation_status == 0 {
                subacribeBtn.setTitle("预约", for: .normal)
                subacribeBtn.setTitleColor(UIColor.hx129faa, for: .normal)
                subacribeBtn.layer.borderColor = UIColor.hx129faa.cgColor
            }else  if model.course_reservation_status == 1 {
                subacribeBtn.setTitle("已预约", for: .normal)
                subacribeBtn.setTitleColor(UIColor.hx9b9b9b, for: .normal)
                subacribeBtn.layer.borderColor = UIColor.hx9b9b9b.cgColor
            }else if model.course_reservation_status == 7 {
                subacribeBtn.setTitle("已满员", for: .normal)
                subacribeBtn.setTitleColor(UIColor.hx9b9b9b, for: .normal)
                subacribeBtn.layer.borderColor = UIColor.hx9b9b9b.cgColor
            }
            
        }
    }

}

class CoursesListItemSectionHeader: UITableViewHeaderFooterView {
    
    let day = BaseLabel()
    let weak = BaseLabel()
    let date = BaseLabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let line = BaseView()
        line.backgroundColor = UIColor.hx9b9b9b
       
        contentView.backgroundColor = UIColor.backgroundColor
        day.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.PingFangSCMediumFontOf(size: 30))
        weak.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.font12)
        date.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.font12)
        
        contentView.addSubview(day)
        contentView.addSubview(weak)
        contentView.addSubview(date)
        contentView.addSubview(line)
        
        day.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(0)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(day.snp.right).offset(8)
            make.height.equalTo(23)
            make.width.equalTo(1)
            make.centerY.equalTo(day)
        }
        weak.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).offset(10)
            make.centerY.equalTo(line.snp.centerY).offset(-7)
        }
        date.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).offset(10)
            make.centerY.equalTo(line.snp.centerY).offset(9)
        }
        
        
        
        day.text = ""
        weak.text = ""
        date.text = ""
        
    }
    
    var model:CoursesListDetailModel?{
        didSet {
//            if let dayStr = self.model?.day,dayStr.count == 5 {
//                day.text = dayStr.subStringAtIndex(2)
//                date.text = "\(self.model?.year.nonOptional)年\(dayStr.subStringInRange(0, endIndex: 2))月"
//            }
            guard model != nil else {
                return
            }
            day.text = self.model?.day.nonOptional
            date.text = "\(self.model!.year.nonOptional)年\(self.model!.month.nonOptional)月"
//            date.text = self.model?.year_month.nonOptional

            weak.text = self.model?.week.nonOptional
        }
    }
    
    var TrainerModel:TrainerTimeModel? {
        didSet {
            guard TrainerModel != nil else {
                return
            }
            day.text = self.TrainerModel?.day.nonOptional
            date.text = "\(self.TrainerModel!.year.nonOptional)年\(self.TrainerModel!.month.nonOptional)月"
            //            date.text = self.model?.year_month.nonOptional
            
            weak.text = self.TrainerModel?.week.nonOptional
        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



