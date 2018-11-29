//
//  ModuleDataCell.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class ModuleDataCell: BaseTableViewCell {
    
    var model: AnalysisDataModel! {
        didSet{
            moduleNameLabel.text = model.chinese_name + ":"
            countLabel.text = model.value
            unitLabel.text = model.unit
            evaluateLabel.text = model.evaluateDesc
            normalNumLabel.text = model.criterion_min + "-" + model.criterion_max
        }
    }
    
    let moduleNameLabel = Font12Label()
    let countLabel = Font13Label()
    let unitLabel = Font13Label()
    let evaluateLabel = Font12Label()
    let normalDesLabel = Font12Label()
    let normalNumLabel = Font13Label()
    
    override func customizeInterface() {
        
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(moduleNameLabel)
        moduleNameLabel.textColor = UIColor.hx596167
        
        moduleNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(Layout.layoutScaleWidth(15))
        }
        
        contentView.addSubview(countLabel)
        countLabel.textColor = UIColor.hx34c86c
        countLabel.font = UIFont(name: Text.Impact, size: 13)
        
        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(moduleNameLabel.snp.right).offset(5)
        }
        
        contentView.addSubview(unitLabel)
        unitLabel.textColor = UIColor.hx596167
        unitLabel.font = UIFont(name: Text.Impact, size: 13)
        
        unitLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(countLabel.snp.right)
        }
        
        contentView.addSubview(evaluateLabel)
        evaluateLabel.textColor = UIColor.hx34c86c
        
        evaluateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(unitLabel.snp.right).offset(5)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(normalNumLabel)
        normalNumLabel.textColor = UIColor.hx34c86c
        normalNumLabel.textAlignment = .right
        normalNumLabel.font = UIFont(name: Text.Impact, size: 13)
        
        normalNumLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-Layout.layoutScaleWidth(15))
        }
        
        contentView.addSubview(normalDesLabel)
        normalDesLabel.textColor = UIColor.hx596167
        normalDesLabel.textAlignment = .right
        normalDesLabel.text = Text.Level_Standard + "："
        
        normalDesLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(normalNumLabel.snp.left)
        }
        
        moduleNameLabel.LayoutFontByIphone6()
        countLabel.LayoutFontByIphone6()
        unitLabel.LayoutFontByIphone6()
        evaluateLabel.LayoutFontByIphone6()
        normalDesLabel.LayoutFontByIphone6()
        normalNumLabel.LayoutFontByIphone6()
    }
}
