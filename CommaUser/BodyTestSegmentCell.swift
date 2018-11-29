//
//  BodyTestSegmentCell.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BodyTestSegmentCell: BodyTestBaseCell {
    
    var segmentResult: SegmentalModel! {
        didSet{
            if segmentResult == nil { return }
            titleLabel.text = segmentResult.title
            guard let items = segmentResult.body_data, items.count >= 5 else {
                return
            }
            ltView.item = items[0]
            rtView.item = items[1]
            lbView.item = items[2]
            rbView.item = items[3]
            centerTitleLabel.text = items[4].chinese_name
            numberLabel.text = items[4].value
            unitLabel.text = items[4].unit
        }
    }
    
    var isShowResult = true {
        didSet {
            if isShowResult {
                rbView.snp.remakeConstraints { (make) in
                    make.left.equalTo(lbView.snp.right).offset(15)
                    make.centerY.equalTo(lbView)
                    make.size.equalTo(ltView)
                }
                containerView.addSubview(resultView)
                resultView.snp.makeConstraints { (make) in
                    make.top.equalTo(lbView.snp.bottom).offset(30)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.bottom.equalTo(-30)
                }
            } else {
                rbView.snp.remakeConstraints { (make) in
                    make.left.equalTo(lbView.snp.right).offset(15)
                    make.centerY.equalTo(lbView)
                    make.size.equalTo(ltView)
                    make.bottom.equalTo(-30)
                }
                resultView.removeFromSuperview()
            }
        }
    }

    let ltView = ItemView(direction: .leftTop)
    let rtView = ItemView(direction: .rightTop)
    let lbView = ItemView(direction: .leftBottom)
    let rbView = ItemView(direction: .rightBottom)
    let centerView = BaseView()
    let centerTitleLabel = BaseLabel()
    let unitLabel = BaseLabel()
    let numberLabel = BaseLabel()
    let resultView = BodyTestResultView()
    
    override func customizeInterface() {
        super.customizeInterface()
                
        centerTitleLabel.textColor = UIColor.hx5c5e6b
        centerTitleLabel.font = UIFont.appFontOfSize(20)
        numberLabel.textColor = UIColor.hx129faa
        numberLabel.font = UIFont.DINProBoldFontOf(size: Layout.is_window_4_inch ? 25 : 40)
        unitLabel.textColor = UIColor.hx129faa
        unitLabel.font = UIFont.DINProBoldFontOf(size: Layout.is_window_4_inch ? 12 : 20)
        containerView.addSubview(ltView)
        containerView.addSubview(rtView)
        containerView.addSubview(lbView)
        containerView.addSubview(rbView)
        containerView.addSubview(centerView)
        containerView.addSubview(resultView)
        centerView.addSubview(centerTitleLabel)
        centerView.addSubview(numberLabel)
        centerView.addSubview(unitLabel)
        centerView.shadowLarge()
        
        
        ltView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.left.equalTo(20)
            make.right.equalTo(containerView.snp.centerX).offset(-7.5)
            make.height.equalTo(ltView.snp.width)
        }
        rtView.snp.makeConstraints { (make) in
            make.left.equalTo(ltView.snp.right).offset(15)
            make.size.equalTo(ltView)
            make.centerY.equalTo(ltView)
        }
        lbView.snp.makeConstraints { (make) in
            make.left.equalTo(ltView)
            make.top.equalTo(ltView.snp.bottom).offset(15)
            make.size.equalTo(ltView)
        }
        rbView.snp.makeConstraints { (make) in
            make.left.equalTo(lbView.snp.right).offset(15)
            make.centerY.equalTo(lbView)
            make.size.equalTo(ltView)
        }
        centerView.snp.makeConstraints { (make) in
            make.top.equalTo(ltView.snp.centerY).offset(-15.layout)
            make.left.equalTo(ltView.snp.centerX).offset(-15.layout)
            make.bottom.equalTo(rbView.snp.centerY).offset(15.layout)
            make.right.equalTo(rbView.snp.centerX).offset(15.layout)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(centerView.snp.centerY).offset(1.5)
            make.centerX.equalTo(centerView)
        }
        unitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numberLabel.snp.right)
            make.bottom.equalTo(numberLabel)
        }
        centerTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(centerView)
            make.bottom.equalTo(numberLabel.snp.top).offset(-1.5)
        }
