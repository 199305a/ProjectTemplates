//
//  BuyPrivateController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - 描述 购买私教课
class BuyPrivateController: TableController, UITableViewDataSource, UICollectionViewDelegateFlowLayout, PayProtocol, ServiceViewProtocol {
    
    let viewModel = BuyPrivateViewModel()
    
    let TrainerCoursesCellID = "TrainerCoursesCell"
    let TrainerCoursesCountCellID = "TrainerCoursesCountCell"
    
    var currentData: (course: BuyPrivateCourseModel?, selectedIndex: Int) = (nil, 0)
    var coursesData: [BuyPrivateCourseModel] {
        return viewModel.dataSource.value.courses
    }
    
    let bottomView = CourseBottomView()
    let header = BuyPrivateHeaderView.init(frame: .zero)
    lazy var couponVC: CouponListController? = CouponListController()
    
    var buttonClickTimes = InvalidInteger
    
    var shouldClearCoupon = false  //是否需要清除优惠券
    var reCalculateEnable = true // 是否可以进行课程加减操作
    var didAgreeProtocol = false { // 是否选中了同意协议
        didSet {
            bottomView.canUse = didAgreeProtocol
            serviceView.selectButton.isSelected = didAgreeProtocol
        }
    }
    
    let serviceView = ServiceView.init(height: 67, preMessage: Text.AlreadyReadAndAgree, sufMessage: Text.PrivateMemberProtocol)
    
    var traienrName: String?
    
    var validModel: CouponValidModel {
        return CouponValidModel.with(gymID: CurrentGymID, amount: coursesData[safe:  currentData.selectedIndex]?.current_priceTime.price, type: .privateClass, subID: currentData.course?.course_personal_id)
    }
    
    init(trainerID: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.trainerID = trainerID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromNet()
        customizeBackgroundView()
        bottomView.canUse = false
    }
    
