//
//  CourseInfoFooterView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class CourseInfoFooterView: BaseView {
    
    var titleLabel = Font15Label()
    var containerView = BaseView()
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var images = [FillImageView]()
    var button = BaseButton()
    var click: EmptyClosure?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.backgroundColor
        containerView.backgroundColor = UIColor.white
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self)
            make.bottom.equalTo(self).offset(-30)
            make.right.equalTo(self).offset(-15)
        }
        containerView.shadow()
        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 4
        
        titleLabel.text = Text.StoreIntroduction
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.bold20
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(15)
            make.top.equalTo(containerView).offset(20)
        }
        
        button.setImage(UIImage.init(named: "course_info_arrow"), for: .normal)
        containerView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(containerView).offset(-15)
        }
        
        containerView.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 4
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 140, height: 100)
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 22, 15)
        layout.scrollDirection = .horizontal
        
        containerView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        containerView.addGestureRecognizer(tap)
        tap.rx.event.bind { [unowned self] (_) in
            self.click?()
            }.disposed(by: disposeBag)
        
        button.rx.tap.bind { [unowned self] in
            self.click?()
            }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
