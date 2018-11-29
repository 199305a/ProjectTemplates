//
//  MyBraceletInfoController.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/28.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
//MARK: - 描述手环详情
class MyBraceletInfoController: BaseController {

    let batteryView = BraceletInfoHeadView()
    let unBindBtn = BaseButton()
    let versionLabel = BaseLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDeviceUpgrade()
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.MyBracelet
        let rightItemBtn = BaseButton()
        rightItemBtn.frame.size = CGSize.init(width: 52, height: 44)
        rightItemBtn.setTitle("购买手环", for: .normal)
        rightItemBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        rightItemBtn.titleLabel?.font = UIFont.bold12
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightItemBtn)
        rightItemBtn.rx.tap.bind { [unowned self] in
            self.pushAnimated(BuyBraceletController())
            }.disposed(by: disposeBag)
        
        let img = UIImage.gradientImage(startColor: UIColor.hexColor(0x43465B),
                                        endColor: UIColor.hexColor(0x303348),
                                        startPoint: CGPoint.init(x: view.width/2-15, y: 0),
                                        endPoint: CGPoint.init(x: view.width/2-15, y: Layout.ScreenHeight-Layout.TopBarHeight-90.addSafeAreaBottom),
                                        size: CGSize.init(width: view.width-30, height: Layout.ScreenHeight-Layout.TopBarHeight-90.addSafeAreaBottom))
        let bg = BaseImageView.init(image: img)
        bg.layer.cornerRadius = 6
        bg.layer.masksToBounds = true
        let braceletImgV = BaseImageView.init(image: UIImage.init(named: "bracelet-300"))
        braceletImgV.contentMode = .center
        let macDescLabel = BaseLabel()
        macDescLabel.text = "MAC地址:"
        macDescLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        macDescLabel.font = UIFont.bold15
        let versionDescLabel = BaseLabel()
        versionDescLabel.text = "固件版本号:"
        versionDescLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        versionDescLabel.font = UIFont.bold15
        let macLabel = BaseLabel()
        macLabel.textColor = UIColor.white
        macLabel.font = UIFont.bold15
        if let mac = BraceletManager.shared.device?.macAddress {
            macLabel.text = mac
        } else {
            macLabel.text = "-"
        }
        
        versionLabel.textColor = UIColor.white
        versionLabel.font = UIFont.bold15
        if let version = BraceletManager.shared.device?.firmwareVersion {
            versionLabel.text = "V " + version
        } else {
            versionLabel.text = "-"
        }
        
        batteryView.arrow.isHidden = true
        batteryView.bg.isHidden = true
        unBindBtn.setTitle(Text.UnbindStr, for: .normal)
        unBindBtn.setTitleColor(UIColor.white, for: .normal)
        unBindBtn.titleLabel?.font = UIFont.bold15
        unBindBtn.backgroundColor = UIColor.hx129faa
        unBindBtn.layer.cornerRadius = 5
        
        view.addSubview(bg)
        bg.addSubview(braceletImgV)
        bg.addSubview(batteryView)
        bg.addSubview(macDescLabel)
        bg.addSubview(versionDescLabel)
        bg.addSubview(macLabel)
        bg.addSubview(versionLabel)
        view.addSubview(unBindBtn)
        
        bg.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
        }
        braceletImgV.snp.makeConstraints { (make) in
            make.top.equalTo(30.layout)
            make.centerX.equalTo(bg)
        }
        versionDescLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-34.layout)
            make.left.equalTo(20)
        }
        versionLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(versionDescLabel)
        }
        macDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(versionDescLabel)
            make.bottom.equalTo(versionDescLabel.snp.top).offset(-10)
        }
        macLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(macDescLabel)
        }
        batteryView.snp.makeConstraints { (make) in
            make.left.equalTo(-10)
            make.right.equalTo(10)
            make.bottom.equalTo(macDescLabel.snp.top).offset(20)
        }
        unBindBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bg.snp.bottom).offset(15)
            make.height.equalTo(45)
            make.left.right.equalTo(bg)
        }

    }
    
    override func setUpEvents() {
        BraceletManager.shared.batteryPercent.asObservable().bind { [weak self] (value) in
            self?.batteryView.progress = Float(value) / 100.0
        }.disposed(by: disposeBag)
        
        unBindBtn.rx.tap.bind { [unowned self] in
            self.alertToUnBind()
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.BraceletUpgradeSuccess).bind { [weak self] (_) in
            if let version = BraceletManager.shared.device?.firmwareVersion {
                self?.versionLabel.text = "V " + version
            } else {
                self?.versionLabel.text = "-"
            }
        }.disposed(by: disposeBag)
    }
    
    func alertToUnBind() {
        let alert = LFAlertView.init(title: nil, message: "您确定解绑手环吗？解绑后您将无法同步日常数据", items: [Text.Cancel, Text.Sure])
        alert.action = { [unowned self] index in
            if index == 1 {
                self.unBind()
            }
        }
        alert.show()
    }
    
    func unBind() {
        guard let mac = BraceletManager.shared.bracelet?.bracelet_mac else {
            return
        }
        showLoading()
        let params: Dic = ["bracelet_mac": mac, "bind_action": 0]
        NetWorker.put(ServerURL.BindDevice, params: params, success: { (_) in
            BraceletManager.shared.resetDevice()
            BraceletManager.shared.bracelet?.is_binded = 0
            self.dismissHUD()
            self.showSuccessWithMessage("解绑成功")
            GlobalAction.delayPerform {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }, error: { (code, msg) in
            self.showErrorWithMessage(msg)
        }) { (_) in
            self.showNetErrorMessage()
        }
    }
    
    func requestDeviceUpgrade() {
        guard let info = BraceletManager.shared.newFirmwareInfo,
            let device = BraceletManager.shared.device,
            !BraceletManager.shared.isUpgrading && BluetoothManager.shared.isBluetoothStateOpen.value
            else { return }
        if let remoteVersion = info.bracelet_version, remoteVersion > device.firmwareVersion {
            BraceletManager.shared.handleNewFirmwareInfo()
        }
    }
    
}
