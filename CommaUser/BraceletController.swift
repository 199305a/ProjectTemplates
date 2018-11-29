//
//  BraceletController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/7/8.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

class BraceletController: BaseController {
    
    let titleLabel = Font15Label()
    let imageView = UIImageView.init(image: UIImage.init(named: "bracelet_only"))
    let shadowImageView = UIImageView.init(image: UIImage.init(named: "bracelet_wave"))
    let shadowView = UIView()
    var width: CGFloat!
    var height: CGFloat!
    let topImageView = FillImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showShadowAnimate()
        
    }
    
    override func setUpViews() {
        super.setUpViews()
        view.backgroundColor = UIColor.white
        
        view.addSubview(imageView)
        view.addSubview(shadowView)
        view.addSubview(titleLabel)
        view.addSubview(topImageView)
        topImageView.image = UIImage.init(named: "free")
        topImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
        }
        
        
        titleLabel.text = Text.BraceletOpenDoorNotice
        titleLabel.font = UIFont.appFontOfSize(17)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topImageView.snp.bottom).offset(27)
        }
        
        width = shadowImageView.image!.size.width
        height = shadowImageView.image!.size.height
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom)
            make.size.equalTo(imageView.image!.size)
        }
        
        shadowView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
            make.size.equalTo(CGSizeMake(width * 3, height * 3))
        }
        
        shadowView.addSubview(shadowImageView)
        shadowImageView.alpha = 0.8
        shadowImageView.snp.makeConstraints { (make) in
            make.center.equalTo(shadowView)
            make.size.equalTo(CGSizeMake(width, height))
        }
    }
    
    /**
     开启动画
     */
    func showShadowAnimate() {
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.repeat, animations: {
            self.shadowImageView.alpha = 0
            self.shadowImageView.snp.remakeConstraints({ (make) in
                make.center.equalTo(self.shadowView)
                make.size.equalTo(self.shadowView)
            })
            self.shadowView.layoutIfNeeded()
            
        }) { (_) in
            
        }
        
    }
    
    func dismissShadowAnimate() {
        
    }
    
}
