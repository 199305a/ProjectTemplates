//
//  ProfileCardCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/3.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class ProfileCardCell: BaseTableViewCell {
    
    override var dataSource: AnyObject? {
        didSet {
            guard let model = dataSource as? CardsListModel else {
                return
            }
            titleLabel.text = model.card_name
            englishLabel.text = model.card_en_name
            englishLabel.setWordSpace(6)
            cardImageView.image = model.cardColor.profileImage
            titleLabel.textColor = model.cardColor.color
            detailLabel.textColor = titleLabel.textColor
            detailLabel.layer.borderColor = titleLabel.textColor.cgColor
            englishLabel.textColor = titleLabel.textColor.withAlphaComponent(0.3)
            priceLabel.textColor = titleLabel.textColor
            let unit = NSAttributedString.init(string: "￥ ", attributes: [.font: UIFont.DINProBoldFontOf(size: 15), .foregroundColor: titleLabel.textColor])
            let content = NSAttributedString.init(string: (model.price ?? "-").commasString, attributes: [.font: UIFont.DINProBoldFontOf(size: 20), .foregroundColor: titleLabel.textColor])
            let price = NSMutableAttributedString.init(attributedString: unit)
            price.append(content)
            priceLabel.attributedText = price
        }
    }
    
    let cardImageView = FillImageView()
    let englishLabel = BaseLabel()
    let priceLabel = BaseLabel()
    let backImageView = UIImageView.init(image: UIImage.init(named: "profile_card_background"))
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(backImageView)
        contentView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(-20)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(40)
        }
        
        titleLabel = BaseLabel()
        detailLabel = BaseLabel()
        
        cardImageView.addSubview(titleLabel)
        cardImageView.addSubview(detailLabel)
        cardImageView.addSubview(priceLabel)
        cardImageView.addSubview(englishLabel)
        
        englishLabel.font = UIFont.DINProBoldFontOf(size: 10)
        englishLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardImageView).offset(34)
            make.left.equalTo(cardImageView).offset(30)
        }
        
        titleLabel.font = UIFont.bold15
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(englishLabel.snp.bottom).offset(43)
            make.left.equalTo(englishLabel)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.lastBaseline.equalTo(titleLabel)
        }
        
        backImageView.clipsToBounds = true
        backImageView.contentMode = .scaleAspectFill
        backImageView.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(contentView)
            make.height.lessThanOrEqualTo(180)
        }

        
        detailLabel.text = "购买"
        detailLabel.font = UIFont.bold15
        detailLabel.layer.cornerRadius = 4
        detailLabel.layer.borderWidth = 1
        detailLabel.textAlignment = .center
        detailLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(75, 30))
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(cardImageView).offset(-30)
        }
        
    }
    
}
