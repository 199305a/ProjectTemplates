//
//  BodyTestResultView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BodyTestResultView: BaseView {
    
    var result: String = "" {
        didSet{
            resultLabel.text = result
        }
    }
    
    let resultLabel = BaseLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.hxc1c3c8.withAlphaComponent(0.1)
        layer.cornerRadius = 4
        let resultTitleLabel = BaseLabel()
        resultTitleLabel.textColor = UIColor.hx5c5e6b
        resultTitleLabel.font = UIFont.bold15
        resultTitleLabel.text = "分析结论"
        resultLabel.textColor = UIColor.hx9b9b9b
        resultLabel.font = UIFont.appFontOfSize(12)
        resultLabel.numberOfLines = 0
        
        addSubview(resultTitleLabel)
        addSubview(resultLabel)
        resultTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
        }
        resultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(resultTitleLabel)
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(9)
            make.right.bottom.equalTo(-15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
