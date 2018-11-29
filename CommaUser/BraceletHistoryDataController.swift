//
//  BraceletHistoryDataController.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/27.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 手环历史记录
class BraceletHistoryDataController: TableController {

    let viewModel = BraceletHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromNet()
        title = "手环历史数据"
        errorBackgroundView.title = "没有历史记录"
        errorBackgroundView.image = UIImage.init(named: "no-bracelet-dada")
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.backgroundColor = UIColor.clear
        tableView.register(BraceletHistoryDataCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = tableHeader
        tableView.contentInset.top = 7.5
        tableView.contentInset.bottom = 7.5
        tableView.rowHeight = 143
    }
    
    override func setUpEvents() {
        viewModel.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: BraceletHistoryDataCell.self)) { row, model, cell in
            cell.model = model
            }.disposed(by: disposeBag)
    }

    let tableHeader: BaseView = {
        let v = BaseView()
        v.frame.size = CGSize.init(width: Layout.ScreenWidth, height: 42)
        let label = BaseLabel()
        label.text = "仅展示最近7天数据"
        label.textColor = UIColor.hx9b9b9b
        label.font = UIFont.appFontOfSize(12)
        v.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(12.5)
            make.centerX.equalTo(v)
        }
        return v
    }()
}
