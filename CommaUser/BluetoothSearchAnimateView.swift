//
//  BluetoothSearchAnimateView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/18.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BluetoothSearchAnimateView: BaseView {
    
    let animateDuration = 1.5
    
    var clickBlock: ()->Void = {}
    
    //是否正在动画
    var isAnimate: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clear
        clipsToBounds = false
        
        let lanyaBgImg = UIImage.gradientImage(startColor: UIColor.white,
                                               endColor: UIColor.white,
                                               startPoint: CGPoint.init(x: bounds.width, y: 0),
                                               endPoint: CGPoint.init(x: 0, y: bounds.height),
                                               size: bounds.size)
        let lanyaBg = BaseImageView.init(image: lanyaBgImg)
        lanyaBg.layer.cornerRadius = bounds.width / 2
        lanyaBg.layer.masksToBounds = true
        addSubview(lanyaBg)
        lanyaBg.frame = bounds
        
        let lanya = BaseImageView(image: UIImage(named: "lanya"))
        lanya.contentMode = .center
        addSubview(lanya)
        lanya.frame = bounds
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        
    }
    
    var clikEnable = true
    @objc func click() {
        if !clikEnable { return }
        clickBlock()
        clikEnable = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animateDuration / 2) {
            self.clikEnable = true
        }
    }
    
    func animateStart() {
        animateStop()
        isAnimate = true
        let animLayer1 = AnimateLayer.init(frame: bounds,
                                           position: CGPoint(x: self.bounds.width/2.0, y: self.bounds.width/2.0))
        layer.addSublayer(animLayer1)
        animLayer1.animate(animateDuration)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animateDuration / 2) {
            if !self.isAnimate { return }
            let animLayer2 = AnimateLayer.init(frame: self.bounds,
                                               position: CGPoint(x: self.bounds.width/2.0, y: self.bounds.width/2.0))
            self.layer.addSublayer(animLayer2)
            animLayer2.animate(self.animateDuration)
        }
    }
    
    
    //MARK: - 动画完成外部方法
    func animateStop() {
        layer.sublayers?.forEach({ ($0 as? AnimateLayer)?.removeFromSuperlayer() })
        isAnimate = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    class AnimateLayer: CAShapeLayer {
        init(frame: CGRect, position: CGPoint) {
            super.init()
            self.frame = frame
            fillColor = UIColor.clear.cgColor
            path = UIBezierPath.init(ovalIn: bounds).cgPath
            lineWidth = 1.5
            strokeColor = UIColor.white.cgColor
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func animate(_ duration: TimeInterval) {
            let group = CAAnimationGroup()
            group.duration = duration
            group.repeatCount = Float.greatestFiniteMagnitude
            let scale = CABasicAnimation()
            scale.keyPath = "transform.scale"
            scale.fromValue = 1
            scale.toValue = 2
            let opacity = CABasicAnimation()
            opacity.keyPath = "opacity"
            opacity.fromValue = 1
            opacity.toValue = 0
            let width = CABasicAnimation()
            width.keyPath = "lineWidth"
            width.fromValue = 1.5
            width.toValue = 0.75
            group.animations = [scale,opacity,width]
            
            add(group, forKey: nil)
        }
    }
    
}

