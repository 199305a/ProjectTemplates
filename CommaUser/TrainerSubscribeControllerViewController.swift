//
//  TrainerSubscribeControllerViewController.swift
//  CommaUser
//
//  Created by macbook on 2018/11/6.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class TrainerSubscribeControllerViewController: TableController , UITableViewDataSource,PayProtocol, ServiceViewProtocol{
    
    var bottomView: CourseBottomView = CourseBottomView()
    var shouldClearCoupon: Bool = false
    
    var couponVC: CouponListController?
    var trainer_name: String?
    var viewModel = TrainerSubsribeViewModel()

    func refreshPrice() {
        
    }
    
    var validModel: CouponValidModel = CouponValidModel()
    
    init(trainerID: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.trainerID = trainerID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var formatter: DateFormatter = {
        let tmp = DateFormatter.init()
        tmp.dateFormat = "yyyy.MM.dd"
        return tmp
    }()
    
    lazy var dateformatter: DateFormatter = {
        let tmp = DateFormatter.init()
        tmp.dateFormat = "yyyy.MM.dd HH:mm"
        return tmp
    }()
    
    
    let indenter1 = "BigTitleCell"
    let indenter2 = "CourresDetailCell"
    let indenter3 = "ChoosePayCourseCell"
    let TrainerCoursesCellID = "TrainerCoursesCell"
     
    let header = BuyPrivateHeaderView.init(frame: .zero)
    let serviceView = ServiceView.init(height: 67, preMessage: Text.AlreadyReadAndAgree, sufMessage: Text.littleGroupNotenNeedProtocol)
    let bottomBtn = BaseButton ()

    var currentData: (course: BuyPrivateCourseModel?, selectedIndex: Int) = (nil, 0)
    var coursesData: [BuyPrivateCourseModel] {
        return viewModel.dataSource.value.courses
    }
    var selectmodel:TrainerTimeSateModel? {
        didSet {
                bottomBtn.isEnabled = didAgreeProtocol
        }
    }
    


    var didAgreeProtocol = false {
        didSet {
            if self.selectmodel != nil {
                bottomBtn.isEnabled = didAgreeProtocol
            } else {
                bottomBtn.isEnabled = false
            }
            serviceView.selectButton.isSelected = didAgreeProtocol
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomBtn.isEnabled = false
        updateDataFromNet()
        
        removeLoadingObserver()
        // Do any additional setup after loading the view.
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
        tableView.registerClass(ChoosePayCourseCell.self)
        tableView.registerClass(TrainerCoursesCell.self)

        
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
        
        bottomBtn.rx.tap.bind { [weak self] in
            guard let `self` = self else {return}
                HitMessage.showLoading()
                var params = [String: Any]()
                params["gym_id"] = CurrentGymID
             params["course_id"] = self.currentData.course?.course_id.nonOptional
            params["personal_id"] = self.currentData.course?.personal_id.nonOptional
            params["trainer_id"] =  self.viewModel.trainerID!
            params["trainer_name"] =  self.trainer_name.nonOptional
            params["course_name"] =  self.currentData.course?.course_name.nonOptional
            
            
            let startStr:String  =  "\(self.selectmodel!.date!) \(self.selectmodel!.duration!.components(separatedBy: "-").first!)"
            let endStr:String  =  "\(self.selectmodel!.date!) \(self.selectmodel!.duration!.components(separatedBy: "-").last!)"
            let startdate:Date? =  self.dateformatter.date(from: startStr)
            let enddate:Date? =  self.dateformatter.date(from: endStr)
            params["start_time"] = startdate?.timeIntervalSince1970
            params["end_time"] = enddate?.timeIntervalSince1970
            
            
                NetWorker.post(ServerURL.PostTrainerSubscribe, params: params, success: { [weak self] (dataObj) in
                    HitMessage.showSuccessWithMessage("预约成功")
                    
                    guard let `self` = self else {return}
                    if   (dataObj["schedule_id"] != nil)  {
                        
                    let vc = MyTrainerCourseDetailVC()
                        vc.schedule_ID = String(dataObj["schedule_id"] as! Int )
                    GlobalAction.popToRootSecondAndPushToVC(self, destinationVC: vc)
                    }
                    }, error: { (statusCode, message) in
                        self.showErrorWithMessage(message)
                }, failed: { (error) in
                    self.showNetErrorMessage()
                })
            }.disposed(by: disposeBag)
    }
    
    
    func handleData(model: BuyPrivateModel) {
        header.trainerModel = model
        header.nameLabel.text  = self.trainer_name!
        tableView.autoLayoutTableHeaderView(header)
        currentData = (model.courses.first, 0)
        self.tableView.reloadData()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0 ,2,4,6:
            let cell = tableView.dequeueReusableCell(withIdentifier: indenter1, for: indexPath) as! BigTitleCell
            if  indexPath.row == 0 {
                cell.title =  "训练课程"
            }
            if  indexPath.row == 2 {
                cell.title = "预约时间"
            }
            if  indexPath.row == 4 {
                cell.title =  "剩余课时"
            }
            if  indexPath.row == 6 {
                cell.title = "预约说明"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerCoursesCellID, for: indexPath) as! TrainerCoursesCell
            cell.coursesData = coursesData
            cell.click = { [unowned self] model, index in
                self.selectCourse(model: model, index: index)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: indenter3, for: indexPath) as! ChoosePayCourseCell
            cell.couponLabel.text = "选择上课时间"
            if selectmodel != nil {
                cell.detailLabel.text =  "\(selectmodel!.date.nonOptional) / \(selectmodel!.duration.nonOptional)"
            }else {
                cell.detailLabel.text =  ""
            }
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: indenter2, for: indexPath) as! CourresDetailCell
            if  indexPath.row == 5 {
            
                let date:String =    formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval.init(currentData.course?.end_time?.intValue ?? 0)))
               
                cell.titleLabel.text = "剩余\(currentData.course?.remain_times?.intValue ?? 0)节，有效期至\(date)"
            }
            if  indexPath.row ==  7 {
                cell.titleLabel.text = "1. 运动装备：需穿着适合贴身的运动服饰和运动鞋。\n\n2. 饮食：在运动前1小时前可以食用少量食物，进食后1小时之内不要进行运动，运动时需补充水分，建议配备运动饮料。运动前忌讳一次性大量饮水。\n\n3. 课程开始前6小时不可取消预约。"
            }
            return cell
        }
    }
    
    /**
     选择课程
     */
    func selectCourse(model: BuyPrivateCourseModel, index: Int) {
        
        currentData.course = model
        currentData.selectedIndex = index
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0 ,2,4,6:
            return 38
        case 1:
            return 92
        case 3:
            return 54
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            let vc = ChooseSubscribeTimeController.init(trainerID: viewModel.trainerID)
            vc.modelBack = { [weak self] model in
                self?.selectmodel = model
                self?.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: UITableViewRowAnimation.fade)
            }
            self.pushAnimated(vc)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
