//
//  BraceletInfoHeadView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/23.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class BraceletInfoHeadView: BaseView {

    var progress: Float = 0 {
        didSet{
            progressV.progress = progress
            electricityLabel.text = String(progress * 100) + "%"
        }
    }
    
    var isEnable: Bool = false {
        didSet {
            titleLabel.textColor = isEnable ? UIColor.white : UIColor.white.withAlphaComponent(0.6)
            electricityLabel.textColor = titleLabel.textColor
            titleLabel.text = "COMMA BAND"
        }
    }
    
    let bg = BaseImageView(image: UIImage(named: "my-bracelet-head-bg"))
    let titleLabel = BaseLabel()
    let progressV = ProgressView()
    let arrow = BaseImageView(image: UIImage(named: "arrow-right-white"))
    let electricityDescLabel = BaseLabel()
    let electricityLabel = BaseLabel()
    
    var clickClosure: EmptyClosure?
    
    init() {
        super.init(frame: .zero)
        bg.contentMode = .scaleAspectFill
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.DINProBoldFontOf(size: 20)
        
        electricityDescLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        electricityDescLabel.font = UIFont.boldAppFontOfSize(15)
        electricityDescLabel.text = Text.LeftElectricity + "："
        electricityLabel.textColor = UIColor.white
        electricityLabel.font = UIFont.boldAppFontOfSize(15)
        electricityLabel.text = "-"
        
        addSubview(bg)
        addSubview(titleLabel)
        addSubview(arrow)
        addSubview(progressV)
        addSubview(electricityDescLabel)
        addSubview(electricityLabel)
        bg.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.height.equalTo(120)
            make.bottom.right.equalTo(-15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bg).offset(15)
            make.top.equalTo(bg).offset(30)
        }
        progressV.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(6)
            make.right.equalTo(electricityDescLabel.snp.left).offset(-30.layout)
        }
        arrow.snp.makeConstraints { (make) in
            make.right.equalTo(bg).offset(-15)
            make.centerY.equalTo(titleLabel)
        }
        electricityLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrow)
            make.centerY.equalTo(progressV)
        }
        electricityDescLabel.snp.makeConstraints { (make) in
            make.right.equalTo(electricityLabel.snp.left)
            make.centerY.equalTo(electricityLabel)
        }
        
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind { [unowned self] (_) in
            self.clickClosure?()
        }.disposed(by: disposeBag)
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class ProgressView: BaseView {
        
        var progress: Float = 0 {
            didSet{
                indicator.snp.remakeConstraints { (make) in
                    make.left.top.bottom.equalTo(self)
                    make.width.equalTo(snp.width).multipliedBy(progress)
                }
            }
        }
        
        let indicator = BaseView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(indicator)
            backgroundColor = UIColor.white.withAlphaComponent(0.2652)
            layer.cornerRadius = 3
            layer.masksToBounds = true
            indicator.backgroundColor = UIColor.white
            indicator.layer.cornerRadius = 3
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
