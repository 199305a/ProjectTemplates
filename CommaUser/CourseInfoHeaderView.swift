//
//  CourseInfoHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class CourseInfoHeaderView: BaseView {
    
    var model:CourseItemInfoModel? {
        
        didSet {
            guard let model = model else { return }
            avatarImageView.sd_setImage(with: URL.stringURL(model.course_images.first), placeholderImage: UIImage.init(named: "course_info"))
            nameLabel.text = model.course_name
            amountLabel.text = model.person_max
            timeDetailLabel.text = model.course_time
            placeDetailLabel.text = model.place.nonOptional
            trainerDetailLabel.text = model.trainer.nonOptional == "" ? "无" : model.trainer
            addressDetailLabel.text = model.address
            levelView.level = model.intensity?.intValue ?? 0
            addressDetailLabel.setLineSpace(8)
            
            priceLabel.text = "￥\(model.course_price.nonOptional)/课时"
            if model.course_price?.intValue == 0 {
                self.priceLabel.text = " FREE"
            }
            tagView.createCloudTagsWithTitles(model.course_tag)
//            tagView.createCloudTagsWithTitles(["小团体课","小团体323课","小团23体课","小团32222体课","小团体3课","小团3体课","小团体23课"])

            
        }
    }
    
    var classtype:ClassType?{
        didSet {
            if classtype! == .group {
                priceLabel.isHidden = true
                tagView.isHidden = true
                avarImg.isHidden = true
                line.isHidden = true

            }else {
                priceLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.top.equalTo(nameLabel.snp.bottom).offset(12)
                }
                
                tagView.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.top.equalTo(priceLabel.snp.bottom).offset(14)
                }
                
                levelLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(nameLabel)
                    make.top.equalTo(tagView.snp.bottom).offset(20)
                }
                

                
            }
        }
    }
    
    
    let avatarImageView = FillImageView()

    
    let nameLabel = BaseLabel()
    let amountLabel   = BaseLabel()
    
    let priceLabel = BaseLabel()
    let tagView = TagView()
    let avarImg = BaseImageView.init(image: UIImage.init(named: "courseInfoavar"))
    let line = BaseView()
    
    let timeLabel     = BaseLabel()
    let placeLabel    = BaseLabel()
    let trainerLabel  = BaseLabel()
    let addressLabel    = BaseLabel()

    let timeDetailLabel     = BaseLabel()
    let placeDetailLabel    = BaseLabel()
    let trainerDetailLabel  = BaseLabel()
    let addressDetailLabel    = BaseLabel()
    
    let levelLabel    = Font14Label()
    let levelView     = ClassLevelView()
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-15)
            make.width.equalTo(Layout.ScreenWidth - 30)
        }
        containerView.shadow()
        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(placeLabel)
        containerView.addSubview(trainerLabel)
        containerView.addSubview(levelLabel)
        containerView.addSubview(levelView)
        containerView.addSubview(addressLabel)
        
        containerView.addSubview(timeDetailLabel)
        containerView.addSubview(placeDetailLabel)
        containerView.addSubview(trainerDetailLabel)
        containerView.addSubview(addressDetailLabel)
        
        //MARK: - new
        containerView.addSubview(priceLabel)
        containerView.addSubview(tagView)
       containerView.addSubview(avarImg)
        containerView.addSubview(line)
        
        setUp(label: timeLabel)
        setUp(label: placeLabel)
        setUp(label: trainerLabel)
        setUp(label: levelLabel)
        setUp(label: addressLabel)
        
        setUp(detailLabel: timeDetailLabel)
        setUp(detailLabel: placeDetailLabel)
        setUp(detailLabel: trainerDetailLabel)
        setUp(detailLabel: addressDetailLabel)
        
        timeLabel.text = Text.Time + "："
        placeLabel.text = Text.Store + "："
        trainerLabel.text = Text.Coach + "："
        addressLabel.text = Text.Address + "："
        levelLabel.text = Text.Intensity + "："

        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(containerView)
            make.height.equalTo(244)
        }
        
        avatarImageView.custom(size: CGSizeMake(Layout.ScreenWidth - 30, 244), corner: [.topLeft, .topRight], cornerRadius: 4)
        
        amountLabel.textColor = UIColor.hx129faa
        amountLabel.font = UIFont.DINProBoldFontOf(size: 20)
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(25)
            make.right.equalTo(containerView).offset(-20)
        }
        
        nameLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold20)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(20)
            make.centerY.equalTo(amountLabel)
            make.right.lessThanOrEqualTo(amountLabel.snp.left).offset(-8)
        }
        
        levelLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }
        
        levelView.snp.makeConstraints { (make) in
            make.centerY.equalTo(levelLabel)
            make.left.equalTo(levelLabel.snp.right).offset(3)
            make.size.equalTo(CGSizeMake(108, 20))
        }
        
        trainerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(levelLabel.snp.bottom).offset(15)
            
        }

        trainerDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trainerLabel.snp.right).offset(7)
            make.top.equalTo(trainerLabel)
            make.right.lessThanOrEqualTo(containerView).offset(-29.reW_less_4_7)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(trainerDetailLabel.snp.bottom).offset(15)
        }
        
        timeDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(7)
            make.top.equalTo(timeLabel)
            make.right.lessThanOrEqualTo(containerView).offset(-29.reW_less_4_7)
        }
        
        placeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeDetailLabel.snp.bottom).offset(15)
        }
        
        
        placeDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(placeLabel.snp.right).offset(7)
            make.top.equalTo(placeLabel)
            make.right.lessThanOrEqualTo(containerView).offset(-29.reW_less_4_7)
        }

        addressLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addressDetailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(placeDetailLabel.snp.bottom).offset(15)
        }
    
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel.snp.right).offset(7)
            make.top.equalTo(addressLabel)
            make.right.equalTo(containerView).offset(-29.reW_less_4_7)
            make.bottom.equalTo(containerView).offset(-32)
        }
        addressDetailLabel.numberOfLines = 0
        
        line.backgroundColor = UIColorFromRGB(0xECECEC)
        line.snp.makeConstraints { (make) in
            make.right.equalTo(amountLabel.snp.left).offset(-10)
            make.size.equalTo(CGSize(width: 1, height: 16))
            make.centerY.equalTo(amountLabel)
        }
        
        avarImg.snp.makeConstraints { (make) in
            make.right.equalTo(line.snp.left).offset(-10)
//            make.size.equalTo(CGSize(width: 1, height: 16))
            make.centerY.equalTo(amountLabel)
        }
        
        priceLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.DINProBoldFontOf(size: 20))
        tagView.hiddeSection = false

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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

