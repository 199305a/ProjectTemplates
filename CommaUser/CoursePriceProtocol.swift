//
//  CoursePriceProtocol.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/24.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import Foundation


protocol CoursePriceProtocol {
    var max_price: String? { get }
    var min_price: String? { get }
    var wholePrice: String? { get }
}

extension CoursePriceProtocol {
    var wholePrice: String? {
        if let max = self.max_price,
            let min = self.min_price {
            return min + "~" + max + "/课时"
        }
        return nil
    }
}


