//
//  MyTrainingController.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/19.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - 我的训练
class MyTrainingController: TableController, CustomNavBarCompatible, UITableViewDataSource {
    
    let reuseIdentifier = "MyTrainingCell"
    let topView = MyTrainingTopView()
    let header = MyTrainingHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeLoadingObserver()
        customizeNavigationBar()
        handleNaviColorWhenError()
        changeTintColorWhenAppearOrNot()
        dynamicCustomImageView(image: UIImage.init(named: "training_background"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleBluetoothConnect()
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.MyTraining
        view.insertSubview(topView, belowSubview: tableView)
        view.backgroundColor = UIColor.backgroundColor
        tableView.backgroundColor = UIColor.clear
        topView.frame = CGRectMake(0, 0, Layout.ScreenWidth, 315)
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(MyTrainingCell.self)
        tableView.rx.setDataSource(self).disposed(by: disposeBag)
        tableView.rowHeight = 175
        tableView.tableHeaderView = header
        
        tableView.rx.contentOffset.bind { [unowned self] point in
            self.topView.frame.origin.y = min(-point.y, 0)
            }.disposed(by: disposeBag)
    }
    
    override func setUpEvents() {
        
        NotificationCenter.default.rx.notification(NotiKey.LogoutSuccess).bind { [unowned self] _ in
            self.handleEventWhenLogout()
            }.disposed(by: disposeBag)
        
        header.button.rx.tap.bind { [unowned self] in
            let vc = BraceletHistoryDataController()
            vc.hidesBottomBarWhenPushed = true
            self.pushAnimated(vc)
        }.disposed(by: disposeBag)
        
        BraceletManager.shared.isConnect.asObservable().bind { [weak self] (isConnect) in
            self?.topView.statusLabel.isHidden = isConnect
            if self?.topView.measureData == nil, let mac = BraceletManager.shared.bracelet?.bracelet_mac {
                self?.topView.measureData = DataStoreManager.shared.getTodayLastBraceletData(mac: mac)
            }
        }.disposed(by: disposeBag)
        
        BraceletManager.shared.connectStatus.asObservable().bind { (state) in
            self.topView.statusLabel.text = "(\(state.description))" 
        }.disposed(by: disposeBag)
        
        BluetoothManager.shared.isBluetoothStateOpen.asObservable().bind { [weak self] (isOpen) in
            self?.handleBluetoothConnect()
        }.disposed(by: disposeBag)
        
        BraceletManager.shared.measureDataReceived.asObservable().bind { [weak self] (data) in
            self?.topView.measureData = data
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotiKey.LoginSuccess, object: nil).bind { (_) in
            self.handleBluetoothConnect()
        }.disposed(by: disposeBag)
    }
    
    // 退出登录后的操作
    func handleEventWhenLogout() {
        tableView.setContentOffset(CGPoint(x: 0, y: 1), animated: true)
        dropNewUsersInfoInput()
        topView.reset()
    }
    
    // 如果是新用户退出登录，去掉他的个人信息填写页面
    func dropNewUsersInfoInput() {
        if let vc = APP.tabBarController.presentedViewController as? CompleteNavController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTrainingCell
        cell.setUp(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = BodyTestInfoController()
            toVCAndNeedLogin(vc)
        } else {
            let vc = SportListContainerController()
            toVCAndNeedLogin(vc)
        }
    }
    
    func toVCAndNeedLogin(_ viewController: UIViewController) {
        guard GlobalAction.isLogin else {
            Jumper.jumpToLogin()
            return
        }
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func handleBluetoothConnect() {
        guard let bracelet = BraceletManager.shared.bracelet, bracelet.isBind else {
            return
        }
        if BluetoothManager.shared.isBluetoothStateOpen.value {
            if !BraceletManager.shared.isConnect.value && BraceletManager.shared.isWorkFree {
                BraceletManager.shared.searchAndConnect()
            }
        } else {
            self.alertToOpenBluetooth()
        }
    }
    
}


class MyTrainingHeaderView: BaseView {
    
    var button = BaseButton()
    
    override func customizeInterface() {
        frame = CGRectMake(0, 0, Layout.ScreenWidth, 262)
        backgroundColor = UIColor.clear
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(95)
            make.right.equalTo(self).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(105)
        }
    }
}
