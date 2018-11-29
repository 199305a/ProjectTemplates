//
//  BindSuccessView.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/18.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class BindSuccessView: BaseView {

    let contentV = BaseView()
    let knownBtn = BaseButton()
    let titleLabel = BaseLabel()
    let imageView = BaseImageView(image: UIImage.init(named: "bind-success"))
    var knownClosure: EmptyClosure?
    var dismissClosure: EmptyClosure?
    
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
    
    func showInView(_ view: UIView) {
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
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.boldAppFontOfSize(20)
        titleLabel.text = Text.BindSuccess
        imageView.contentMode = .center
        let successLabel = BaseLabel()
        successLabel.textColor = UIColor.hx129faa
        successLabel.font = UIFont.DINProBoldFontOf(size: 40)
        successLabel.text = "SUCCESS!"
        knownBtn.setTitle(Text.Known, for: .normal)
        knownBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        knownBtn.titleLabel?.font = UIFont.boldAppFontOfSize(20)
        knownBtn.contentEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        
        addSubview(contentV)
        contentV.addSubview(titleLabel)
        contentV.addSubview(imageView)
        contentV.addSubview(successLabel)
        contentV.addSubview(knownBtn)
        contentV.snp.makeConstraints { (make) in
            make.top.equalTo((105 + Layout.safeAreaInsetsTop).layout)
            make.centerX.equalTo(self)
            make.width.equalTo(345.layout)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalTo(contentV)
            make.size.equalTo(CGSize.init(width: 150, height: 150))
        }
        successLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageView.snp.bottom).offset(19)
            make.centerX.equalTo(imageView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentV)
            make.top.equalTo(successLabel.snp.bottom).offset(54)
        }
        knownBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-20)
            make.left.right.equalTo(contentV)
        }
        
        knownBtn.rx.tap.bind { [unowned self] in
            self.animateToDismiss()
        }.disposed(by: disposeBag)
    }
    
    func animate(isShow show: Bool) {
        show ? animateToShow() : animateToDismiss()
    }
    
    func animateToShow() {
        let anim = CABasicAnimation()
        anim.keyPath = "position.x"
        anim.fromValue = 345.layout + 345.layout * 0.5
        anim.toValue = (Layout.ScreenWidth - 345.layout) / 2 + 345.layout * 0.5
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        contentV.layer.add(anim, forKey: nil)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    func animateToDismiss() {
        let anim = CABasicAnimation()
        anim.keyPath = "position.x"
        anim.toValue = -345.layout + 345.layout * 0.5
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        contentV.layer.add(anim, forKey: nil)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (flag) in
            self.removeFromSuperview()
            self.dismissClosure?()
        }
    }


}
