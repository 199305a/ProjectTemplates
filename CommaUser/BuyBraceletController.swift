//
//  BuyBraceletController.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/5/2.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 购买手环
class BuyBraceletController: TableController, UITableViewDataSource, PayProtocol  {
    
    let BuyBraceletBigSmallCellID = "BuyBraceletBigSmallCell"
    let BuyBraceletIntroCellID = "BuyBraceletIntroCell"
    let BuyCardChangeGymCellID = "BuyCardChangeGymCell"
    
    let viewModel = BuyBraceletViewModel()
    let bottomView = CourseBottomView()
    let serviceView = ServiceView.init(height: 67)
    
    lazy var couponVC: CouponListController? = CouponListController()
    lazy var gymVC = SwitchStoreController(onlyShowGymStyle: true)
    
    var shouldClearCoupon = false  //是否需要清除优惠券
    var selectGym: (gymID: String?, gymName: String?) = (nil, nil)
    
    var validModel: CouponValidModel {
        return CouponValidModel.with(gymID: selectGym.gymID, amount: viewModel.dataSource.value.price, type: .bracelet, subID: "0")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectGym.gymID = CurrentGym.gym_id
        selectGym.gymName = CurrentGym.gym_name
        updateDataFromNet()
    }
    
    override func setUpViews() {
        super.setUpViews()
        title =  Text.BuyBracelet
        bottomView.button.setTitle(Text.SureBuyCard, for: .normal)
        pay.relayoutTableView()
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.dataSource = self
        pay.commonHandleTableView()
        tableView.registerClass(BuyBraceletBigSmallCell.self)
        tableView.registerClass(BuyBraceletIntroCell.self)
        tableView.registerClass(BuyCardChangeGymCell.self)
        tableView.tableFooterView = UIView()
    }
    
    override func setUpEvents() {
        
        pay.registNotification(destinationVC: MyOrdersController())
        
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
        bottomView.click = { [unowned self] in
            self.toBuyBracelet()
        }
    }
    
    func handleData(model: BuyBraceletModel) {
        refreshPrice()
        tableView.reloadData()
    }
    
    func refreshPrice() {
        bottomView.contentLabel.attributedText = PayFomatter.commaPriceWith￥(viewModel.dataSource.value.price, discount: viewModel.couponModel?.price)
        bottomView.detailLabel.text = PayFomatter.discountFormat(viewModel.couponModel?.price?.commasString)
    }
    
    /**
     去支付
     */
    func toBuyBracelet() {
        
        guard GlobalAction.isLogin else {
            Jumper.jumpToLogin()
            return
        }
        
        guard let gymID = selectGym.gymID else {
            showErrorWithMessage(Text.ChooseGymFirst)
            return
        }
        
        if !PayManager.isWxPayInstalled(viewModel.payType) { return }
        
        var params = [String: Any]()
        params["pay_type"] = viewModel.payType.rawValue
        params["gym_id"] = gymID
        if let couponID = viewModel.couponModel?.coupon_code {
            params["user_coupon_id"] = couponID
        }
        HitMessage.showLoading()
        NetWorker.post(ServerURL.BuyBracelet, params: params, success: { (dataObj) in
            //需要清除优惠券
            self.shouldClearCoupon = true
            PayManager.shared.toPay(dataObj, buyType: .bracelet)
        }, error: { (statusCode, message) in
            self.shouldClearCoupon = true
            if statusCode == CustomNetError.NoCardErrorCode {
                self.pay.toBuyCard()
            } else {
                self.showErrorWithMessage(message)
            }
        }) { (error) in
            self.showNetErrorMessage()
        }
        
    }
    
    //MARK: -- table view delegate and data source --
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : pay.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            return pay.setUpCell(tableView: tableView, indexPath: indexPath)
        }
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: BuyBraceletIntroCellID, for: indexPath) as! BuyBraceletIntroCell
            cell.dataSource = viewModel.dataSource.value
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: BuyCardChangeGymCellID, for: indexPath) as! BuyCardChangeGymCell
            cell.titleLabel.text = selectGym.gymName ?? Text.ChooseGymFirst
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BuyBraceletBigSmallCellID, for: indexPath) as! BuyBraceletBigSmallCell
            cell.setUpModel(indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return pay.cellHeight(tableView: tableView, indexPath: indexPath)
        }
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return 28
        case 2:
            return 40
        case 3:
            return 68
        default:
            return 58
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                guard selectGym.gymID != nil else {
                    showErrorWithMessage(Text.ChooseGymFirst)
                    return
                }
            }
            pay.selectCell(tableView: tableView, indexPath: indexPath)
        } else if indexPath.tuple == (0, 2) {
            gymVC.itemClick = { [unowned self] model in
                self.selectGym.gymID = model.gym_id
                self.selectGym.gymName = model.gym_name
                self.tableView.reloadData()
            }
            pushAnimated(gymVC)
        }
    }
}
