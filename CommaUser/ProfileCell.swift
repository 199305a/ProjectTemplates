//
//  ProfileCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/12.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class ProfileCell: BaseTableViewCell {
    
     var detailText: String? {
        didSet {
            guard let model = detailText else {
                detailLabel.text = nil
                return
            }
            if model == "0" {
                detailLabel.text = nil
                return
            }
            detailLabel.text = model + "张未使用"
        }
    }
    
    var count: Int = 0 {
        didSet {
            numLabel.text = String(count > 0 ? count : 0)
            numLabel.backgroundColor = count > 0 ? UIColor.hxff564c : UIColor.white
            numLabel.sizeToFit()
            let kHeight = numLabel.width
            numLabel.layer.cornerRadius = numLabel.width / 2.0
            numLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(contentView)
                make.right.equalTo(arrowImageView.snp.left).offset(-11)
                make.width.height.equalTo(kHeight)
            }
        }
    }
    

    let numLabel = BaseLabel()
    let iconImageView = BaseImageView()
    let arrowImageView = BaseImageView()

    override func customizeInterface() {
        titleLabel = BaseLabel()
        detailLabel = BaseLabel()
        contentView.addSubview(iconImageView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(numLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
        }
        
        arrowImageView.image = UIImage.init(named: "user_info_arrow")
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
        titleLabel.font = UIFont.bold15
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }
        
        detailLabel.font = UIFont.boldAppFontOfSize(12)
        detailLabel.textColor = UIColor.hx129faa
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        numLabel.font = UIFont.bold15
        numLabel.textColor = UIColor.white
        numLabel.clipsToBounds = true
        numLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(arrowImageView.snp.left).offset(-11)
        }
    }
    
    func setUpModel(model: Any, atIndexPath indexPath: IndexPath) {
        let item = model as? ProfileItemType
        iconImageView.image = item?.image
        titleLabel.text = item?.title
        detailLabel.isHidden = item != .coupon
        numLabel.isHidden = !(item == .appointment || item == .announcement)
        
    }

}
