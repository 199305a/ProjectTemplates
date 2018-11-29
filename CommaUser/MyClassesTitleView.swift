//
//  MyClassesTitleView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MyClassesTitleView: BaseView {
    typealias Click = (Int) -> Void
    let courseButton = ClassesButton()
    let privateButton = ClassesButton()
    let line = BaseView()
    var buttonClick: Click!
    var items = [ClassesButton]()
    let containerView = UIView()
    
    var selectedItem: Int = 0 {
        didSet {
            
            let button = self.items[self.selectedItem]
            button.isSelected = true
            let array = self.items.filter({ (aButton) -> Bool in
                aButton != button
            })
            array.forEach({ (aButton) in
                aButton.isSelected = false
            })
            
            UIView.animate(withDuration: Layout.AnimateDuration) {
                self.line.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self.containerView)
                    make.size.equalTo(CGSizeMake(55, 3))
                    make.centerX.equalTo(button)
                }
                self.layoutIfNeeded()
            }
            
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSizeMake(200, 44)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalTo(self)
            make.width.equalTo(160)
        }
        containerView.addSubview(courseButton)
        containerView.addSubview(privateButton)
        items.append(courseButton)
        items.append(privateButton)
        courseButton.setTitle(Text.GroupClass, for: .normal)
        privateButton.setTitle(Text.PrivateClass, for: .normal)
        
        privateButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(containerView)
            make.width.equalTo(55)
        }
        courseButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(55)
        }
        
        containerView.addSubview(line)
        line.backgroundColor = UIColor.hx129faa
        
        
        for (index, button) in items.enumerated() {
            button.rx.tap.bind { [unowned self] in
                self.selectedItem = index
                if let tmp = self.buttonClick {
                    tmp(self.selectedItem)
                }
                
            }.disposed(by: disposeBag)
        }
        
        let button = items[0]
        button.isSelected = true
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(containerView)
            make.size.equalTo(CGSizeMake(55, 3))
            make.centerX.equalTo(button)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
