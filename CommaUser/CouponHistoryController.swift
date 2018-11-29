//
//  CouponHistoryController.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/6/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 描述 历史优惠券
class CouponHistoryController: PagingController {
    
    let reuseIdentifier = "CouponHistoryCell"
    let viewModel = CouponListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isHistory = true
        updateDataFromNet()
        customizeBackgroundView()
    }
    
    
    override func setUpViews() {
        super.setUpViews()
        title = "历史优惠券"
    }
    
    
    override func customizeBackgroundView() {
        self.errorBackgroundView.title = Text.NoCouponNow
        self.errorBackgroundView.image = UIImage.init(named: "error-no-coupon")
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(CouponHistoryCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = EstimatedRowHeight
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, Layout.ScreenWidth, 10))
        viewModel.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: CouponHistoryCell.self)) { row, model, cell in
            cell.dataSource = model
            }.disposed(by: disposeBag)
    }
}

class CouponHistoryCell: CouponListCell {
    
    override var dataSource: AnyObject? {
        didSet {
            guard let model = dataSource as? CouponModel else {
                return
            }
            button.label.text = model.status_label
        }
    }
    
    override func customizeInterface() {
        super.customizeInterface()
        selectImageView.isHidden = true
        button.style = .center
        unit = NSAttributedString.init(string: "￥", attributes: [.foregroundColor: UIColor.hx9b9b9b, .font: UIFont.DINProBoldFontOf(size: 15)])
        priceAttr = [.foregroundColor: UIColor.hx9b9b9b, .font: UIFont.DINProBoldFontOf(size: 20)]
        let color = UIColor.hx9b9b9b
        titleLabel.textColor = color
        timeLabel.textColor = color
        requireLabel.textColor = color
    }
}
