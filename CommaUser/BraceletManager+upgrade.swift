//
//  BraceletManager+upgrade.swift
//  CommaUser
//
//  Created by yuanchao on 2018/6/4.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

// MARK: - 固件更新
extension BraceletManager: LSDeviceUpgradingDelegate {
    
    /// 升级固件调用的方法
    func upgradeDeviceFirmwareVersion() {
        guard let bleManager = bleManager,
            let device = device else {
                return
        }
        bleManager.stopDataReceiveService()
        let url = URL(fileURLWithPath: firmwareResourceDiskPath)
        bleManager.upgrading(withDevice: device, file: url, delegate: self)
    }
    
    /// 设备升级的回掉
    func bleDevice(_ lsDevice: LSDeviceInfo!, didUpgradeStatusChange upgradeStatus: LSDeviceUpgradeStatus, error errorCode: LSErrorCode) {
        dLog("升级状态：\(upgradeStatus)")
        switch upgradeStatus {
        case .upgradeStatusEnterUpgradeMode:
            dLog("进入升级模式")
        case .upgradeStatusUpgrading:
            dLog("正在升级")
            isUpgrading = true
        case .upgradeStatusUpgradeSuccess:
            dLog("升级成功")
            BandUpdateProgressView.dismiss {
                BandUpdateProgressView.clear()
                BraceletManager.upgradingAlert.dismiss()
                self.showUpgradeSuccessAlert()
            }
            resetFirmwareInfo()
            bleManager?.startDataReceiveService(self)
            NotificationCenter.default.post(name: NSNotification.Name.BraceletUpgradeSuccess, object: nil)
            isUpgrading = false
        case .upgradeStatusUpgradeFailure:
            dLog("升级失败")
            BandUpdateProgressView.dismiss()
            if device != nil {
                alertToUpgradeFail()
            }
            isUpgrading = false
        case .upgradeStatusResetting:
            dLog("设备重启中")
        default:
            break
        }
    }
    
    /// 升级进度的回掉
    func bleDevice(_ lsDevice: LSDeviceInfo!, didUpgradeProgressUpdate value: UInt) {
        BandUpdateProgressView.progress = CGFloat(value) / 100
    }
    
    func requestFirmwareInfo() {
        guard let device = device,
              let firmwareVersion = device.firmwareVersion else { return }
        NetWorker.get(ServerURL.GetBraceletFirmwareInfo, params: ["bracelet_version": firmwareVersion], success: { (dataObj) in
            if self.newFirmwareInfo != nil { return }
            let info = BraceletFirmwareInfoModel.parse(dict: dataObj["info"] as! [String : Any])
            self.newFirmwareInfo = info
            if let remoteVersion = info.bracelet_version, remoteVersion > firmwareVersion {
                self.handleNewFirmwareInfo()
            }
        }, error: { (code, msg) in
            dLog("请求固件信息失败：\(msg)")
        }) { (err) in
            
        }
    }
    
    func handleNewFirmwareInfo() {
        DispatchQueue.global().async {
            do {
                try self.upgradeFirmwareFromDiskResource()
            } catch {
                guard let err = error as? UpgradeFormDickError, err == .fileInvalid else { return }
                try? FileManager.default.removeItem(atPath: self.firmwareResourceDiskPath)
                self.downloadFirmwareResourceAndSaveToDick()
            }
        }
    }
    
    /// 升级固件
    ///
    /// - Throws: 抛出异常
    func upgradeFirmwareFromDiskResource() throws {
        if !upgradeEnable || isUpgrading { return }
        guard let info = newFirmwareInfo,
            let remoteMD5 = info.app_md5,
            let remoteSize = Int64(info.app_size.nonOptional)
            else { throw UpgradeFormDickError.withoutBracelet }
        
        guard FileManager.default.fileExists(atPath: self.firmwareResourceDiskPath) &&
            FileManager.md5(filePath: self.firmwareResourceDiskPath) == remoteMD5 &&
            FileManager.sizeOfFile(self.firmwareResourceDiskPath) == remoteSize
            else { throw UpgradeFormDickError.fileInvalid }
        DispatchQueue.main.async {
            self.alertToUpgrade()
        }
    }
    
