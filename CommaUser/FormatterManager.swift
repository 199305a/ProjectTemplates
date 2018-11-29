//
//  FormatterManager.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/17.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

struct DateFormatterManager {
    
    static var muniteSecondFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
  }()
    
}
