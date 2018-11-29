//
//  CouponListController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/20.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import IQKeyboardManagerSwift


//MARK: - 描述 我的优惠券
class CouponListController: PagingController {
    
    typealias CouponSelect = (CouponModel) -> Void
    
    let reuseIdentifier = "CouponListCell"
    let viewModel = CouponListViewModel()
    var couponSelect: CouponSelect?
    let header = CouponListHeaderView()
    var currentIndexPath: IndexPath?
    var currentCouponModel: CouponModel? // 当前选中的优惠券对象
    var loadFromMyListPage: Bool = false
    
    let bottomButton = BaseButton()
    
    var validModel: CouponValidModel? {
        didSet {
            viewModel.validModel = validModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromNet()
        customizeBackgroundView()
        if !loadFromMyListPage {
            tableView.mj_footer = nil
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //防止IQKeyboardManager 与 MJRefresh 的冲突
        IQKeyboardManager.shared.enable = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        navigationController?.navigationBar.shadowImage = DefaultNavbarShadowImage
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.MyCoupon
        view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(55)
        }
        
        view.addSubview(bottomButton)
        bottomButton.setTitle("历史优惠券", for: .normal)
        bottomButton.setTitleColor(UIColor.hx9b9b9b, for: .normal)
        bottomButton.titleLabel?.font = UIFont.bold15
        bottomButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-5)
            make.bottom.equalTo(-40)
        }
        let imageView = UIImageView.init(image: UIImage.init(named: "coupon_arrow"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomButton)
            make.left.equalTo(bottomButton.snp.right).offset(10)
        }
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tap)
        tap.rx.event.bind { [unowned self] _ in
            self.toHistory()
            }.disposed(by: disposeBag)
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(header.snp.bottom)
            make.bottom.equalTo(bottomButton.snp.top).offset(-10)
        }
    }
    
    func toHistory() {
        self.pushAnimated(CouponHistoryController())
    }
    
    override func setUpEvents() {
        header.buttonClick = { [unowned self] in
            self.exchangeCoupon(self.header.textfield.text)
        }
        bottomButton.rx.tap.bind { [unowned self] in
            self.toHistory()
            }.disposed(by: disposeBag)
    }
    
    override func customizeBackgroundView() {
        self.errorBackgroundView.title = Text.NoCouponNow
        self.errorBackgroundView.image = UIImage.init(named: "error-no-coupon")
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(CouponListCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = EstimatedRowHeight
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, Layout.ScreenWidth, 10))
        viewModel.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: CouponListCell.self)) { [weak self] row, model, cell in
            guard let this = self else { return }
            cell.dataSource = model
            cell.selectImageView.isHidden = this.loadFromMyListPage
            if !model.isAvailable {
                cell.selectImageView.isHidden = true
            }
            cell.buttonClick = {
                if !model.isAvailable {
                    return
                }
                let alert = CouponDetailView()
                alert.model = model
                alert.alt.show()
                alert.click = { [weak alert] in
                    alert?.alt.dismiss()
                }
            }
            }.disposed(by: disposeBag)
        
        viewModel.dataSource.asObservable().share(replay: 1).bind { [unowned self] (models) in
            guard let code = self.currentCouponModel?.coupon_code else {
                self.currentCouponModel = nil
                return
            }
            for(index, model) in models.enumerated() {
                if model.coupon_code == code {
                    self.currentCouponModel = model
                    self.currentIndexPath = IndexPath.init(row: index, section: 0)
                    break
                }
            }
            if self.currentCouponModel == nil { return }
            self.tableView.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
            
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { [unowned self] indexpath in
            self.itemsSeleted(indexpath: indexpath)
            }.disposed(by: disposeBag)
    }
    
    func itemsSeleted(indexpath: IndexPath) {
        
        if loadFromMyListPage {
            return
        }
        
        let model = self.viewModel.dataSource.value[indexpath.row]
        
        if !model.isAvailable {
            self.tableView.deselectRow(at: indexpath, animated: false)
            self.tableView.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
            return
        }
        
        if let tmp = self.couponSelect, self.currentIndexPath != indexpath {
            tmp(model)
        }
        self.currentCouponModel = model
        self.currentIndexPath = indexpath
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func exchangeCoupon(_ text: String?) -> Void {
        header.textfield.resignFirstResponder()
        guard String.isNotEmptyString(text) else {
            self.showTextMessage(Text.InputCorrectExchangeNotice)
            return
        }
        
        self.showLoading()
        NetWorker.post(ServerURL.CouponExchangeCoupon, params: ["exchange_code": text!], success: { (dataObj) in
            self.header.textfield.text = nil
            GlobalAction.handleWhenSuccess { self.updateDataFromNet() }
        }, error: { (statusCode, message) in
            self.showErrorWithMessage(message)
        }) { (error) in
            self.showNetErrorMessage()
        }
    }
    
    func clearCoupon() {
        currentIndexPath = nil
        currentCouponModel = nil
        updateDataFromNet()
    }
    
}

