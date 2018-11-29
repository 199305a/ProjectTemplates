//
//  MoreItemCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MoreItemCell: MineFourthCell {
    
    var topLine: UIView!
    var bottomLine: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        line.removeFromSuperview()
        titleLabel.font = UIFont.bold15
        titleLabel.textColor = UIColor.hx5c5e6b
        detailLabel.font = UIFont.bold15
        detailLabel.textColor = UIColor.hx5c5e6b
        contentView.backgroundColor = UIColor.backgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

