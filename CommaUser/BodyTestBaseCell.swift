//
//  BodyTestBaseCell.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BodyTestBaseCell: BaseTableViewCell {
    
    let historyBtn = BaseButton()
    var click: EmptyClosure?
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 6
        containerView.layer.shadowColor = UIColor.hx129faa.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 12
        containerView.layer.shadowOffset = CGSizeMake(0, 3)
        containerView.clipsToBounds = false
        titleLabel = BaseLabel()
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.bold20
        historyBtn.setImage(UIImage(named: "history"), for: .normal) 
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(historyBtn)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(7.5, 15, 7.5, 15))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(containerView)
        }
        historyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize.init(width: 46, height: 46))
        }
        
        historyBtn.rx.tap.bind { [unowned self] in
            self.click?()
        }.disposed(by: disposeBag)
    }
}

extension UIView {
    func shadowLarge() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.hx129faa.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 12
        layer.shadowOffset = CGSizeMake(0, 3)
        clipsToBounds = false
    }
}
