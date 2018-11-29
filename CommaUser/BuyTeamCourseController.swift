//
//  BuyTeamCourseController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/8/23.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

//MARK: - 描述 确认预约团体课
class BuyTeamCourseController: TableController, UITableViewDataSource, PayProtocol, ServiceViewProtocol {
    
    let viewModel = BuyTeamCourseViewModel()
    let bottomView = CourseBottomView()
    let header = BuyTeamCourseHeaderView(frame: CGRectMake(0, 0, Layout.ScreenWidth, 330))
    let serviceView = ServiceView.init(height: 67, preMessage: Text.AlreadyReadAndAgree, sufMessage: Text.TeamCourseMemberProtocol)
    lazy var couponVC: CouponListController? = CouponListController()
    var shouldClearCoupon = false  //是否需要清除优惠券
    var didAgreeProtocol = false {
        didSet {
            bottomView.canUse = didAgreeProtocol
            serviceView.selectButton.isSelected = didAgreeProtocol
        }
    }
    
    var validModel: CouponValidModel {
        return CouponValidModel.with(gymID: CurrentGymID, amount: viewModel.dataSource.value.price, type: .feeTeamCourse, subID: viewModel.scheduleID)
    }
    
    init(scheduleID: String?) {
        super.init(nibName: nil, bundle: nil)
        viewModel.scheduleID = scheduleID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromNet()
        bottomView.canUse = false
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.SureBooking
        bottomView.button.setTitle(Text.SureBooking, for: .normal)
        pay.relayoutTableView()
        
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.dataSource = self
        tableView.tableHeaderView = header
        pay.commonHandleTableView()
    }
    
    override func setUpEvents() {
        
        pay.setUpServiceView(type: .feeTeamCourse)
        pay.registNotification(destinationVC: MyAppointmentVC())
        
        bottomView.click = { [unowned self] in
            self.toBuyCourse()
        }
        
        
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
    }
    
    func handleData(model: CourseInfoModel) {
        header.courmodel = model
        tableView.autoLayoutTableHeaderView(header)
        self.tableView.reloadData()
        refreshPrice()
    }
    
    func refreshPrice() {
        bottomView.contentLabel.attributedText = PayFomatter.commaPriceWith￥(viewModel.dataSource.value.price, discount: viewModel.couponModel?.price)
        bottomView.detailLabel.text = PayFomatter.discountFormat(viewModel.couponModel?.price?.commasString)
    }
    
    override func handleEndLoading() {
        self.loadingView?.endLoading()
        hiddenLastHUD()
        viewModel.errorClosure = { [weak self] code, message in
            switch code {
            case CustomNetError.NoCardErrorCode:
                self?.pay.toBuyCard()
            default:
                let hud = self?.showErrorWithMessage(message)
                self?.popControllerWhenHUDHided(hud)
            }
        }
    }
    
    
    func toBuyCourse() {
        
        guard didAgreeProtocol else {
            let alert = LFAlertView.init(title: Text.Reminding, message: Text.ReadTeamCourseProtocolFirst, items: [Text.Sure])
            alert.show()
            return
        }
        
        if !PayManager.isWxPayInstalled(viewModel.payType) { return }
        
        HitMessage.showLoading()
        var params = [String: Any]()
        params["schedule_id"] = self.viewModel.scheduleID
        params["user_coupon_id"] = self.viewModel.couponModel?.coupon_code
        params["pay_type"] = self.viewModel.payType.rawValue
        NetWorker.post(ServerURL.SubmitCourseConfirm, params: params, success: { (dataObj) in
            self.shouldClearCoupon = true
            PayManager.shared.toPay(dataObj, buyType: .feeTeamCourse)
        }, error: { (statusCode, message) in
            self.shouldClearCoupon = true
            if statusCode == CustomNetError.NoCardErrorCode {
                self.pay.toBuyCard()
            } else {
                self.showErrorWithMessage(message)
            }
        }, failed: { (error) in
            self.showNetErrorMessage()
        })
    }
    
    
    //MARK: -- table view delegate and data source --
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pay.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return pay.setUpCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return pay.cellHeight(tableView: tableView, indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        pay.selectCell(tableView: tableView, indexPath: indexPath)
    }
}



