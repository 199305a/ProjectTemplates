//
//  CharacterSet+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/1/9.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

extension CharacterSet {
    static var customAllowedSet: CharacterSet {
        return CharacterSet.init(charactersIn: "&=\"#%/<>?@\\^`{|}").inverted
    }
}
