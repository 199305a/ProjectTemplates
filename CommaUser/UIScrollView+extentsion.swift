//
//  UIScrollView+extentsion.swift
//  CommaUser
//
//  Created by yuanchao on 2017/12/4.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func neverAdjustContentInset() {
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
}
