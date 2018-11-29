//
//  SportListTitleView.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/9/18.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class SportListTitleView: BaseView {
    
    static var titleWidth: CGFloat { return 60 + 120.reW_less_4_7 }
    
    var buttons: [UIButton] = []
    var buttonClick: IntClosure?
    let line = UIView()
    var titles = [Text.Day, Text.Week, Text.Month]
    let containerView = UIView()
    
    var selectedItem: Int = 0 {
        didSet {
            
            for (index, button) in buttons.enumerated() {
                button.isSelected = index == selectedItem
            }
            self.lineAnimating(index: selectedItem)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSizeMake(SportListTitleView.titleWidth, Layout.NavBarHeight)
    }
    
    override func customizeInterface() {
        frame = CGRectMake(0, 0, SportListTitleView.titleWidth, Layout.NavBarHeight)
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalTo(self)
            make.width.equalTo(SportListTitleView.titleWidth)
        }
        
        for index in 0...2 {
            let button = BaseButton()
            button.rx.tap.bind { [unowned self] in
                self.selectedItem = index
                self.buttonClick?(index)
                }.disposed(by: disposeBag)
            containerView.addSubview(button)
            buttons.append(button)
            button.setTitleColor(UIColor.white, for: .selected)
            button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            button.titleLabel?.font = UIFont.bold15
            button.setTitle(titles[index], for: .normal)
            button.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(containerView)
                switch index {
                case 0:
                    make.left.equalTo(containerView)
                case 1:
                    make.centerX.equalTo(containerView)
                case 2:
                    make.right.equalTo(containerView)
                default:
                    break
                }
            }
            
            if index == 0 {
                button.isSelected = true
            }
        }
        
        containerView.addSubview(line)
        line.backgroundColor = UIColor.white
        line.frame = CGRect.init(x: 0, y: Layout.NavBarHeight - 8, width: 25, height: 3)
    }
    
    func lineAnimating(index: Int) {
        UIView.animate(withDuration: 0.2) {
            self.line.center = self.buttons[index].center
            self.line.frame.y = Layout.NavBarHeight - 8
        }
    }
}


enum SportTitleType: Int {
    case day = 1
    case week
    case month
}



