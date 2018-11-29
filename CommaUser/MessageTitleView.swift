//
//  MessageTitleView.swift
//  Liking
//
//  Created by lekuai on 2017/7/25.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MessageTitleView: BaseView {
    
    typealias Click = (Int) -> Void
    let anounceButton = ClassesButton()
    let messageButton = ClassesButton()
    let line = BaseView()
    var buttonClick: Click!
    var items = [ClassesButton]()
    
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
                    make.bottom.equalTo(self)

                    make.size.equalTo(CGSizeMake(44, 2))

                    make.centerX.equalTo(button)
                }
                self.layoutIfNeeded()
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(anounceButton)
        addSubview(messageButton)
        items.append(anounceButton)
        items.append(messageButton)
        anounceButton.setTitle(Str.Announcement, for: .normal)
        messageButton.setTitle(Str.Message, for: .normal)
        
        anounceButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(44)
        }
        messageButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(44)
        }
        
        addSubview(line)
        line.backgroundColor = UIColor.darkGreenColor
        
        
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
            make.bottom.equalTo(self)
            make.size.equalTo(CGSizeMake(44, 2))
            make.left.equalTo(button)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