    override func customizeBackgroundView() {
        errorBackgroundView.buttonClick = { [unowned self] style in
            switch style {
            case .noWifi:
                // 如果是一开始进来就没网，是这个
                if self.coursesData.isEmpty {
                    self.updateDataFromNet()
                    return
                }
                // 如果点击cell是这个
                if self.buttonClickTimes != InvalidInteger {
                    guard let course = self.currentData.course else { return }
                    self.recalculateFromeButtonClick(model: course, times: self.buttonClickTimes)
                    return
                }
                // 如果是点击没网是这个
                let model = self.coursesData[self.currentData.selectedIndex]
                self.selectCourse(model: model, index: self.currentData.selectedIndex)
            default:
                break
            }
        }
    }
    
    
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.ConfirmAppoint
        bottomView.button.setTitle(Text.SureBuyCard, for: .normal)
        pay.relayoutTableView()
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.dataSource = self
        tableView.tableHeaderView = header
        tableView.registerClass(TrainerCoursesCell.self)
        tableView.registerClass(TrainerCoursesCountCell.self)
        pay.commonHandleTableView()
    }
    
    override func setUpEvents() {
        
        pay.setUpServiceView(type: .privateClass)
        pay.registNotification(destinationVC: MyClassesController(classType: .trainer))
        
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
        bottomView.click = { [unowned self] in
            self.toBuyPrivate()
        }
    }
    
    func handleData(model: BuyPrivateModel) {
        model.trainer_name = traienrName
        // 从服务器获取新的数据后，当前次数即为最小次数
        model.courses.forEach { data in
            data.current_times = data.min_times
        }
        // 设置header数据和样式
        header.trainerModel = model
        tableView.autoLayoutTableHeaderView(header)
        // 设置数据
        model.courses.first?.current_priceTime.price = model.courses.first?.price
        model.courses.first?.current_priceTime.end_time = model.end_time
        // 记录当前选中的index
        currentData = (model.courses.first, 0)
        // 刷表
        reloadData()
    }
    
    func refreshPrice() {
        bottomView.contentLabel.attributedText = PayFomatter.commaPriceWith￥(coursesData[safe:  currentData.selectedIndex]?.current_priceTime.price, discount: viewModel.couponModel?.price)
        bottomView.detailLabel.text = PayFomatter.discountFormat(viewModel.couponModel?.price?.commasString)
    }
    
    
    /**
     选择课程
     */
    func selectCourse(model: BuyPrivateCourseModel, index: Int) {
        
        currentData.course = model
        currentData.selectedIndex = index
        // 如果选中新的课程，去刷新最小购买次数
        if  model.current_priceTime.isNew {
            self.reCalculateAmount(model: model, times: model.min_times)
        } else {
            reloadData()
        }
        
    }
    
    
    func reloadData() {
        clearCoupon()
    }
    
    
    /**
     重新计算课程价格
     */
    func reCalculateAmount(model: BuyPrivateCourseModel, times: Int) {
        
        guard let id = self.currentData.course?.course_personal_id else {
            self.showInfoWithMessage(Text.ChooseFirst)
            return
        }
        
        reCalculateEnable = false
        // loading
        let hud = LFMProgressHUD.init(view: view)
        view.addSubview(hud)
        hud.show(animated: true)
        
        NetWorker.get(ServerURL.Calculate, params: ["course_personal_id": id, "number": times], success: { (dataObj) in
            self.reCalculateEnable = true
            self.reCalculateAmountSuccess(dataObj: dataObj, times: times)
        }, error: { (statusCode, message) in
            self.reCalculateEnable = true
            self.showErrorWithMessage(message)
        }) { (error) in
            self.reCalculateEnable = true
            self.showNetErrorMessage()
        }
    }
    
    func reCalculateAmountSuccess(dataObj: [String: AnyObject], times: Int) {
        self.dismissHUD()
        let new = TrainerCourseNewPriceTimeModel.parse(dict: dataObj)
        self.currentData.course?.current_priceTime = new // 设置新的有效期和价格
        self.currentData.course?.current_times = times // 设置当前购买次数
        self.reloadData()
        // 去掉error view
        if self.viewModel.errorViewStyle.value != .noError {
            self.viewModel.errorViewStyle.value = .noError
        }
        // 去掉来自button点击
        self.buttonClickTimes = InvalidInteger
    }
    
    
    // 选择新的课程数
    func calculateButtonClick(type: TrainerCourseCalculateType) {
        guard reCalculateEnable,
            let model = currentData.course
            else {
                return
        }
        let times = model.current_times
        switch type {
        case .plus:
            plusCourse(model: model, times: times)
        case .manualInput:
            customTimesCourse(model: model, times: times)
        case .minus:
            minusCourse(model: model, times: times)
        }
    }
    
    func recalculateFromeButtonClick(model: BuyPrivateCourseModel, times: Int) {
        buttonClickTimes = times
        reCalculateAmount(model: model, times: times)
    }
    
    func plusCourse(model: BuyPrivateCourseModel, times: Int) {
        guard times + 1 <= model.max_times else {
            showErrorWithMessage(Text.OnceBuy + "\(model.max_times)" + Text.ClassUnit)
            return
        }
        recalculateFromeButtonClick(model: model, times: times + 1)
    }
    
    func minusCourse(model: BuyPrivateCourseModel, times: Int) {
        guard times - 1 >= model.min_times else {
            self.showErrorWithMessage(Text.LeastBuy + "\(model.min_times)" + Text.ClassUnit)
            return
        }
        buttonClickTimes = times
        recalculateFromeButtonClick(model: model, times: times - 1)
    }
    
    func customTimesCourse(model: BuyPrivateCourseModel, times: Int) {
        let message = "购买课程数不少于" + String(model.min_times) + "次，不大于" + String(model.max_times) + "次"
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = SDK_Over_iOS10 ? .numberPad : .phonePad
            textField.placeholder = Text.RangeWarning
            textField.textAlignment = .center
            textField.textColor = UIColor.hx5c5e6b
        }
        let action = UIAlertAction.init(title: Text.Sure, style: .default) { _ in
            let word = alert.textFields?.first?.text
            guard let text = word else {
                self.showErrorWithMessage(Text.RangeWarning)
                return
            }
            guard text.inRange(model.min_times - 1, max: model.max_times + 1) else {
                self.showErrorWithMessage(Text.RangeWarning)
                return
            }
            guard let value = text.intValue else {
                self.showErrorWithMessage(Text.RangeWarning)
                return
            }
            
            self.recalculateFromeButtonClick(model: model, times: value)
        }
        let cancel = UIAlertAction.init(title: Text.Cancel, style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func toBuyPrivate() {
        
        guard didAgreeProtocol else {
            let alert = LFAlertView.init(title: Text.Reminding, message: Text.ReadTrainerProtocolFirst, items: [Text.Sure])
            alert.show()
            return
        }
        
        guard self.currentData.course != nil else {
            self.showInfoWithMessage(Text.ChooseFirst)
            return
        }
        if !PayManager.isWxPayInstalled(viewModel.payType) { return }
        
        
        guard let id = currentData.course?.course_personal_id else {
            showServerErrorMessage()
            return
        }
        
        HitMessage.showLoading()
        var params = [String: Any]()
        params["course_personal_id"] = id
        params["user_coupon_id"] = viewModel.couponModel?.coupon_code
        params["pay_type"] = viewModel.payType.rawValue
        params["number"] = currentData.course?.current_times
        params["course_name"] = currentData.course?.course_name
        params["trainer_id"] = viewModel.trainerID
        params["trainer_name"] = traienrName
        params["gym_name"] = CurrentGym.gym_name

        NetWorker.post(ServerURL.TrainerPay, params: params, success: { (dataObj) in
            //需要清除优惠券
            self.shouldClearCoupon = true
            PayManager.shared.toPay(dataObj, buyType: .privateClass)
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
        return section == 0 ? 4 : pay.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            return pay.setUpCell(tableView: tableView, indexPath: indexPath)
        }
        
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerCoursesCellID, for: indexPath) as! TrainerCoursesCell
            cell.coursesData = coursesData
            cell.click = { [unowned self] model, index in
                self.selectCourse(model: model, index: index)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerCoursesCountCellID, for: indexPath) as! TrainerCoursesCountCell
            cell.currentCourse = currentData.course
            cell.click = { [unowned self] type in
                self.calculateButtonClick(type: type)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: BigTitleCellID, for: indexPath) as! BigTitleCell
            cell.title = indexPath.row == 0 ? "训练课程" : "上课次数"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return pay.cellHeight(tableView: tableView, indexPath: indexPath)
        }
        
        let height: CGFloat
        switch indexPath.row {
        case 1:
            height = 92
        case 3:
            height = 111
        default:
            height = 38
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 1 {
            return pay.selectCell(tableView: tableView, indexPath: indexPath)
        }
    }
}

