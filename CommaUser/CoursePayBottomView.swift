//
//  CoursePayBottomView.swift
//  CommaUser
//
//  Created by macbook on 2018/10/22.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CoursePayBottomView: BaseView {

    let payBtn = BaseButton()
    let subscibeBtn = BaseButton()
    var payclick: EmptyClosure?
    var subscibeclick: EmptyClosure?

    override func customizeInterface() {
        clipsToBounds = false
        backgroundColor = UIColor.white
        addSubview(payBtn)
        addSubview(subscibeBtn)

        payBtn.clipsToBounds = true
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.titleLabel?.font = UIFont.appFontOfSize(15)
        payBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        payBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx91b6b9), for: .disabled)
        payBtn.layer.cornerRadius = 5
        payBtn.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSizeMake(110, 40))
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self.snp.centerX).offset(-25/2)
          make.height.equalTo(40)
            make.centerY.equalTo(self)
        }
        
        if Layout.is_ge_window_5_8_inch {
            payBtn.snp.remakeConstraints { (make) in
                //            make.size.equalTo(CGSizeMake(110, 40))
                make.left.equalTo(self).offset(15)
                make.right.equalTo(self.snp.centerX).offset(-25/2)
                make.height.equalTo(40)
                make.top.equalTo(self).offset(15)
            }
        }
        payBtn.rx.tap.bind { [unowned self] in
            self.payclick?()
            }.disposed(by: disposeBag)
        
        subscibeBtn.clipsToBounds = true
        subscibeBtn.setTitleColor(UIColor.white, for: .normal)
        subscibeBtn.titleLabel?.font = UIFont.appFontOfSize(15)
        subscibeBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx129faa), for: .normal)
        subscibeBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx91b6b9), for: .disabled)
        subscibeBtn.layer.cornerRadius = 5
        subscibeBtn.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSizeMake(110, 40))
            make.right.equalTo(self).offset(-15)
            make.left.equalTo(self.snp.centerX).offset(25/2)
            make.height.equalTo(40)
            make.centerY.equalTo(self)
        }
        
        if Layout.is_ge_window_5_8_inch {
            subscibeBtn.snp.makeConstraints { (make) in
                //            make.size.equalTo(CGSizeMake(110, 40))
                make.right.equalTo(self).offset(-15)
                make.left.equalTo(self.snp.centerX).offset(25/2)
                make.height.equalTo(40)
                make.top.equalTo(self).offset(15)
            }
        }
        subscibeBtn.rx.tap.bind { [unowned self] in
            self.subscibeclick?()
            }.disposed(by: disposeBag)
        
        let view = UIImageView()
        view.image = DefaultTabbarShadowImage
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.top)
            make.left.right.equalTo(self)
        }
        payBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        payBtn.layer.borderWidth = 1
        payBtn.layer.borderColor = UIColor.hx129faa.cgColor
        
        payBtn.setTitle("购买课程", for: .normal)
        subscibeBtn.setTitle("预约课程", for: .normal)

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
