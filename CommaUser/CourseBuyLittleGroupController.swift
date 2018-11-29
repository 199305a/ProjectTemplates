//
//  CourseBuyLittleGroupController.swift
//  CommaUser
//
//  Created by macbook on 2018/10/22.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CourseBuyLittleGroupController: TableController, UITableViewDataSource, PayProtocol, ServiceViewProtocol {


    
    
    let viewModel = CourseInfoViewModel()
    let bottomView = CourseBottomView()
    let indenter1 = "BigTitleCell"
    let indenter2 = "ChoosePayCourseCell"
    
    lazy var bottomPushView = CourseContentBottomPushView()
    

    
    var selectModel:CourseMemberinfoModel!
    
    let header = BuyTeamCourseHeaderView(frame: CGRectMake(0, 0, Layout.ScreenWidth, 330))
    let serviceView = ServiceView.init(height: 67, preMessage: Text.AlreadyReadAndAgree, sufMessage: Text.littleGroupCourseMemberProtocol)
    lazy var couponVC: CouponListController? = CouponListController()
    var shouldClearCoupon = false  //是否需要清除优惠券
    var didAgreeProtocol = false {
        didSet {
            bottomView.canUse = didAgreeProtocol
            serviceView.selectButton.isSelected = didAgreeProtocol
        }
    }
    
    var validModel: CouponValidModel {
        return CouponValidModel.with(gymID: CurrentGymID, amount: viewModel.dataSource.value.course_price, type: .littleGroupCourse, subID: viewModel.scheduleID)
    }
    
    init(scheduleID: String?) {
        super.init(nibName: nil, bundle: nil)
        viewModel.scheduleID = scheduleID 
        header.classtype = ClassType.littleGroup
        header.avarImg.isHidden = true
        header.line.isHidden = true
        
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
        title = Text.SureBuyCard
        bottomView.button.setTitle(Text.SureBuyCard, for: .normal)
        pay.relayoutTableView()
        if Layout.is_ge_window_5_8_inch {
            bottomView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(85)
                make.bottom.equalTo(view.snp.bottom)
            }

            tableView.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(0)
                make.bottom.equalTo(bottomView.snp.top)
            }
            
        }
        

    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.dataSource = self
        tableView.tableHeaderView = header
        tableView.registerClass(ChoosePayCourseCell.self)

        pay.commonHandleTableView()
    }
    
 
    func registNotification(success: EmptyClosure? = nil) {
        
        NotificationCenter.default.rx.notification(NotiKey.PayDone).bind { [unowned self] noti in
            let isPaySuccess = noti.object as! Bool
            if isPaySuccess {
                success?()
                self.navigationController?.popViewController(animated: true)
            }
            if !isPaySuccess {
                self.clearCoupon()
            }
            
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationWillEnterForeground).bind { [unowned self] noti in
            if self.shouldClearCoupon {
                self.clearCoupon()
            }
            }.disposed(by: disposeBag)
    }
    
    override func setUpEvents() {
        
        pay.setUpServiceView(type: .littleGroupCourse)
 
        self.registNotification()
        
        bottomView.click = { [unowned self] in
            self.toBuyCourse()
        }
        
        bottomPushView.model =  viewModel.dataSource.value
        bottomPushView.memModel = viewModel.priceListSource.value
        if let model = bottomPushView.memModel?.times.first {
            model.selected = true
            self.selectModel = model
        
        }
       
        bottomPushView.itemClick = {[weak self]  in
            self?.viewModel.priceListSource.value = self?.bottomPushView.memModel ?? CourseMemberModel()
           self?.selectModel = self?.bottomPushView.selectModel
            self?.refreshPrice()
            self?.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: UITableViewRowAnimation.fade)
        }
       
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
    }
    
    func handleData(model: CourseItemInfoModel) {
        header.model = model
        tableView.autoLayoutTableHeaderView(header)
        self.tableView.reloadData()
        refreshPrice()
    }
    
    func refreshPrice() {
        var text = "0"
        if selectModel.title.nonOptional == "year" {
            text =  "\(selectModel.price.nonOptional)"
        }else {
            text =  "\((selectModel.price?.intValue ?? 0) * (selectModel.title?.intValue ?? 0))"
        }
        
        bottomView.contentLabel.attributedText = PayFomatter.commaPriceWith￥(text, discount: viewModel.couponModel?.price)
        if viewModel.couponModel?.price != nil {
             bottomView.detailLabel.isHidden = false
        }else {
            bottomView.detailLabel.isHidden = true
        }
        bottomView.detailLabel.text = PayFomatter.discountFormat(text.commasString)
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
            let alert = LFAlertView.init(title: Text.Reminding, message: Text.ReadlitteCourseProtocolFirst, items: [Text.Sure])
            alert.show()
            return
        }
        
        if !PayManager.isWxPayInstalled(viewModel.payType) { return }
        
        HitMessage.showLoading()
        var params = [String: Any]()
        params["number"] = selectModel.title.nonOptional
        params["course_team_id"] = self.viewModel.scheduleID
        params["gym_id"] = CurrentGymID
        params["user_coupon_id"] = self.viewModel.couponModel?.coupon_code
        params["pay_type"] = self.viewModel.payType.rawValue
        NetWorker.post(ServerURL.BuyLittleGroupCourse, params: params, success: { (dataObj) in
            self.shouldClearCoupon = true
            PayManager.shared.toPay(dataObj, buyType: .littleGroupCourse)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
         case 0:
            return 2
        default:
            return pay.sectionCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
        return pay.setUpCell(tableView: tableView, indexPath: indexPath)
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: indenter1, for: indexPath) as! BigTitleCell
            cell.title = "购买次数"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: indenter2, for: indexPath) as! ChoosePayCourseCell
        if selectModel.title.nonOptional == "year" {
            cell.detailLabel.text =  "不限次数/年  \(selectModel.price.nonOptional)元"
        }else {
         cell.detailLabel.text =  "\(selectModel.title.nonOptional)节  \(selectModel.price.nonOptional)元/课时"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 38
            default:
                return 54
            }
        }
        return pay.cellHeight(tableView: tableView, indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 1 {
        pay.selectCell(tableView: tableView, indexPath: indexPath)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            if self.bottomPushView.isShow {
            
                self.bottomPushView.animate(false)
            }else {
                self.bottomPushView.showInView(self.view)
            }
        }
}
    
}
