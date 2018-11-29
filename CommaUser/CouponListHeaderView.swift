//
//  CouponListHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class CouponListHeaderView: BaseView {
    
    let button = BaseButton()
    let textfield = UITextField()
    var buttonClick: EmptyClosure?
    
    override func customizeInterface() {
        clipsToBounds = false
        shadow(with: UIColor.black.withAlphaComponent(0.06), offset: CGSizeMake(0, 2))
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(button)
        button.setTitle(Text.Exchange, for: .normal)
        button.setTitleColor(UIColor.hx129faa, for: .normal)
        button.titleLabel?.font = UIFont.bold15
        button.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(11)
            make.right.equalTo(contentView)
            make.size.equalTo(CGSizeMake(70, 35))
        }
        
        button.rx.tap.bind { [unowned self] in
            self.buttonClick?()
            }.disposed(by: disposeBag)
        
        let tfBg = BaseView()
        tfBg.backgroundColor = UIColor.hxc1c3c8.withAlphaComponent(0.18)
        tfBg.layer.cornerRadius = 4
        contentView.addSubview(tfBg)
        textfield.backgroundColor = UIColor.clear
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing

        textfield.attributedPlaceholder = NSAttributedString.init(string: Text.InputCouponCode, attributes: [.foregroundColor: UIColor.hx9b9b9b, .font: UIFont.bold15])
        textfield.tintColor = UIColor.hx129faa
        tfBg.addSubview(textfield)
        tfBg.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(11)
            make.left.equalTo(contentView).offset(15)
            make.height.equalTo(35)
            make.right.equalTo(button.snp.left)
        }
        textfield.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalTo(tfBg)
        }
        
    }
    
}
