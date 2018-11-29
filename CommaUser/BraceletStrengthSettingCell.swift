//
//  BraceletStrengthSettingCell.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/19.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BraceletStrengthSettingCell: BaseTableViewCell {

    var currentLevel = VibrationStrengthLevel.middle
    let strengthLowBtn = BaseButton()
    let strengthMiddleBtn = BaseButton()
    let strengthHighBtn = BaseButton()
    var highlightBtn: BaseButton!
    var changeLevelClosure: ((BraceletManager.VibrationStrengthLevel)->())?
    var strengthLevel: BraceletManager.VibrationStrengthLevel = .middle {
        didSet{
            switch strengthLevel {
            case .low:
                selectBtn(strengthLowBtn)
            case .middle:
                selectBtn(strengthMiddleBtn)
            case .high:
                selectBtn(strengthHighBtn)
            }
        }
    }
    
    var isEnable: Bool = false {
        didSet{
            strengthLowBtn.isEnabled = isEnable
            strengthMiddleBtn.isEnabled = isEnable
            strengthHighBtn.isEnabled = isEnable
            titleLabel.textColor = isEnable ? UIColor.hx5c5e6b : UIColor.hx9b9b9b
        }
    }
    
    override func customizeInterface() {
        titleLabel = BaseLabel()
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.boldAppFontOfSize(15)
        strengthLowBtn.setImage(UIImage.init(named: "strength-low-normal"), for: .normal)
        strengthLowBtn.setImage(UIImage.init(named: "strength-low-select"), for: .selected)
        strengthMiddleBtn.setImage(UIImage.init(named: "strength-middle-normal"), for: .normal)
        strengthMiddleBtn.setImage(UIImage.init(named: "strength-middle-select"), for: .selected)
        strengthHighBtn.setImage(UIImage.init(named: "strength-high-normal"), for: .normal)
        strengthHighBtn.setImage(UIImage.init(named: "strength-high-select"), for: .selected)
        highlightBtn = strengthMiddleBtn
        strengthMiddleBtn.isSelected = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(strengthLowBtn)
        contentView.addSubview(strengthMiddleBtn)
        contentView.addSubview(strengthHighBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(20)
        }
        strengthHighBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalTo(contentView)
        }
        strengthMiddleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(strengthHighBtn.snp.left).offset(0)
            make.centerY.equalTo(strengthHighBtn)
        }
        strengthLowBtn.snp.makeConstraints { (make) in
            make.right.equalTo(strengthMiddleBtn.snp.left).offset(0)
            make.centerY.equalTo(strengthHighBtn)
        }
        
        strengthLowBtn.rx.tap.bind { [unowned self] in
            self.strengthLevel = .low
        }.disposed(by: disposeBag)
        
        strengthMiddleBtn.rx.tap.bind { [unowned self] in
            self.strengthLevel = .middle
            }.disposed(by: disposeBag)
        
        strengthHighBtn.rx.tap.bind { [unowned self] in
            self.strengthLevel = .high
        }.disposed(by: disposeBag)
    }
    
    func selectBtn(_ btn: BaseButton) {
        if btn.isSelected { return }
        highlightBtn.isSelected = false
        btn.isSelected = true
        highlightBtn = btn
        changeLevelClosure?(strengthLevel)
    }
    
    enum VibrationStrengthLevel: Int {
        case low, middle, high
    }
}
