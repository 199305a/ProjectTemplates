//
//  TrainerInfoController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//MARK: - 描述 私教课详情
class TrainerInfoController: TableController, UITableViewDataSource {
    let TrainerAvatarCellID = "TrainerAvatarCell"
    let TrainerInfoCellID = "TrainerInfoCell"
    let TrainerTopSetctionCellID = "TrainerTopSetctionCell"
    let TrainerBottomSetctionCellID = "TrainerBottomSetctionCell"
    let TrainerGymCellID = "TrainerGymGroupCell"
    let TrainerCourseCellID = "TrainerCourseCell"
    
    let viewModel = TrainerInfoViewModel()    
    var bottomView = CourseBottomView()
    var paybottomView = CoursePayBottomView()
    let bottomBtn = BaseButton()

    var coursesData: [String] { return viewModel.dataSource.value.courses }
    var gymsData: [GymsModel] {
        return viewModel.dataSource.value.gyms
    }
    var cousesCellCount: Int {
        let amount = coursesData.count
        return amount.isOdd ? ((amount / 2) + 1) : (amount / 2)
    }
    var isShowMoreGyms = false
    
    init(trainerID: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.trainerID = trainerID
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataFromNet()
    }
    
    override func setUpViews() {
        super.setUpViews()
        view.addSubview(paybottomView)
        paybottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(75.addSafeAreaBottom)
        }
        
        if Layout.is_ge_window_5_8_inch {
            paybottomView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(85)
                make.bottom.equalTo(view.snp.bottom)
            }
            
        }
        
        tableView.snp.remakeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(paybottomView.snp.top)
        }
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(60)
        }
        
        if Layout.is_ge_window_5_8_inch {
            bottomBtn.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(85)
                make.bottom.equalTo(view.snp.bottom)
            }
            bottomBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 16, right: 0)
            
        }
        bottomBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx129faa), for: .normal)
        bottomBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx91b6b9), for: .disabled)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.PingFangSCMediumFontOf(size: 20)
        paybottomView.isHidden = true
        bottomBtn.isHidden = true
        
   
    }
    
    override func setUpEvents() {
        
        bottomBtn.rx.tap.bind { [weak self] in
            self?.toCourseInfo()
        }.disposed(by: disposeBag)
        
        paybottomView.payclick = { [unowned self] in
            self.toCourseInfo()
        }
        
        paybottomView.subscibeclick = { [unowned self] in
            let vc = TrainerSubscribeControllerViewController.init(trainerID: self.viewModel.trainerID)
            vc.trainer_name = self.viewModel.dataSource.value.trainer_name
            self.pushAnimated(vc)
        }
        
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.registerClass(TrainerInfoCell.self)
        tableView.registerClass(TrainerAvatarCell.self)
        tableView.registerClass(TrainerTopSetctionCell.self)
        tableView.registerClass(TrainerBottomSetctionCell.self)
        tableView.registerClass(TrainerGymGroupCell.self)
        tableView.registerClass(TrainerCourseCell.self)
        tableView.dataSource = self
        
    }
    
    func handleData(model: TrainerInfoModel) {
        title = model.trainer_name
//        bottomView.contentLabel.text = model.course_price
//        bottomView.button.isEnabled = !model.courses.isEmpty
        
        handleBottomViewText(model: model)

        tableView.reloadData()
        
    }
    
    // 设置脚部数据
    func handleBottomViewText(model: TrainerInfoModel) {
        //        if let bottommodel = model.couser_detail {
        
        if model.subscrible > 0 && !model.courses.isEmpty {
            paybottomView.isHidden = false
            bottomBtn.isHidden = true
        }else {
            paybottomView.isHidden = true
            bottomBtn.isHidden = false
            tableView.snp.remakeConstraints { (make) in
                make.top.left.right.equalTo(view)
                make.bottom.equalTo(bottomBtn.snp.top)
            }
        }
        
        
        bottomBtn.setTitle( model.courses.isEmpty ? Text.NoClass:Text.BuyClass, for: .normal)
        bottomBtn.isEnabled = !model.courses.isEmpty
                
//        paybottomView.subscibeBtn.setTitle(model.orderStatus.text, for: .normal)
//        paybottomView.subscibeBtn.isEnabled = model.orderStatus == .allowToOrder
    }

    
    var reloadDataTimer: Timer?
    var reloadDataCountDown = 0.0
    func showAllGymsOrNot() {
        tableView.reloadData()
    }
    
    func toCourseInfo() {
        
        guard GlobalAction.isLogin else {
            Jumper.jumpToLogin()
            return
        }
        
        
        let vc = BuyPrivateController(trainerID: self.viewModel.trainerID)
        vc.traienrName = self.viewModel.dataSource.value.trainer_name
        self.pushAnimated(vc)
    }
    
    // MARK: - table view data sources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int
        switch section {
        case 0, 1, 2 :
            count = 1
        case 3:
            count = viewModel.dataSource.value.courses.isEmpty ? 0 : cousesCellCount + 2
        default:
            count = 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerAvatarCellID, for: indexPath) as! TrainerAvatarCell
            cell.dataSource = viewModel.dataSource.value
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerInfoCellID, for: indexPath) as! TrainerInfoCell
            cell.dataSource = viewModel.dataSource.value
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerGymCellID, for: indexPath) as! TrainerGymGroupCell
            cell.click = { [unowned self] in
                self.isShowMoreGyms = !self.isShowMoreGyms
                cell.isShowMore = self.isShowMoreGyms
                let contentOffset = tableView.contentOffset
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                if #available(iOS 11.3, *) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.tableView.contentOffset = contentOffset
                    })
                }
                
            }
            cell.gyms = gymsData
            cell.isShowMore = isShowMoreGyms
            return cell
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TrainerTopSetctionCellID, for: indexPath) as! TrainerTopSetctionCell
                cell.titleLabel.text = "训练课程"
                cell.detailLabel.text = nil
                cell.button.isHidden = true
                cell.click = nil
                if coursesData.isEmpty {
                    cell.titleLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(26)
                    }
                }
                return cell
            } else if indexPath.row == cousesCellCount + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TrainerBottomSetctionCellID, for: indexPath) as! TrainerBottomSetctionCell
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainerCourseCellID, for: indexPath) as! TrainerCourseCell
            cell.setUp(courses: coursesData, tag: indexPath.row - 1)
            return cell
        default:
            return UITableViewCell()
        }
    }
        
}

