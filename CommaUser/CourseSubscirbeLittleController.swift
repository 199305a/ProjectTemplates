//
//  CourseSubscirbeLittleController.swift
//  CommaUser
//
//  Created by macbook on 2018/10/23.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CourseSubscirbeLittleController:  TableController, UITableViewDataSource,PayProtocol, ServiceViewProtocol {
    var bottomView: CourseBottomView = CourseBottomView()
    var shouldClearCoupon: Bool = false
    
    var couponVC: CouponListController?
    
    func refreshPrice() {
        
    }
    
    var validModel: CouponValidModel = CouponValidModel()
    
    lazy var formatter: DateFormatter = {
        let tmp = DateFormatter.init()
        tmp.dateFormat = "yyyy.MM.dd"
        return tmp
    }()
    
    
    let viewModel = CourseInfoViewModel()
    let indenter1 = "BigTitleCell"
    let indenter2 = "CourresDetailCell"
    let header = BuyTeamCourseHeaderView(frame: CGRectMake(0, 0, Layout.ScreenWidth, 330))
    let serviceView = ServiceView.init(height: 67, preMessage: Text.AlreadyReadAndAgree, sufMessage: Text.littleGroupNotenNeedProtocol)


    let bottomBtn = BaseButton ()

    var didAgreeProtocol = false {
        didSet {
            bottomBtn.isEnabled = didAgreeProtocol
            serviceView.selectButton.isSelected = didAgreeProtocol
        }
    }
    
