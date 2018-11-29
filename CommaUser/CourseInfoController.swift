//
//  CourseInfoController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//MARK: - 描述 团体课详情
class CourseInfoController: TableController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource {

    
    let reuseIdentifier0 = "CourseInfoCell"
    let collectionReuseIdentifier = "ImageCell"
    
    let viewModel = CourseInfoViewModel()
    var bottomView = CourseBottomView()
    var paybottomView = CoursePayBottomView()

    let header = CourseInfoHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 424))
    let footer = CourseInfoFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 220))
    
    var classType: ClassType!
    var scheduleID:String!
    
    let bottomBtn = BaseButton()
    
    init(classType: ClassType = .group,scheduleID: String?) {
        super.init(nibName: nil, bundle: nil)
        self.classType = classType
        viewModel.scheduleID = scheduleID
        self.scheduleID = scheduleID
       header.classtype = self.classType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TingYunSDKManager.beginTracer("CourseInfoController")
        
        NBSAppAgent.leaveBreadcrumb("CourseInfoController")
        NBSAppAgent.trackEvent("CourseInfoControllerin")
        NBSAppAgent.setCustomerData("CourseInfoControllerin", forKey: "CourseInfoControllerin")
        TingYunSDKManager.endTracer("CourseInfoController")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataFromNet()
    }
    
    
    
    override func setUpViews() {
        super.setUpViews()
//        bottomView = CoursePayBottomView()
        if self.classType! == ClassType.littleGroup {
            
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
            
           paybottomView.isHidden = true
            bottomBtn.isHidden = true
        }else {
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
            
            
            tableView.snp.remakeConstraints { (make) in
                make.top.left.right.equalTo(view)
                make.bottom.equalTo(bottomBtn.snp.top)
            }
        }
        
        bottomBtn.setTitle(Text.SureBooking, for: .normal)
        bottomBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx129faa), for: .normal)
        bottomBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.hx91b6b9), for: .disabled)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.PingFangSCMediumFontOf(size: 20)
        
        bottomBtn.rx.tap.bind { [weak self] in
            guard let `self` = self else {return}
            if self.classType ==   ClassType.littleGroup {
                LFProgressHUD.showLoading(self.view)
                self.viewModel.getPriceListWithScheduleID(success: { (dataObj) in
                    self.dismissHUD()
                    let model = CourseMemberModel.parse(dict: dataObj)
                    let vc = CourseBuyLittleGroupController.init(scheduleID: self.scheduleID)
                    vc.viewModel.dataSource.value = self.viewModel.dataSource.value
                    vc.viewModel.priceListSource.value = model
                    self.pushAnimated(vc)
                }, error: { (code, msg) in
                    self.showErrorWithMessage(msg)
                }, failed: { (errro) in
                    self.showNetErrorMessage()
                })
                }else {
                let vc = CourseSubscirbeLittleController.init(classType: ClassType.group, scheduleID:  self.scheduleID)
                vc.viewModel.dataSource.value = self.viewModel.dataSource.value
                self.pushAnimated(vc)
            }

            }.disposed(by: disposeBag)
        
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(CourseInfoCell.self)
        tableView.autoLayoutTableHeaderView(header)
        tableView.tableFooterView = footer
        tableView.estimatedRowHeight = EstimatedRowHeight
        footer.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: collectionReuseIdentifier)
        viewModel.collectionDataSource.asObservable().bind(to: footer.collectionView.rx.items(cellIdentifier: collectionReuseIdentifier, cellType: ImageCell.self)) {
            row, model, cell in
            cell.model = model
            }.disposed(by: disposeBag)
    }
    
    override func setUpEvents() {
        
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        

        
        paybottomView.payclick = { [unowned self] in
              LFProgressHUD.showLoading(self.view)
            self.viewModel.getPriceListWithScheduleID(success: { (dataObj) in
                 self.dismissHUD()
                let model = CourseMemberModel.parse(dict: dataObj)
                let vc = CourseBuyLittleGroupController.init(scheduleID: self.scheduleID)
                vc.viewModel.dataSource.value = self.viewModel.dataSource.value
                vc.viewModel.priceListSource.value = model
                self.pushAnimated(vc)
            }, error: { (code, msg) in
                self.showErrorWithMessage(msg)
            }, failed: { (errro) in
                self.showNetErrorMessage()
            })

        }
        
        paybottomView.subscibeclick = { [unowned self] in
            let vc = CourseSubscirbeLittleController.init(classType: ClassType.littleGroup, scheduleID:  self.scheduleID)
            vc.viewModel.dataSource.value = self.viewModel.dataSource.value
            self.pushAnimated(vc)
        }
            
        footer.click = { [unowned self] in
            guard let id = self.viewModel.dataSource.value.gym_id else {
                return
            }
            let vc = StoreController.init(gymID: id)
            self.pushAnimated(vc)
        }
        
    }
    
    func handleData(model: CourseItemInfoModel) {
        title = model.course_name
        header.model = model
        tableView.autoLayoutTableHeaderView(header)
        handleBottomViewText(model: model)
        tableView.reloadData()
    }
    
    // 设置脚部数据
    func handleBottomViewText(model: CourseItemInfoModel) {
//        if let bottommodel = model.couser_detail {
        
            if model.surplus_course?.intValue ?? 0 > 0 {
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
        
        bottomBtn.setTitle(Text.BuyClass, for: .normal)
        bottomBtn.isEnabled = true
        if self.classType == ClassType.group {
        bottomBtn.isHidden = false
        bottomBtn.setTitle(model.orderStatus.text, for: .normal)
        bottomBtn.isEnabled = model.orderStatus == .allowToOrder
        }
        

        paybottomView.subscibeBtn.setTitle(model.orderStatus.text, for: .normal)
        paybottomView.subscibeBtn.isEnabled = model.orderStatus == .allowToOrder
//        }
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
    
    // MARK: - table view data sources.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier0, for: indexPath) as! CourseInfoCell
        cell.model = viewModel.dataSource.value
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

