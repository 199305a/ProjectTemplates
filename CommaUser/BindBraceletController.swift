//
//  BindBraceletController.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/17.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import CoreBluetooth
//MARK: - 搜索绑定手环
class BindBraceletController: BaseController {
    
    let animateView = BluetoothSearchAnimateView(frame: CGRect(x: 0, y: 0, width: 120.layout, height: 120.layout))
    let stateView = BluetoothStatusView()
    let searchSuccessView = SearchSuccessView()
    let bindSuccessView = BindSuccessView()

    var resultDevice: LSDeviceInfo? {
        return BraceletManager.shared.device
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(color: UIColor.clear)
        edgesForExtendedLayout = .all
        navigationController?.navigationBar.shadowImage = UIImage()
        
        BraceletManager.shared.upgradeEnable = false
        BluetoothManager.shared.isBluetoothStateOpen.asObservable().bind { [weak self] (isOpen) in
            if isOpen {
                self?.searchDevice()
            } else {
                BraceletManager.shared.stopSearch()
                self?.alertToOpenBluetooth()
                self?.stateView.status.value = .fail
            }
        }.disposed(by: disposeBag)
        
        //监测APP的状态
        NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationWillEnterForeground).bind { [unowned self] (noti) in
            if self.stateView.status.value == .ongoing && BluetoothManager.shared.isBluetoothStateOpen.value {
                self.animateView.animateStart()
            }
            }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        navigationController?.navigationBar.backIndicatorImage = UIImage.init(named: "back-white")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "back-white")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        navigationController?.navigationBar.backIndicatorImage = UIImage.init(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
    }
    
    
    override func setUpViews() {
        super.setUpViews()
        setUpTopUI()
        setUpBg()
        setUpAnimateView()
    }
    
    override func setUpEvents() {
        
        stateView.status.asObservable().bind { [unowned self] (status) in
            if status == .ongoing {
                self.animateView.animateStart()
            } else {
                self.animateView.animateStop()
            }
        }.disposed(by: disposeBag)
        
        stateView.researchClosure = { [unowned self] in
            guard BluetoothManager.shared.isBluetoothStateOpen.value else {
                self.alertToOpenBluetooth()
                return
            }
            self.stateView.status.value = .ongoing
            self.searchDevice()
        }
        
        animateView.clickBlock = { [unowned self] in
            guard BluetoothManager.shared.isBluetoothStateOpen.value else {
                self.alertToOpenBluetooth()
                return
            }
            self.stateView.status.value = .ongoing
            self.searchDevice()
        }
        
        searchSuccessView.bindClosure = { [unowned self] in
            BraceletManager.shared.connect(result: { [weak self] (state) in
                debugPrint("连接状态====")
                debugPrint(state.rawValue)
                debugPrint("==========")
                if state == .stateConnectSuccess {
                    debugPrint("连接成功====")
                    self?.bindRequest { isSuc in
                        if isSuc {
                            self?.handleConnectSuccess()
                            return;
                        }
                        BraceletManager.shared.disconnect()
                        self?.searchSuccessView.animate(isShow: false)
                        self?.stateView.status.value = .fail
                    }
                } else {
                    self?.searchSuccessView.animate(isShow: false)
                    self?.stateView.status.value = .fail
                }
            })
        }
    }
    
    func searchDevice() {
        stateView.status.value = .ongoing
        BraceletManager.shared.search(success: { [weak self] (device) in
            guard let view = self?.view else { return }
            self?.searchSuccessView.detailLabel.text = device.deviceName
            self?.searchSuccessView.show(in: view)
            self?.stateView.status.value = .success
        }) { [weak self] in
            self?.stateView.status.value = .fail
        }
    }
    
    func handleConnectSuccess() {
        searchSuccessView.animate(isShow: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.bindSuccessView.showInView(self.view)
            self.bindSuccessView.dismissClosure = { [weak self] in
                let navi = self?.navigationController
                navi?.popViewController(animated: false)
                let myBraceletVC = MyBraceletSettingController()
                myBraceletVC.hidesBottomBarWhenPushed = true
                navi?.pushViewController(myBraceletVC, animated: true)
                BraceletManager.shared.upgradeEnable = true
            }
        }
    }
    
    func setUpTopUI() {
        let label = BaseLabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldAppFontOfSize(15)
        label.text = Text.MyBracelet
        label.frame.size = CGSize.init(width: 100, height: 44)
        label.textAlignment = .center
        navigationItem.titleView = label
    }
    
    func setUpBg() {
        let bgImg = UIImage.gradientImage(startColor: UIColor.hexColor(0x303348),
                                          endColor: UIColor.hexColor(0x43465B),
                                          startPoint: CGPoint.init(x: view.bounds.width, y: 0),
                                          endPoint: CGPoint.init(x: 0, y: view.bounds.height),
                                          size: view.bounds.size)
        let bg = BaseImageView.init(image: bgImg)
        view.addSubview(bg)
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setUpAnimateView() {
        let lanyaShadowBg = UIImageView.init(image: UIImage.init(named: "lanya-shadow"))
        view.addSubview(lanyaShadowBg)
        lanyaShadowBg.snp.makeConstraints { (make) in
            make.top.equalTo(127.layout)
            make.centerX.equalTo(view)
        }
        view.addSubview(animateView)
        animateView.snp.makeConstraints { (make) in
            make.centerX.equalTo(lanyaShadowBg)
            make.top.equalTo(260.layout)
            make.size.equalTo(animateView.size)
        }
        view.addSubview(stateView)
        stateView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
        }
    }
    
    func bindRequest(complete: BoolClosure?) {
        guard let device = resultDevice, let mac = BraceletManager.shared.bracelet?.bracelet_mac else {
            return
        }
        let params: Dic = [
            "bracelet_mac" : mac,
            "device_id" : GlobalAction.UUID.nonOptional,
            "bracelet_name" : device.deviceName,
            "bracelet_version" : device.firmwareVersion,
            "bind_action" : 1
        ]
        NetWorker.put(ServerURL.BindDevice, params: params, success: { (_) in
            BraceletManager.shared.bracelet?.is_binded = 1
            complete?(true)
        }, error: { (code, msg) in
            complete?(false)
        }) { (error) in
            complete?(false)
        }
    }
    
}


