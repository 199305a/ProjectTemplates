//
//  BandUpdateProgressView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/6/5.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BandUpdateProgressView: BaseView {
    
    static var shared: BandUpdateProgressView?
    static var clickCompletion: EmptyClosure? // shared点击事件
    
    // 实例方法部分
    let trackLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    let progressLabel = BaseLabel()
    let updateLabel = BaseLabel()
    let lineWidth: CGFloat = 4
    var trackColor = UIColor.hxd6d7d8 {
        didSet{
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            if progress > 1 {
                progress = 1
            } else if progress < 0 {
                progress = 0
            }
            progressLabel.text = String(Int(progress * 100)) + "%"
            updateLabel.text = progress == 1 ? "更新完成" : "更新中"
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            maskLayer.strokeEnd = progress
            CATransaction.commit()
        }
    }
    
    var click: EmptyClosure?
    var isAnimating = false
    
    override func customizeInterface() {
        super.customizeInterface()
        let whiteView = UIView()
        addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(60))
        }
        whiteView.backgroundColor = UIColor.white
        whiteView.layer.cornerRadius = 30
        
        updateLabel.text = "更新中"
        updateLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.boldAppFontOfSize(10))
        addSubview(updateLabel)
        updateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(22)
            make.centerX.equalTo(self)
        }
        
        progressLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.bold13)
        addSubview(progressLabel)
        progressLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-22)
        }
        
        clipsToBounds = false
        let path = UIBezierPath.init(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (bounds.width - lineWidth) / 2, startAngle: -CGFloat.pi / 2, endAngle:  CGFloat.pi * 1.5, clockwise: true)
        
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        maskLayer.lineWidth = lineWidth
        maskLayer.lineCap = kCALineCapRound
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.hxd6d7d8.cgColor
        maskLayer.path = path.cgPath
        maskLayer.shadowOpacity = 0.1
        maskLayer.shadowColor = UIColor.white.cgColor
        maskLayer.shadowOffset = CGSizeMake(0)
        
        gradientLayer.frame = bounds
        let firstColor = UIColor.hexColor(0x6078ea)
        let endColor = UIColor.hexColor(0x30e0d2)
        gradientLayer.colors = [firstColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
        
        progress = 0
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        tap.rx.event.bind { [unowned self] (_) in
            if self.isAnimating {
                return
            }
            self.click?()
            }.disposed(by: disposeBag)
    }
    
    
    
    @discardableResult
    func show(completion: EmptyClosure? = nil) -> BandUpdateProgressView {
        
        isAnimating = true
        
        let this = self
        this.removeFromSuperview()
        APP.window?.addSubview(this)
        let superview = this.superview!
        
        let path = UIBezierPath()
        path.move(to: superview.center)
        path.addLine(to: superview.center)
        path.addLine(to: this.center)
        let anim1 = CAKeyframeAnimation()
        anim1.keyPath = "position"
        anim1.duration = 1
        anim1.path = path.cgPath
        anim1.isRemovedOnCompletion = false
        anim1.fillMode = kCAFillModeForwards
        
        let anim2 = CAKeyframeAnimation()
        anim2.keyPath = "transform.scale"
        anim2.values = [0, 0.2]
        anim2.keyTimes = [0, 1]
        anim2.calculationMode = kCAAnimationLinear
        anim2.duration = 0.2
        anim2.isRemovedOnCompletion = false
        anim2.fillMode = kCAFillModeForwards
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.duration = 1
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        
        this.layer.add(group, forKey: nil)
        
        GlobalAction.delayPerformOnMainQueue(1) {
            let anim = CAKeyframeAnimation()
            anim.keyPath = "transform.scale"
            anim.values = [0.2, 1.15, 1]
            anim.keyTimes = [0, 0.8, 1]
            anim.duration = 0.5
            anim.isRemovedOnCompletion = false
            anim.fillMode = kCAFillModeForwards
            anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            this.layer.add(anim, forKey: nil)
            GlobalAction.delayPerformOnMainQueue(0.5) {
                self.isAnimating = false
                completion?()
            }
        }
        
        return this
    }
    
    func dismiss(completion: EmptyClosure? = nil) {
        
        isAnimating = true
        
        guard let superview = self.superview else {
            isAnimating = false
            completion?()
            return
        }
        
        let this = self
        let anim: CAAnimation
        
        if this.progress == 1 {
            let anim1 = CAKeyframeAnimation()
            anim1.keyPath = "transform.scale"
            anim1.values = [1, 1.15, 0]
            anim1.keyTimes = [0, 0.8, 1]
            anim1.duration = 0.5
            anim1.isRemovedOnCompletion = false
            anim1.fillMode = kCAFillModeForwards
            anim1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            anim = anim1
        } else {
            
            let path = UIBezierPath()
            path.move(to: this.center)
            path.addLine(to: this.center)
            path.addLine(to: superview.center)
            let anim1 = CAKeyframeAnimation()
            anim1.keyPath = "position"
            anim1.duration = 0.5
            anim1.path = path.cgPath
            anim1.isRemovedOnCompletion = false
            anim1.fillMode = kCAFillModeForwards
            
            let anim2 = CAKeyframeAnimation()
            anim2.keyPath = "transform.scale"
            anim2.values = [1, 0]
            anim2.keyTimes = [0, 1]
            anim2.duration = 0.6
            anim2.isRemovedOnCompletion = false
            anim2.fillMode = kCAFillModeForwards
            anim2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = 0.6
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeForwards
            group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            anim = group
        }
        
        this.layer.add(anim, forKey: nil)
        
        GlobalAction.delayPerformOnMainQueue(0.6) {
            this.removeFromSuperview()
            self.isAnimating = false
            completion?()
        }
    }
    
    
}

extension BandUpdateProgressView {
    
    // 是否正在展示
    static var isShow: Bool {
        return shared?.superview != nil
    }
    
    
    // 进度
    static var progress: CGFloat {
        set {
            shared?.progress = newValue
        }
        
        get {
            return shared?.progress ?? 0
        }
    }
    
    
    // shared展示
    @discardableResult
    static func show(completion: EmptyClosure? = nil) -> BandUpdateProgressView {
        if shared == nil {
            let width: CGFloat = 76
            shared = BandUpdateProgressView.init(frame: CGRectMake(Layout.ScreenWidth - 32 - width, Layout.ScreenHeight - 97 - width, width, width))
            shared?.click = {
                dismiss{
                    clickCompletion?()
                }
                
            }
        }
        
        return shared!.show(completion: completion)
    }
    
    static func dismiss(completion: EmptyClosure? = nil) {
        shared?.dismiss {
            shared?.removeFromSuperview()
            completion?()
            clickCompletion = nil
        }
    }
    
    static func clear() {
        shared = nil
    }
}
