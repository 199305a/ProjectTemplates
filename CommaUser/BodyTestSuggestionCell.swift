//
//  BodyTestSuggestionCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BodyTestSuggestionCell: BodyTestBaseCell {
    
    var suggestion: ControlAdviseModel! {
        didSet{
            if suggestion == nil { return }
            guard let items = suggestion.body_data, items.count >= 2 else {
                return
            }
            titleLabel.text = suggestion.title
            musculView.item = items[0]
            fatView.item = items[1]
        }
    }
    
    let musculView = CircleView()
    let fatView = CircleView()
    
    override func customizeInterface() {
        super.customizeInterface()
        let descLabel = BaseLabel()
        descLabel.textColor = UIColor.hx9b9b9b
        descLabel.font = UIFont.appFontOfSize(12)
        descLabel.text = "更多建议请咨询店内教练"
        
        containerView.addSubview(musculView)
        containerView.addSubview(fatView)
        containerView.addSubview(descLabel)
        musculView.snp.makeConstraints { (make) in
            make.right.equalTo(containerView.snp.centerX).offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.size.equalTo(CGSizeMake(130.layout))
        }
        fatView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.centerX).offset(12)
            make.centerY.equalTo(musculView)
            make.size.equalTo(musculView)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(musculView.snp.bottom).offset(30)
            make.bottom.equalTo(-27)
            make.centerX.equalTo(containerView)
        }
        
    }
    

    class CircleView: BaseView {
        
        var item: AdviseDataModel! {
            didSet{
                if item == nil { return }
                titleLabel.text = item.chinese_name
                let value = item.value.doubleValue ?? 0
                signLabel.text = value >= 0 ? "+" : "-"
                numberLabel.text = String(fabs(value))
                unitLabel.text = item.unit
            }
        }
        
        let titleLabel = BaseLabel()
        let signLabel = BaseLabel()
        let numberLabel = BaseLabel()
        let unitLabel = BaseLabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            shadowLarge()
            clipsToBounds = false
            titleLabel.textColor = UIColor.hx5c5e6b
            titleLabel.font = UIFont.appFontOfSize(15)
            signLabel.textColor = UIColor.hx5c5e6b
            signLabel.font = UIFont.appFontOfSize(15)
            numberLabel.textColor = UIColor.hx129faa
            numberLabel.font = UIFont.DINProBoldFontOf(size: 20)
            unitLabel.textColor = UIColor.hx129faa
            unitLabel.font = UIFont.DINProBoldFontOf(size: 15)
            
            addSubview(titleLabel)
            addSubview(signLabel)
            addSubview(numberLabel)
            addSubview(unitLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(snp.centerY).offset(-1)
            }
            numberLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(2)
            }
            signLabel.snp.makeConstraints { (make) in
                make.right.equalTo(numberLabel.snp.left)
                make.centerY.equalTo(numberLabel)
            }
            unitLabel.snp.makeConstraints { (make) in
                make.left.equalTo(numberLabel.snp.right)
                make.bottom.equalTo(numberLabel)
            }
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = width / 2
        }
    }
    
    
}