var classType: ClassType!
    init(classType: ClassType = .group,scheduleID: String?) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.scheduleID = scheduleID
        self.classType = classType
        header.classtype = ClassType.littleGroup
        header.avarImg.isHidden = true
        header.line.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         bottomBtn.isEnabled = false
        updateDataFromNet()
        
        TingYunSDKManager.beginTracer("CourseSubscirbeLittleController")
        
        NBSAppAgent.leaveBreadcrumb("CourseSubscirbeLittleController")
        NBSAppAgent.trackEvent("viewDidLoad")
        NBSAppAgent.setCustomerData("CourseSubscirbeLittleController", forKey: "CourseSubscirbeLittleController")
        
        TingYunSDKManager.endTracer("CourseSubscirbeLittleControllerr")
        
        
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.SureBooking
        pay.setUpServiceView(type: .notelittleGroupCourse)
        pay.commonHandleTableView()

        
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.dataSource = self
        tableView.tableHeaderView = header
        tableView.registerClass(BigTitleCell.self)
        tableView.registerClass(CourresDetailCell.self)
        
        
        bottomBtn.setTitle(Text.SureBooking, for: .normal)
        bottomBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx129faa), for: .normal)
        bottomBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx91b6b9), for: .disabled)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.PingFangSCMediumFontOf(size: 20)
        
        self.view.addSubview(bottomBtn)
        
        
        
        bottomBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(60)
            make.bottom.equalTo(0)
        }
        
        if Layout.is_ge_window_5_8_inch {
            bottomBtn.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(85)
                make.bottom.equalTo(view.snp.bottom)
            }
            bottomBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 16, right: 0)

        }
        
        tableView.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(bottomBtn.snp.top)
        }
        
    }
    
    override func setUpEvents() {
    
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
        bottomBtn.rx.tap.bind {  [weak self] in
            guard let `self` = self else {return}
            if self.classType == .group {
                if self.viewModel.dataSource.value.isFee {
                    self.toBuyFeeCourse()
                } else {
                    self.orderCourse()
                }
            }else {
            HitMessage.showLoading()
            var params = [String: Any]()
            params["schedule_id"] = self.viewModel.scheduleID
            NetWorker.post(ServerURL.SubscribeCoursesInfo, params: params, success: { [weak self] (dataObj) in
                HitMessage.showSuccessWithMessage("预约成功")
                if   (dataObj["schedule_id"] != nil)  {
                guard let `self` = self else {return}
                    let vc = MyTeamCourseDetailVC()
                    vc.schedule_ID = "\(dataObj["schedule_id"])"
                GlobalAction.popToRootThridAndPushToVC(self, destinationVC: vc)
                }
            }, error: { (statusCode, message) in
              self.showErrorWithMessage(message)
            }, failed: { (error) in
                self.showNetErrorMessage()
            })
            }
        }.disposed(by: disposeBag)
    }
    
    func handleData(model: CourseItemInfoModel) {
        header.model = model
        tableView.autoLayoutTableHeaderView(header)
        self.tableView.reloadData()
    }
    
    /**
     预约团体课
     */
    func orderCourse() {
        guard GlobalAction.isLogin else {
            Jumper.jumpToLogin()
            return
        }
        
        guard let id = viewModel.scheduleID else {
            showServerErrorMessage()
            return
        }
        
        self.showLoading()
        NetWorker.post(ServerURL.OrderFreeCourse, params: ["schedule_id": id], success: { (dataObj) in
            GlobalAction.handleWhenSuccess {
                if   (dataObj["schedule_id"] != nil)  {

                let vc = MyTeamCourseDetailVC()
                    vc.schedule_ID = "\(dataObj["schedule_id"])"
                GlobalAction.popToRootThridAndPushToVC(self, destinationVC: vc)
                    
                }
            }
        }, error: { (statusCode, message) in
            if statusCode == CustomNetError.NoCardErrorCode {
                self.hasNocardToBuy()
            } else {
                self.showErrorWithMessage(message)
            }
            
        }) { (error) in
            self.showNetErrorMessage()
        }
    }
    
    /**
     去买收费团体课
     */
    func toBuyFeeCourse() {
        guard GlobalAction.isLogin else {
            Jumper.jumpToLogin()
            return
        }
        let vc = BuyTeamCourseController.init(scheduleID: viewModel.scheduleID)
        pushAnimated(vc)
    }
    
    /**
     没卡去买卡
     */
    func hasNocardToBuy() {
        dismissHUD()
        let alert = LFAlertView.init(title: nil, message: Text.OnlyMemberCanBooking, items: [Text.OK, Text.ToBuyCard])
        alert.show()
        alert.action = { [weak self] index in
            guard index != 0 else { return }
            self?.pushAnimated(CardsListController())
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0 ,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: indenter1, for: indexPath) as! BigTitleCell
            if  indexPath.row == 0 {
                cell.title =  self.classType == .littleGroup ? "剩余课时" : ""
            }
            if  indexPath.row == 2 {
                cell.title = "预约说明"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: indenter2, for: indexPath) as! CourresDetailCell
            if  indexPath.row == 1 {
                let date:String =    formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval.init(viewModel.dataSource.value.surplus_course_deadline?.intValue ?? 0)))
                cell.titleLabel.text = "剩余\(viewModel.dataSource.value.surplus_course?.intValue ?? 0)节，有效期至\(date)"
            }
            if  indexPath.row ==  3 {
                cell.titleLabel.text = "1. 运动装备：需穿着适合贴身的运动服饰和运动鞋。\n\n2. 饮食：在运动前1小时前可以食用少量食物，进食后1小时之内不要进行运动，运动时需补充水分，建议配备运动饮料。运动前忌讳一次性大量饮水。\n\n3. 课程开始前6小时不可取消预约。"
            }
            
            return cell
        }


       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.classType == .group {
            switch indexPath.row {
            case 0 ,1:
                return 0
            case 2:
                return 38
            default:
                return UITableViewAutomaticDimension
            }

        }
        switch indexPath.row {
        case 0 ,2:
            return 38
        default:
            return UITableViewAutomaticDimension
        }
    }
}

class CourresDetailCell: BaseTableViewCell {
    override func customizeInterface() {
        titleLabel = BaseLabel()
        
        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.font15)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(5)
            make.bottom.equalTo(-15)
        }
    }
}
