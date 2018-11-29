//
//  BodyTestAnalysisCell.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class BodyTestAnalysisCell: BodyTestBaseCell {
    let bodyData = Variable([AnalysisDataModel]())
    var analysis: AnalysisModel! {
        didSet{
            if analysis == nil { return }
            titleLabel.text = analysis.title
            bodyData.value = analysis.body_data ?? []
            resultView.result = analysis.advise
        }
    }
    
    var isShowResult = true {
        didSet {
            if isShowResult {
                tableView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(18)
                    make.left.right.equalTo(containerView)
                    make.height.equalTo(117 * bodyData.value.count)
                }
                containerView.addSubview(resultView)
                resultView.snp.makeConstraints { (make) in
                    make.top.equalTo(tableView.snp.bottom).offset(20)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.bottom.equalTo(-30)
                }
            } else {
                tableView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(18)
                    make.left.right.equalTo(containerView)
                    make.height.equalTo(117 * bodyData.value.count)
                    make.bottom.equalTo(-30)
                }
                resultView.removeFromSuperview()
            }
            
        }
    }
    
    let resultView = BodyTestResultView()
    let tableView = BaseTableView()
    let subItemreuseIdentifier = "BodyTestSubItemCell"
    override func customizeInterface() {
        super.customizeInterface()
        
        containerView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.left.right.equalTo(containerView)
            make.height.equalTo(90 * 3)
        }
        
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.registerClass(BodyTestSubItemCell.self)
        tableView.rowHeight = 117
        tableView.isScrollEnabled = false
        bodyData.asObservable().bind(to: tableView.rx.items(cellIdentifier: subItemreuseIdentifier, cellType: BodyTestSubItemCell.self)) { row, model, cell in
            cell.item = model
            }.disposed(by: disposeBag)
    }

}

class BodyTestSubItemCell: BaseTableViewCell {
    
    var item: AnalysisDataModel! {
        didSet{
            if item == nil { return }
            itemLabel.text = item.chinese_name + (item.english_name.isEmpty ? "：" : ("(\(item.english_name))："))
            numberLabel.text = item.value
            unitLabel.text = item.unit
            spanNumberLabel.text = item.criterion_min + " ~ " + item.criterion_max + item.unit
            let ratio = ratioOfValue(item.value.doubleValue ?? 0, standardMin: item.criterion_min.doubleValue ?? 0, standardMax: item.criterion_max.doubleValue ?? 0)
            progressV.snp.remakeConstraints { (make) in
                make.left.top.bottom.equalTo(progressBg)
                make.width.equalTo(progressBg.snp.width).multipliedBy(ratio)
            }
        }
    }
    
    let standardMinRatio = 1.0 / 3.0
    let standardMaxRatio = 2.0 / 3.0
    let defaultHeight: CGFloat = 90
    let itemLabel = BaseLabel()
    let numberLabel = BaseLabel()
    let unitLabel = BaseLabel()
    let normalDescLabel = BaseLabel()
    let spanNumberLabel = BaseLabel()
    let progressBg = BaseView()
    let progressV = BaseView()
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        itemLabel.textColor = UIColor.hx5c5e6b
        itemLabel.font = UIFont.appFontOfSize(12)
        numberLabel.textColor = UIColor.hx129faa
        numberLabel.font = UIFont.DINProBoldFontOf(size: 20)
        normalDescLabel.textColor = UIColor.hx9b9b9b
        normalDescLabel.font = UIFont.appFontOfSize(12)
        normalDescLabel.text = "正常范围："
        unitLabel.textColor = UIColor.hx129faa
        unitLabel.font = UIFont.DINProBoldFontOf(size: 15)
        spanNumberLabel.textColor = UIColor.hx129faa
        spanNumberLabel.font = UIFont.DINProBoldFontOf(size: 12)
        progressBg.backgroundColor = UIColor.hexColor(0xd8d8d8).withAlphaComponent(0.2)
        progressBg.layer.cornerRadius = 2.5
        progressV.backgroundColor = UIColor.hx129faa
        progressV.layer.cornerRadius = 2.5
        let spanView = BaseView()
        spanView.backgroundColor = UIColor.hexColor(0xd6d7d8).withAlphaComponent(0.2)
        spanView.layer.cornerRadius = 10
        spanView.layer.masksToBounds = true
        let lowLabel = BaseLabel()
        lowLabel.text = "低"
        lowLabel.textColor = UIColor.hx9b9b9b
        lowLabel.font = UIFont.boldAppFontOfSize(10)
        lowLabel.textAlignment = .center
        let normalLabel = BaseLabel()
        normalLabel.text = "标准"
        normalLabel.textColor = UIColor.hx9b9b9b
        normalLabel.font = UIFont.boldAppFontOfSize(10)
        normalLabel.textAlignment = .center
        let highLabel = BaseLabel()
        highLabel.text = "高"
        highLabel.textColor = UIColor.hx9b9b9b
        highLabel.font = UIFont.boldAppFontOfSize(10)
        highLabel.textAlignment = .center
        let xline1 = BaseView()
        xline1.backgroundColor = UIColor.hexColor(0xd8d8d8).withAlphaComponent(0.2)
        let xline2 = BaseView()
        xline2.backgroundColor = UIColor.hexColor(0xd8d8d8).withAlphaComponent(0.2)
        
