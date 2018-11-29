//
//  BodyAnalyseCVCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BodyAnalyseCVCell: BaseCollectionViewCell {
    
    override var dataSource: AnyObject? {
        didSet {
            guard let model = dataSource as? BodyNavInfoModel else { return }
            title = model.chinese_name
        }
    }
    
    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            button.isSelected = isSelected
            shadowView.isHidden = !isSelected
        }
    }
    
    let button = BaseButton()
    let shadowView = UIView()
    
    override func customizeInterface() {
        super.customizeInterface()
        contentView.addSubview(shadowView)
        contentView.addSubview(button)
        let buttonHeight: CGFloat = 30
        button.titleLabel?.font = UIFont.appFontOfSize(13)
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor.hexColor(0x7c8289), for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        
        shadowView.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
            make.center.equalTo(contentView)
            make.left.right.equalTo(contentView)
        }
        
        button.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.left.equalTo(shadowView).offset(10)
            make.right.equalTo(shadowView).offset(-10)
        }
        
        shadowView.isHidden = true
        shadowView.backgroundColor = UIColor.hx129faa
        shadowView.layer.cornerRadius = buttonHeight / 2
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowColor = UIColor.lightGreenColor.cgColor
        shadowView.layer.shadowOpacity = 0.5
        
    }
}
