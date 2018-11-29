//
//  CouponDetailView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/6/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CouponDetailView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = BaseTableView.init(frame: .zero, style: .plain)
    let sureButton = BaseButton()
    var click: EmptyClosure?
    let reuseID = "Cell"
    let headerID = "Header"
    var warning: String?
    var gyms: String?
    
    var model: CouponModel? {
        didSet {
            gyms = model?.gyms
            var str = ""
            if let text = model?.use_condition, !text.isEmpty {
                str = "· " + text + "\n"
            }
            if let text = model?.available_time, !text.isEmpty {
                str = str + "· " + text + "\n"
            }
            if let text = model?.desc, !text.isEmpty {
                str = str + "· " + text
            }
            warning = str
        }
    }
    
    override func customizeInterface() {
        frame = CGRectMake(0, 0, 345, 440)
        layer.cornerRadius = 5
        backgroundColor = UIColor.white
        addSubview(tableView)
        addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(-13)
            make.height.equalTo(72)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(sureButton.snp.top)
        }
        sureButton.setTitle(Text.Known, for: .normal)
        sureButton.titleLabel?.font = UIFont.bold20
        sureButton.setTitleColor(UIColor.hx129faa, for: .normal)
        sureButton.rx.tap.bind { [unowned self] in
            self.click?()
            }.disposed(by: disposeBag)
        
        
        tableView.registerClass(Cell.self)
        tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: headerID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.sectionHeaderHeight = 78
        tableView.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! Cell
        let str = indexPath.section == 0 ? warning : gyms
        cell.setUp(content: str, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! SectionHeader
        view.label.text = section == 0 ? "使用须知" : "适用场馆"
        return view
    }
}

extension CouponDetailView {
    class Cell: BaseTableViewCell {
        
        override func customizeInterface() {
            contentView.backgroundColor = UIColor.white
            detailLabel = BaseLabel()
            detailLabel.numberOfLines = 0
            detailLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.appFontOfSize(15))
            contentView.addSubview(detailLabel)
            detailLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(contentView).offset(-4)
                make.left.equalTo(contentView).offset(53)
                make.right.equalTo(-53)
                make.top.equalTo(contentView)
            }
        }
        
        func setUp(content: String?, indexPath: IndexPath) {
            
            if indexPath.section == 0 {
                detailLabel.snp.makeConstraints { (make) in
                    make.bottom.equalTo(contentView).offset(-4)
                    make.left.equalTo(contentView).offset(34)
                    make.right.equalTo(-34)
                    make.top.equalTo(contentView)
                }
                detailLabel.text = content
                detailLabel.setLineSpace(10)
            } else {
                detailLabel.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(contentView).offset(-4)
                    make.left.equalTo(contentView).offset(34)
                    make.right.equalTo(-34)
                    make.top.equalTo(contentView)
                }
                detailLabel.text = content
                detailLabel.setLineSpace(6)
            }
            
        }
    }
    
    class SectionHeader: UITableViewHeaderFooterView {
        
        let label = BaseLabel()
        
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = UIColor.white
            contentView.addSubview(label)
            label.setUp(textColor: UIColor.hx596167, font: UIFont.bold20)
            label.snp.makeConstraints { (make) in
                make.centerX.equalTo(contentView)
                make.top.equalTo(30)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}