    /// 下载固件，存到硬盘
    func downloadFirmwareResourceAndSaveToDick() {
        guard let url = newFirmwareInfo?.url else { return }
        NetWorker.download(urlStr: url, destPath: firmwareResourceDiskPath, success: {
            DispatchQueue.global().async {
                try? self.upgradeFirmwareFromDiskResource()
            }
        }) { (err) in
            dLog(err?.localizedDescription ?? "")
        }
    }
    
    func alertToUpgrade() {
        guard BluetoothManager.shared.isBluetoothStateOpen.value && BraceletManager.upgradeAlert.superview == nil else { return }
        isUpgrading = true
        BraceletManager.upgradeAlert.showInView(APP.window!)
    }
    
    func startUpgrade() {
        guard BluetoothManager.shared.isBluetoothStateOpen.value else {
            UIViewController.getCurrentController()?.alertToOpenBluetooth()
            isUpgrading = false
            return
        }
        BraceletManager.upgradingAlert.showInView(APP.window!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.upgradeDeviceFirmwareVersion()
        })
    }
    
    func alertToUpgradeFail() {
        BraceletManager.upgradingAlert.dismiss()
        let alert = LFAlertView(title: Text.Reminding, message: "手环固件更新失败", items: ["暂不更新", "再次更新"])
        alert.action = { index in
            if index == 1 {
                guard BluetoothManager.shared.isBluetoothStateOpen.value else {
                    UIViewController.getCurrentController()?.alertToOpenBluetooth()
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + alert.animTime + 0.1, execute: {
                    self.startUpgrade()
                })
            } else {
                self.userGiveUpRetryUpgrade = true
                self.bleManager?.startDataReceiveService(self)
            }
        }
        alert.showInView(APP.window!)
    }
    
    static let upgradeAlert: LFAlertView = {
        let alert = LFAlertView(title: Text.Reminding, message: "检测到手环固件更新", items: [Text.Sure])
        alert.action = { [unowned alert] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + alert.animTime + 0.1, execute: {
                shared.startUpgrade()
            })
        }
        return alert
    }()
    
    static let upgradingAlert: LFAlertView = {
        let alert = LFAlertView(title: Text.Reminding, message: "手环固件更新中\n请保持蓝牙连接3-5min", items: ["收起"])
        alert.action = { [unowned alert] _ in
            BandUpdateProgressView.show()
            BandUpdateProgressView.clickCompletion = {
                alert.showInView(APP.window!)
            }
        }
        return alert
    }()
    
    func resetFirmwareInfo() {
        device?.firmwareVersion = newFirmwareInfo?.bracelet_version
        newFirmwareInfo = nil
        userGiveUpRetryUpgrade = false
        try? FileManager.default.removeItem(atPath: firmwareResourceDiskPath)
    }
    
    func showUpgradeSuccessAlert() {
        let alert = LFAlertView(title: nil, message: "更新成功", items: nil)
        alert.footer.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalTo(alert)
            make.top.equalTo(alert.header.snp.lastBaseline)
            make.height.equalTo(25)
        }
        alert.footer.buttons.forEach { $0.isHidden = true }
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.takeUntil(alert.rx.deallocating).bind { [unowned alert] _ in
            alert.dismiss()
        }
        alert.shadowView.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            alert.dismiss()
        })
        alert.showInView(view: APP.window!)
    }
    
    func cancelUpgrade() {
        isUpgrading = false
        guard let bracelet = bracelet else {
            return
        }
        bleManager?.cancelDeviceUpgrading(bracelet.bracelet_mac.nonOptional)
        bleManager?.cancelDeviceUpgrading(bracelet.bracelet_broadcast_id.nonOptional.uppercased())
        BandUpdateProgressView.dismiss()
    }
    
    var firmwareResourceDiskPath: String {
        let file = URL.init(string: (newFirmwareInfo?.url).nonOptional)?.lastPathComponent ?? ""
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(file)";
    }
    
    enum UpgradeFormDickError: Error {
        case withoutBracelet, fileInvalid
    }
}

extension Notification.Name {
    static let BraceletUpgradeSuccess = Notification.Name.init("BraceletUpgradeSuccess")
}
