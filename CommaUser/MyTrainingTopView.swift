//
//  MyTrainingTopView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/27.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class MyTrainingTopView: BaseView {
    
    var measureData: BraceletTraining! {
        didSet{
            if measureData == nil {
                return
            }
            stepView.topLabel.text = String(measureData._steps).commasString
            distanceView.topLabel.text = String.init(format: "%.2f",  Double(measureData._distance)/1000.0)
            calorieView.topLabel.text = String.init(format: "%.2f",  Double(measureData._calories)).commasString
        }
    }
    
    let backImageView = FillImageView()
    let contentView = UIView()
    let historyButton = RightImageButton()
    let todayDataLabel = BaseLabel()
    let todayDetailLabel = BaseLabel()
    let statusLabel = BaseLabel()
    let stepView = LabelView()
    let distanceView = LabelView()
    let calorieView = LabelView()
    let historyLabel = BaseLabel()
    let arrowImageView = UIImageView.init(image: UIImage.init(named: "white_arrow"))
    override func customizeInterface() {
        addSubview(backImageView)
        backImageView.image = UIImage.init(named: "training_background")
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(historyLabel)
        contentView.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(96)
            make.right.equalTo(contentView).offset(-20)
        }
        
        historyLabel.text = "历史数据"
        historyLabel.font = UIFont.bold15
        historyLabel.textColor = UIColor.white
        historyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(arrowImageView)
            make.right.equalTo(arrowImageView.snp.left).offset(-13)
        }
        
        contentView.addSubview(historyButton)
        historyButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(historyLabel).offset(-5)
            make.right.equalTo(arrowImageView).offset(5)
            make.bottom.equalTo(historyLabel).offset(5)
        }
        
        todayDataLabel.setUp(textColor: UIColor.white, font: UIFont.bold20)
        contentView.addSubview(todayDataLabel)
        todayDataLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(94)
        }
        
        todayDetailLabel.setUp(textColor: UIColor.white.withAlphaComponent(0.6), font: UIFont.bold12)
        contentView.addSubview(todayDetailLabel)
        todayDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(todayDataLabel)
            make.top.equalTo(todayDataLabel.snp.bottom).offset(2)
        }
        
        statusLabel.setUp(textColor: UIColor.white, font: UIFont.bold15)
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.lastBaseline.equalTo(todayDataLabel)
            make.left.equalTo(todayDataLabel.snp.right).offset(10)
        }
        
        todayDataLabel.text = "今日数据"
        todayDetailLabel.text = "数据来自COMMA BAND"
        statusLabel.text = "(手环未连接)"
        
        contentView.addSubview(stepView)
        contentView.addSubview(distanceView)
        contentView.addSubview(calorieView)
        distanceView.snp.makeConstraints { (make) in
            make.top.equalTo(todayDetailLabel.snp.bottom).offset(23)
            make.centerX.equalTo(self)
            make.width.equalTo((Layout.ScreenWidth - 50) / 3)
        }
        stepView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.width.top.equalTo(distanceView)
        }
        calorieView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.top.equalTo(distanceView)
        }
        
        stepView.bottomLabel.text = "步数(Steps)"
        distanceView.bottomLabel.text = "距离(Km)"
        calorieView.bottomLabel.text = "热量(Kcal)"
        
        reset()
    }
    
    func reset() {
        measureData = nil
        stepView.topLabel.text = "-"
        distanceView.topLabel.text = "-"
        calorieView.topLabel.text = "-"
    }
    
    class LabelView: UIView {
        
        let topLabel = BaseLabel()
        let bottomLabel = BaseLabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(topLabel)
            addSubview(bottomLabel)
            topLabel.setUp(textColor: UIColor.white, font: UIFont.DINProBoldFontOf(size: 30))
            bottomLabel.setUp(textColor: UIColor.white.withAlphaComponent(0.6), font: UIFont.boldAppFontOfSize(12))
            topLabel.adjustsFontSizeToFitWidth = true
            bottomLabel.adjustsFontSizeToFitWidth = true
            topLabel.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(self)
            }
            bottomLabel.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(self)
                make.top.equalTo(topLabel.snp.bottom).offset(3)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

