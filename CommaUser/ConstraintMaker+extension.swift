//
//  ConstraintMaker+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/30.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import SnapKit

extension ConstraintMaker {
    func setCenterXin(_ conV: UIView, offset: CGFloat) {
        centerX.equalTo(conV)
        var fix = offset

        if offset > 0 {
            fix = -fix
        }

        width.equalTo(conV).offset(fix)
    }

    func setCenterYin(_ conV: UIView, offset: CGFloat) {
        centerY.equalTo(conV)
        height.equalTo(conV).offset(-offset)
    }
}
