//
//  CoursesTitleView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/8.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CoursesTitleView: BaseView {
    
    var model: CoursesGymModel? {
        didSet {
            let title = model?.isEmpty == true ? "点击选择场馆" : (model?.gym_name ?? " ")
            gymButton.setTitle(title, for: .normal)
            label.text = model?.distance
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSizeMake(Layout.ScreenWidth, Layout.NavBarHeight)
    }
    
    let locationButton = BaseButton()
    let rightButton = BaseButton()
    let gymButton = BaseButton()
    var locationButtonClick: EmptyClosure?
    var rightButtonClick: EmptyClosure?
    var gymButtonClick: EmptyClosure?
    
    let label = Font12Label()
    
    
    override func customizeInterface() {
        frame = CGRectMake(0, 0, Layout.ScreenWidth, Layout.NavBarHeight)
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        view.addSubview(locationButton)
        locationButton.setImage(UIImage.init(named: "main_location"), for: .normal)
        let lsize = locationButton.imageView?.image?.size ?? CGSizeMake(26)
        locationButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10)
            make.bottom.equalTo(view)
            make.size.equalTo(lsize)
        }
        
        locationButton.rx.tap.bind { [unowned self] in
            self.locationButtonClick?()
            }.disposed(by: disposeBag)
        
        view.addSubview(rightButton)
        rightButton.setTitle(Text.VisitorOpenDoor, for: .normal)
        rightButton.setTitleColor(UIColor.hx129faa, for: .normal)
        rightButton.titleLabel?.font = UIFont.bold15
        rightButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.right.equalTo(view).offset(-15)
        }
        rightButton.rx.tap.bind { [unowned self] in
            self.rightButtonClick?()
            }.disposed(by: disposeBag)
        view.addSubview(gymButton)
        gymButton.titleLabel?.font = UIFont.boldAppFontOfSize(15)
        gymButton.setTitleColor(UIColor.hx5c5e6b, for: .normal)
        gymButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.equalTo(locationButton.snp.right).offset(2)
        }
        gymButton.rx.tap.bind { [unowned self] in
            self.gymButtonClick?()
            }.disposed(by: disposeBag)
        
        view.addSubview(label)
        label.textColor = UIColor.hx9b9b9b
        label.snp.makeConstraints { (make) in
            make.left.equalTo(gymButton.snp.right).offset(6).priority(500)
            make.lastBaseline.equalTo(gymButton.titleLabel!.snp.lastBaseline)
            make.right.lessThanOrEqualTo(rightButton.snp.left).offset(-6).priority(1000)
        }
    }
    
}
