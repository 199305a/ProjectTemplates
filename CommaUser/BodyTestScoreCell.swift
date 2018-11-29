//
//  BodyTestScoreCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BodyTestScoreCell: BodyTestBaseCell {
    
    var testScore: TestScoreModel! {
        didSet{
            if testScore == nil { return }
            titleLabel.text = testScore.title
            scoreLabel.text = testScore.score
            shapeLayer.strokeEnd = progress
        }
    }
    
    var correctScore: CGFloat {
        return CGFloat(min(max(testScore.score.intValue ?? 0, 0), 100))
    }
    var progress: CGFloat {
        return correctScore / 100
    }
    
    let outerCircleDiameter: CGFloat = 120
    let scoreLabel = BaseLabel()
    let shapeLayer = CAShapeLayer()
    let outerCircleV = UIView()
    
    override func customizeInterface() {
        super.customizeInterface()
        historyBtn.isHidden = true
        scoreLabel.textColor = UIColor.hx129faa
        scoreLabel.font = UIFont.DINProBoldFontOf(size: 50)
        
        outerCircleV.backgroundColor = UIColor.clear
        outerCircleV.layer.borderColor = UIColor.hxc1c3c8.withAlphaComponent(0.2).cgColor
        outerCircleV.layer.borderWidth = 2
        outerCircleV.layer.cornerRadius = outerCircleDiameter / 2
        let innerCircleV = UIView()
        innerCircleV.backgroundColor = UIColor.clear
        innerCircleV.layer.borderColor = UIColor.backgroundColor.cgColor
        innerCircleV.layer.borderWidth = 3
        innerCircleV.layer.cornerRadius = outerCircleDiameter / 2 - 2
        
        containerView.addSubview(outerCircleV)
        containerView.addSubview(innerCircleV)
        containerView.addSubview(scoreLabel)
        outerCircleV.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.size.equalTo(CGSize.init(width: outerCircleDiameter, height: outerCircleDiameter))
            make.bottom.equalTo(-30)
        }
        innerCircleV.snp.makeConstraints { (make) in
            make.center.equalTo(outerCircleV)
            make.width.equalTo(outerCircleV.snp.width).offset(-3)
            make.height.equalTo(outerCircleV.snp.height).offset(-3)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.center.equalTo(outerCircleV)
        }
        
        shapeLayer.frame = CGRectMake(1, 1, outerCircleDiameter-1, outerCircleDiameter-1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.hx129faa.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = kCALineCapRound
        let path = UIBezierPath.init(roundedRect: CGRectMake(0, 0, outerCircleDiameter-1, outerCircleDiameter-1), cornerRadius: outerCircleDiameter)
        shapeLayer.path = path.cgPath
        outerCircleV.layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.position = outerCircleV.center
        shapeLayer.frame = CGRectMake(1, 1, outerCircleDiameter-1, outerCircleDiameter-1)
    }
}
