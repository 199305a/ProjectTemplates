//
//  OpenDoorGoingView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/5/11.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class OpenDoorPromptView: ShadowAnimateView {

    let titleLabel = BaseLabel()
    let imageView = BaseImageView(image: UIImage.init(named: "door-guard-door"))
    let circleView = BaseView()
    let state: OpenDoorState
    let animLayer = CAShapeLayer()
    
    init(state: OpenDoorState) {
        self.state = state
        super.init()
        titleLabel.text = state.title
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.bold20
        imageView.image = state.image
        circleView.clipsToBounds = false
        
        contentV.addSubview(titleLabel)
        contentV.addSubview(circleView)
        contentV.addSubview(imageView)
        contentV.snp.remakeConstraints { (make) in
            make.center.equalTo(center)
            make.width.equalTo(295.layout)
        }
        circleView.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
            make.centerX.equalTo(contentV)
        }
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(circleView.snp.bottom).offset(20)
            make.bottom.equalTo(-42)
            make.centerX.equalTo(contentV)
        }
        
        animLayer.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        let path = UIBezierPath.init(ovalIn: animLayer.bounds)
        animLayer.path = path.cgPath
        animLayer.lineWidth = 2
        animLayer.fillColor = UIColor.clear.cgColor
        animLayer.strokeColor = UIColor.hx129faa.cgColor
        circleView.layer.addSublayer(animLayer)
        animLayer.zPosition = 1

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startOpenDoorAnimation() {
        
        let scale = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.fromValue = 0.7
        scale.toValue = 1.2
        
        let lineWidth = CABasicAnimation()
        lineWidth.keyPath = "lineWidth"
        lineWidth.fromValue = 2 * 1.2
        lineWidth.toValue = 2 * 0.7
        
        let group = CAAnimationGroup()
        group.duration = 0.8
        group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        group.repeatCount = Float.greatestFiniteMagnitude
        group.autoreverses = true
        group.animations = [scale, lineWidth]
        
        animLayer.add(group, forKey: nil)
    }
    
    enum OpenDoorState {
        case ongoing, success, failure
        
        var title: String {
            switch self {
            case .ongoing:
                return "开门中…"
            case .success:
                return "开门成功"
            case .failure:
                return "OOPS!"
            }
        }
        var image: UIImage {
            switch self {
            case .ongoing:
                return UIImage.init(named: "door-guard-door")!
            case .success:
                return UIImage.init(named: "door-guard-check")!
            case .failure:
                return UIImage.init(named: "door-guard-exclamation")!
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.state == .ongoing {
            self.startOpenDoorAnimation()
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        animLayer.removeAllAnimations()
    }
}

class OpenDoorFailPromptView: OpenDoorPromptView {
    
    var retryClosure: EmptyClosure?
    var errMsg: String? {
        didSet{
            detailLabel.text = errMsg
        }
    }
    
    let detailLabel = BaseLabel()
    let cancelBtn = BaseButton()
    let retryBtn = BaseButton()
    
    init(state: OpenDoorState, retry: EmptyClosure?) {
        super.init(state: state)
        detailLabel.textColor = UIColor.hx5c5e6b
        detailLabel.font = UIFont.bold15
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        
        cancelBtn.setTitle(Text.Cancel, for: .normal)
        cancelBtn.setTitleColor(UIColor.hx5c5e6b, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.bold20
        
        retryBtn.setTitle(Text.Retry, for: .normal)
        retryBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        retryBtn.titleLabel?.font = UIFont.bold20
        
        contentV.addSubview(detailLabel)
        contentV.addSubview(cancelBtn)
        contentV.addSubview(retryBtn)
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(circleView.snp.bottom).offset(20)
            make.centerX.equalTo(contentV)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerX.equalTo(titleLabel)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(14)
            make.right.equalTo(snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        retryBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cancelBtn.snp.right)
            make.centerY.width.height.equalTo(cancelBtn)
            make.bottom.equalTo(-26)
        }
        
        cancelBtn.rx.tap.bind { [unowned self] in
            self.dismiss()
        }.disposed(by: disposeBag)
        
        retryBtn.rx.tap.bind { [unowned self] in
            self.dismiss()
            self.retryClosure?()
        }.disposed(by: disposeBag)
        
        retryClosure = retry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView, msg: String) {
        super.show(in: view)
        errMsg = msg
    }
}
