//
//  CourseBottomView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/17.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CourseBottomView: BaseView {
    
    let contentLabel = BaseLabel()
    let detailLabel = BaseLabel()
    let button = BaseButton()
    var click: EmptyClosure?
    
    var canUse: Bool = true {
        didSet {
            let color = canUse ? UIColor.hx129faa : UIColor.hx91b6b9
            button.setBackgroundImage(UIImage.imageWithColor(color), for: .normal)
        }
    }
    
    override func customizeInterface() {
        clipsToBounds = false
        backgroundColor = UIColor.white
        addSubview(contentLabel)
        addSubview(detailLabel)
        addSubview(button)
        
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.appFontOfSize(15)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.hx129faa), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.hx91b6b9), for: .disabled)
        button.layer.cornerRadius = 5
        button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(110, 40))
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
        }
        if Layout.is_ge_window_5_8_inch {
            button.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSizeMake(110, 40))
                make.right.equalTo(self).offset(-15)
                make.top.equalTo(self).offset(15)
            }
        }
        button.rx.tap.bind { [unowned self] in
            self.click?()
            }.disposed(by: disposeBag)
        
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.DINProBoldFontOf(size: 20))
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
            make.right.lessThanOrEqualTo(button.snp.left).offset(-10)
        }
        
        if Layout.is_ge_window_5_8_inch {
            contentLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(button)
                make.left.equalTo(self).offset(15)
                make.right.lessThanOrEqualTo(button.snp.left).offset(-10)
            }
        }
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.appFontOfSize(12))
        detailLabel.snp.makeConstraints { (make) in
            make.lastBaseline.equalTo(contentLabel)
            make.right.lessThanOrEqualTo(button.snp.left).offset(-10)
            make.left.equalTo(contentLabel.snp.right).offset(8)
        }
        let view = UIImageView()
        view.image = DefaultTabbarShadowImage
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.top)
            make.left.right.equalTo(self)
        }
        
    }
    
}
