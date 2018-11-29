//
//  MessageTitleView.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/25.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class ToggleTitleView: BaseView {
    
    typealias Click = (Int) -> Void
    let anounceButton = ClassesButton()
    let messageButton = ClassesButton()
    let line = BaseView()
    var buttonClick: Click!
    var items = [BaseButton]()
    var btnW: CGFloat = 44
    var btnSpace: CGFloat = 44
    var counts = [Bool]() {
        didSet {
            changeRedDot()
        }
    }
    
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
            
            changeRedDot()
            
            UIView.animate(withDuration: Layout.AnimateDuration) {
                self.line.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self)

                    make.size.equalTo(CGSizeMake(44, 3))

                    make.centerX.equalTo(button)
                }
                self.layoutIfNeeded()
            }
            
        }
    }
    
    init(itemTitles: [String]) {
        super.init(frame: CGRect.zero)
        createBtns(itemTitles)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBtns(_ itemTitles: [String]) {
        for title in itemTitles {
            let btn = BaseButton()
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.hx9b9b9b, for: .normal)
            btn.setTitleColor(UIColor.hx129faa, for: .selected)
            btn.titleLabel?.font = UIFont.bold15
            items.append(btn)
        }
    }
    
    func setUpViews() {
        
        for (i, item) in items.enumerated() {
            addSubview(item)
            if i == 0 {
                item.snp.makeConstraints { (make) in
                    make.left.top.bottom.equalTo(self)
                    make.width.equalTo(btnW)
                    make.height.equalTo(44)
                }
            } else if i == items.count - 1 {
                item.snp.makeConstraints { (make) in
                    make.left.equalTo(items[items.count-2].snp.right).offset(btnSpace)
                    make.top.bottom.right.equalTo(self)
                    make.width.equalTo(btnW)
                    make.height.equalTo(44)
                }
            } else {
                item.snp.makeConstraints { (make) in
                    make.left.equalTo(items[i-1].snp.right).offset(btnSpace)
                    make.top.bottom.equalTo(self)
                    make.width.equalTo(btnW)
                    make.height.equalTo(44)
                }
            }
            item.rx.tap.bind { [unowned self] in
                self.selectedItem = i
                self.buttonClick?(self.selectedItem)
            }.disposed(by: disposeBag)
        }
        addSubview(line)
        line.backgroundColor = UIColor.hx129faa
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.size.equalTo(CGSizeMake(44, 2))
            make.left.equalTo(items[0])
        }
        items[0].isSelected = true
    }

    //MARK: 隐藏显示小红点
    func changeRedDot() {
        for (i, button) in items.enumerated() {
            let haveNotice = counts[i]
            
            if ((i != selectedItem && !haveNotice) || i == selectedItem) {
                button.dismissRedDot()
            } else {
                button.showRedDot()
                button.redDotInset(point: CGPoint(x: -10, y: 13))
            }
        }
    }
}