//        resultView.snp.makeConstraints { (make) in
//            make.top.equalTo(lbView.snp.bottom).offset(30)
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.bottom.equalTo(-30)
//        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerView.layer.cornerRadius = centerView.width / 2
    }

    class ItemView: BaseView {
        
        var item: SegmentalDataModel! {
            didSet{
                titleLabel.text = item.chinese_name
                numberLabel.text = item.value
                unitLabel.text = item.unit
                levelLabel.text = item.evaluate
            }
        }
        
        let titleLabel = BaseLabel()
        let numberLabel = BaseLabel()
        let levelLabel = BaseLabel()
        let unitLabel = BaseLabel()
        
        var direction: Direction = .leftTop
        
        init(direction: Direction) {
            super.init(frame: .zero)
            self.direction = direction
            shadowLarge()
            titleLabel.textColor = UIColor.hx9b9b9b
            titleLabel.font = UIFont.appFontOfSize(12)
            numberLabel.textColor = UIColor.hx129faa
            numberLabel.font = UIFont.DINProBoldFontOf(size: 20)
            unitLabel.textColor = UIColor.hx129faa
            unitLabel.font = UIFont.DINProBoldFontOf(size: 15)
            unitLabel.text = "Kg"
            levelLabel.textColor = UIColor.hx5c5e6b
            levelLabel.font = UIFont.appFontOfSize(12)
            
            addSubview(titleLabel)
            addSubview(numberLabel)
            addSubview(unitLabel)
            addSubview(levelLabel)
            
            setUpConstraints()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUpConstraints() {
            switch direction {
            case .leftTop:
                titleLabel.snp.makeConstraints { (make) in
                    make.left.top.equalTo(Layout.is_window_4_inch ? 15 : 20)
                }
                numberLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(titleLabel)
                    make.top.equalTo(titleLabel.snp.bottom).offset(2)
                }
                unitLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(numberLabel.snp.right)
                    make.bottom.equalTo(numberLabel)
                }
                levelLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(numberLabel.snp.bottom).offset(2)
                    make.left.equalTo(numberLabel)
                }
            case .rightTop:
                titleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(Layout.is_window_4_inch ? 15 : 20)
                    make.right.equalTo(Layout.is_window_4_inch ? -15 : -20)
                }
                unitLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(titleLabel)
                    make.bottom.equalTo(numberLabel)
                }
                numberLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(unitLabel.snp.left)
                    make.top.equalTo(titleLabel.snp.bottom).offset(2)
                }
                levelLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(numberLabel.snp.bottom).offset(2)
                    make.right.equalTo(titleLabel)
                }
            case .leftBottom:
                titleLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(Layout.is_window_4_inch ? 15 : 20)
                    make.bottom.equalTo(Layout.is_window_4_inch ? -15 : -20)
                }
                numberLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(titleLabel)
                    make.bottom.equalTo(titleLabel.snp.top).offset(-2)
                }
                unitLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(numberLabel.snp.right)
                    make.bottom.equalTo(numberLabel)
                }
                levelLabel.snp.makeConstraints { (make) in
                    make.bottom.equalTo(numberLabel.snp.top).offset(-2)
                    make.left.equalTo(titleLabel)
                }
            case .rightBottom:
                titleLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(Layout.is_window_4_inch ? -15 : -20)
                    make.bottom.equalTo(Layout.is_window_4_inch ? -15 : -20)
                }
                unitLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(titleLabel)
                    make.bottom.equalTo(numberLabel)
                }
                numberLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(unitLabel.snp.left)
                    make.bottom.equalTo(titleLabel.snp.top).offset(-2)
                }
                levelLabel.snp.makeConstraints { (make) in
                    make.bottom.equalTo(numberLabel.snp.top).offset(-2)
                    make.right.equalTo(titleLabel)
                }
            }
        }
        
        enum Direction {
            case leftTop, rightTop, leftBottom, rightBottom
        }
    }
}
