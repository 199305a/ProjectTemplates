//
//  TrainerInfoHeaderFooterView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class TrainerInfoHeaderFooterView: BaseSectionHeaderFooterView {
    let label = Font14Label()
    let view = BaseView()
    let whiteView = BaseView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.backgroundColor
        view.backgroundColor = UIColor.minorColor
        whiteView.backgroundColor = UIColor.white
        contentView.addSubview(view)
        contentView.addSubview(whiteView)
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(15)
            make.height.equalTo(30)
        }
        whiteView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(view.snp.bottom)
        }
        view.addSubview(label)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
