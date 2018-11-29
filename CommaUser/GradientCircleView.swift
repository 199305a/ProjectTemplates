//
//  GradientCircleView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class GradientCircleView: BaseView {
    
    let trackLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    let amountLabel = BaseLabel()
    let lineWidth: CGFloat = 10
    var trackColor = UIColor.backgroundColor {
        didSet{
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    var progress: CGFloat = 0 {
        didSet {
            amountLabel.text = String(Int(progress * 100))
            if progress > 1 {
                progress = 1
            } else if progress < 0 {
                progress = 0
            }
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            maskLayer.strokeEnd = progress
            CATransaction.commit()
        }
    }
    
    
    override func customizeInterface() {
        super.customizeInterface()
        
        amountLabel.font = UIFont.init(name: Text.Impact, size: 44)
        amountLabel.textColor = UIColor.hx34c86c
        addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        clipsToBounds = false
        let path = UIBezierPath.init(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (bounds.width - lineWidth) / 2, startAngle: floatPI((.pi / 2) + (.pi / 4) + (.pi / 4) / 3), endAngle:  floatPI((.pi / 4) - (.pi / 4) / 3), clockwise: true)
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        maskLayer.lineWidth = lineWidth
        maskLayer.lineCap = kCALineCapRound
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.backgroundColor.cgColor
        maskLayer.path = path.cgPath
        maskLayer.shadowOpacity = 0.1
        maskLayer.shadowColor = UIColor.white.cgColor
        maskLayer.shadowOffset = CGSizeMake(0)
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.hx34c86c.cgColor,UIColor.mixColor(UIColor.hx34c86c, otherColor: UIColor.hx00ade6, ratio: 0.5).withAlphaComponent(0.8).cgColor, UIColor.hx00ade6.withAlphaComponent(0.9).cgColor]
        gradientLayer.locations = [0.3, 0.6, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0)
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
        
        progress = 0
    }
    
    func floatPI(_ pi: Double) -> CGFloat {
        return CGFloat(pi)
    }
}
