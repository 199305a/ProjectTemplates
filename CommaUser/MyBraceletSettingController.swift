//
//  MyBraceletSettingController.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/19.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
//MARK: - 手环设置
class MyBraceletSettingController: TableController, UITableViewDataSource {

    let infoHeader = BraceletInfoHeadView()
    let reuseIdentifier1 = "BraceletStrengthSettingCell"
    let reuseIdentifier2 = "BraceletSettingCell"
    let optionItems = ["振动强度","持续心率监测","来电提醒","微信提醒"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BraceletManager.shared.updateRemoteSetting()
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
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.tableHeaderView = infoHeader
        infoHeader.frame.size = CGSize.init(width: Layout.ScreenWidth - 30, height: 150)
        tableView.registerClass(BraceletStrengthSettingCell.self)
        tableView.registerClass(BraceletSettingCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.dataSource = self
    }
    
    override func setUpEvents() {
        
        infoHeader.clickClosure = { [unowned self] in
            self.pushAnimated(MyBraceletInfoController())
        }
        
        BluetoothManager.shared.isBluetoothStateOpen.asObservable().bind { (isOpen) in
            if isOpen && !BraceletManager.shared.isConnect.value {
                BraceletManager.shared.searchAndConnect()
            }
            }.disposed(by: disposeBag)
        
        BraceletManager.shared.connectStatus.asObservable().bind { [weak self] state in
            self?.infoHeader.titleLabel.text = state.description
        }.disposed(by: disposeBag)
        
        BraceletManager.shared.isConnect.asObservable().bind { [weak self] (isConnect) in
            self?.tableView.reloadData()
            self?.infoHeader.isEnable = isConnect
            }.disposed(by: disposeBag)
        
        BraceletManager.shared.batteryPercent.asObservable().bind { [weak self] (value) in
            self?.infoHeader.progress = Float(value) / 100.0
        }.disposed(by: disposeBag)
    }
    
    // tableView delegate dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier1, for: indexPath) as! BraceletStrengthSettingCell
            cell.titleLabel.text = optionItems[indexPath.row]
            cell.strengthLevel = BraceletManager.shared.setting.vibrationStrengthLevel
            cell.changeLevelClosure = { level in
                BraceletManager.shared.changeShockLevel(level)
            }
            cell.isEnable = BraceletManager.shared.isConnect.value
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! BraceletSettingCell
        cell.isEnable = BraceletManager.shared.isConnect.value
        let switchControl = cell.switchControl
        cell.titleLabel.text = optionItems[indexPath.row]
        switchControl.isOn = [BraceletManager.shared.setting.heartRateDetectionOpen, BraceletManager.shared.setting.incomingCallRemindOpen,BraceletManager.shared.setting.wechatMsgRemindOpen][indexPath.row - 1]
        cell.changeSwitchState = { [weak self] isOn in
            switch indexPath.row {
            case 1:
                if isOn {
                    self?.alertToHeartHeartRateDetectionOpen(openClosure: { [weak self] (isSure) in
                        if isSure {
                            BraceletManager.shared.heartRateDetection(true) { isSuc in
                                guard isSuc else {
                                    switchControl.isOn = false
                                    self?.showTextMessage("持续心率监测开启失败")
                                    return
                                }
                                BraceletManager.shared.setting.heartRateDetectionOpen = true
                            }
                        } else {
                            switchControl.isOn = false
                        }
                    })
                } else {
                    BraceletManager.shared.heartRateDetection(false) { [weak self] isSuc in
                        guard isSuc else {
                            switchControl.isOn = false
                            self?.showTextMessage("持续心率监测关闭失败")
                            return
                        }
                        BraceletManager.shared.setting.heartRateDetectionOpen = false
                    }
                }
            case 2:
                BraceletManager.shared.callRemind(isOn) { [weak self] isSuc in
                    guard isSuc else {
                        switchControl.isOn = !isOn
                        self?.showTextMessage("来电提醒\(isOn ? "开启" : "关闭")失败")
                        return
                    }
                    BraceletManager.shared.setting.incomingCallRemindOpen = isOn
                }
            case 3:
                BraceletManager.shared.wxMsgRemind(isOn) { [weak self] isSuc in
                    guard isSuc else {
                        switchControl.isOn = !isOn
                        self?.showTextMessage("微信提醒\(isOn ? "开启" : "关闭")失败")
                        return
                    }
                    BraceletManager.shared.setting.wechatMsgRemindOpen = isOn
                }
            default:
                break
            }
        }
        return cell
    }
    
    func alertToHeartHeartRateDetectionOpen(openClosure: BoolClosure?) {
        let alert = LFAlertView.init(title: Text.Reminding, message: "开启持续心率监测，手环耗电速率加快", items: [Text.Cancel, Text.Sure])
        alert.action = { index in
            openClosure?(index == 1)
        }
        alert.show()
    }

}
