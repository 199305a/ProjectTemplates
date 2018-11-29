//
//  SearchSuccessView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/18.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class SearchSuccessView: BaseView {

    let contentV = BaseView()
    let bindBtn = BaseButton()
    let cancelBtn = BaseButton()
    let titleLabel = BaseLabel()
    let imageView = BaseImageView(image: UIImage.init(named: "bracelet-160"))
    let detailLabel = BaseLabel()
    var bindClosure: EmptyClosure?
    let indicatorV = UIActivityIndicatorView()
    var sureUnbindClosure: (()->Void)?
    
    var isBinding = false {
        didSet{
            isBinding ? indicatorV.startAnimating() : indicatorV.stopAnimating()
            bindBtn.isHidden = isBinding
            cancelBtn.isHidden = isBinding
        }
    }
    
    init() {
        super.init(frame: ScreenBounds)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView) {
        frame = UIScreen.main.bounds
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(self)
        animate(isShow: true)
    }
    
    func commonInit() {
        frame = UIScreen.main.bounds
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentV.backgroundColor = UIColor.white
        contentV.layer.cornerRadius = 6
        contentV.layer.masksToBounds = true
        titleLabel.textColor = UIColor.hx9b9b9b
        titleLabel.font = UIFont.boldAppFontOfSize(20)
        titleLabel.text = Text.HasSearchDevice
        imageView.contentMode = .center
        detailLabel.textColor = UIColor.hx5c5e6b
        detailLabel.font = UIFont.appFontOfSize(15)
        detailLabel.textAlignment = .center
        cancelBtn.setTitle(Text.DelayDecide, for: .normal)
        cancelBtn.setTitleColor(UIColor.hx5c5e6b, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.boldAppFontOfSize(20)
        cancelBtn.contentEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        bindBtn.setTitle(Text.BindNow, for: .normal)
        bindBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        bindBtn.titleLabel?.font = UIFont.boldAppFontOfSize(20)
        bindBtn.contentEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        indicatorV.activityIndicatorViewStyle = .gray
        indicatorV.hidesWhenStopped = true
        
        addSubview(contentV)
        contentV.addSubview(titleLabel)
        contentV.addSubview(imageView)
        contentV.addSubview(detailLabel)
        contentV.addSubview(cancelBtn)
        contentV.addSubview(bindBtn)
        contentV.addSubview(indicatorV)
        contentV.snp.makeConstraints { (make) in
            make.top.equalTo((105 + Layout.safeAreaInsetsTop).layout)
            make.centerX.equalTo(self)
            make.width.equalTo(345.layout)
            make.height.equalTo(390)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentV)
            make.top.equalTo(29)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(33)
            make.centerX.equalTo(contentV)
            make.size.equalTo(CGSize.init(width: 160, height: 160))
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalTo(contentV)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.left.equalTo(0)
            make.right.equalTo(snp.centerX)
        }
        bindBtn.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.width.equalTo(cancelBtn)
        }
        indicatorV.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentV)
            make.centerY.equalTo(bindBtn)
        }
        
        cancelBtn.rx.tap.bind { [unowned self] in
            self.animate(isShow: false)
        }.disposed(by: disposeBag)
        
        bindBtn.rx.tap.bind { [unowned self] in
            self.isBinding = true
            self.bindClosure?()
        }.disposed(by: disposeBag)
        
    }
    
    func animate(isShow show: Bool) {
        
        show ? animateToShow() : animateToDismiss()
    }
    
    func animateToShow() {
        
        let anim = CABasicAnimation()
        anim.keyPath = "position.y"
        anim.fromValue = -390 + 390 * 0.5
        anim.toValue = 105.layout + 390 * 0.5
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        contentV.layer.add(anim, forKey: nil)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    func animateToDismiss() {
        let contentFrame = contentV.frame
        let anim = CABasicAnimation()
        anim.keyPath = "position.y"
        anim.toValue = height + 390 * 0.5
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        contentV.layer.add(anim, forKey: nil)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (flag) in
            self.isBinding = false
            self.contentV.frame = contentFrame
            self.contentV.layer.removeAllAnimations()
            self.removeFromSuperview()
        }
    }
}
