//
//  CalculateView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

enum TrainerCourseCalculateType: Int {
    case plus, minus, manualInput
}

class CalculateView: BaseView {
    
    let plusButton = BaseButton()
    let minusButton = BaseButton()
    let labelButton = BaseButton()
    var click: ((TrainerCourseCalculateType)->())?
    var times: Int! {
        didSet {
            labelButton.setTitle(String(times), for: .normal)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(labelButton)
        plusButton.setBackgroundImage(UIImage.init(named: "plus"), for: .normal)
        minusButton.setBackgroundImage(UIImage.init(named: "minus"), for: .normal)
        labelButton.setTitleColor(UIColor.hx129faa, for: .normal)
        labelButton.titleLabel?.font = UIFont.bold20
        labelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        labelButton.setTitle("-", for: .normal)
        labelButton.setBackgroundImage(UIImage.init(named: "calculate"), for: .normal)
        plusButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
        }
        labelButton.snp.makeConstraints { (make) in
            make.right.equalTo(plusButton.snp.left).offset(-5)
            make.top.bottom.equalTo(self)
        }
        minusButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(labelButton.snp.left).offset(-5)
        }
        plusButton.rx.tap.bind { [unowned self] in
            self.click?(.plus)
            }.disposed(by: disposeBag)
        
        labelButton.rx.tap.bind { [unowned self] in
            self.click?(.manualInput)
            }.disposed(by: disposeBag)
        
        minusButton.rx.tap.bind { [unowned self] in
            self.click?(.minus)
            }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
