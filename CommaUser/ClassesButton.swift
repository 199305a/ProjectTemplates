//
//  ClassesButton.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class ClassesButton: BaseButton {
    
    let line = BaseView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.hx9b9b9b, for: .normal)
        setTitleColor(UIColor.hx129faa, for: .selected)
        titleLabel?.font = UIFont.bold15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
