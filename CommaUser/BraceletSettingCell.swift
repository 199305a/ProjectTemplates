//
//  BraceletSettingView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/19.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class BraceletSettingCell: BaseTableViewCell {

    var changeSwitchState: BoolClosure?
    let switchControl = UISwitch()
    
    var isEnable: Bool = false {
        didSet{
            switchControl.isEnabled = isEnable
            titleLabel.textColor = isEnable ? UIColor.hx5c5e6b : UIColor.hx9b9b9b
        }
    }
    
    override func customizeInterface() {
        titleLabel = BaseLabel()
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.boldAppFontOfSize(15)
        switchControl.thumbTintColor = UIColor.white
        switchControl.onTintColor = UIColor.hx129faa
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchControl)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(20)
            make.top.equalTo(25)
            make.bottom.equalTo(-25)
        }
        switchControl.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(-15)
        }

        switchControl.rx.isOn.bind { (isOn) in
            self.changeSwitchState?(isOn)
        }.disposed(by: disposeBag)
        
    }
}