        contentView.addSubview(itemLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(normalDescLabel)
        contentView.addSubview(spanNumberLabel)
        contentView.addSubview(progressBg)
        contentView.addSubview(progressV)
        contentView.addSubview(spanView)
        spanView.addSubview(lowLabel)
        spanView.addSubview(normalLabel)
        spanView.addSubview(highLabel)
        spanView.addSubview(xline1)
        spanView.addSubview(xline2)
        
        itemLabel.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.top.equalTo(14)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(itemLabel.snp.right)
            make.bottom.equalTo(itemLabel)
        }
        unitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numberLabel.snp.right)
            make.bottom.equalTo(numberLabel)
        }
        normalDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(itemLabel)
            make.top.equalTo(itemLabel.snp.bottom).offset(10)
        }
        spanNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(normalDescLabel.snp.right)
            make.centerY.equalTo(normalDescLabel)
        }
        progressBg.snp.makeConstraints { (make) in
            make.top.equalTo(normalDescLabel.snp.bottom).offset(12)
            make.left.equalTo(19)
            make.right.equalTo(-19)
            make.height.equalTo(5)
        }
        progressV.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(progressBg)
            make.width.equalTo(progressBg.snp.width).multipliedBy(0.5)
        }
        spanView.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.right.equalTo(-19)
            make.height.equalTo(20)
            make.top.equalTo(progressBg.snp.bottom).offset(9)
            make.bottom.equalTo(-10)
        }
        lowLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(spanView)
            make.width.equalTo(spanView.snp.width).dividedBy(3).offset(4.0/3)
        }
        xline1.snp.makeConstraints { (make) in
            make.left.equalTo(lowLabel.snp.right)
            make.top.bottom.equalTo(spanView)
            make.width.equalTo(2)
        }
        normalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(xline1.snp.right)
            make.top.width.bottom.equalTo(lowLabel)
        }
        xline2.snp.makeConstraints { (make) in
            make.left.equalTo(normalLabel.snp.right)
            make.width.top.bottom.equalTo(xline1)
        }
        highLabel.snp.makeConstraints { (make) in
            make.left.equalTo(xline2.snp.right)
            make.top.bottom.right.equalTo(spanView)
        }
    }
}

extension BodyTestSubItemCell {
    //MARK: - 将实际值转化为比例
    func ratioOfValue(_ value: Double, standardMin: Double, standardMax: Double) -> Double {
        let seg = 1.0 / 3
        switch value {
        case ..<standardMin:
            return seg * (max(0, value) / standardMin)
        case standardMin..<standardMax:
            return seg + seg * ((value - standardMin) / (standardMax - standardMin))
        case standardMax...:
            return seg * 2 + seg * ((min(3*standardMax, value) - standardMax) / (2 * standardMax))
        default:
            return 0
        }
    }
}

