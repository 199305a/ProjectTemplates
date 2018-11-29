//
//  BraceletManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/12/19.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxSwift

class BraceletManager: NSObject {
    
    static let shared = BraceletManager() // 单例
    var bleManager: LSBluetoothManager?
    
    var bracelet: Bracelet? {
        didSet{
            guard let bracelet = bracelet else { return }
            if _setting == nil && getSettingFromDisk() == nil {
                setting = Setting.init(
                    vibrationStrengthLevel: VibrationStrengthLevel.init(rawValue: bracelet.intensity) ?? .middle,
                    heartRateDetectionOpen: bracelet.heart_rate == 1,
                    incomingCallRemindOpen: bracelet.tel_remind == 1,
                    wechatMsgRemindOpen: bracelet.wechat_remind == 1
                )
            }
            // 如果开了蓝牙，自动连接
            if GlobalAction.isLogin &&
                bracelet.isBind &&
                BluetoothManager.shared.isBluetoothStateOpen.value &&
                isWorkFree &&
                !isConnect.value {
                searchAndConnect()
            }
        }
    }
    
    var device: LSDeviceInfo?
    var newFirmwareInfo: BraceletFirmwareInfoModel?
    var isUpgrading = false
    var userGiveUpRetryUpgrade = false
    var upgradeEnable = true
    var connectReslut: ((LSDeviceConnectState) -> Void)?
    var searchError: EmptyClosure?
    var batteryPercent: Variable<Int32> = Variable(0)
    let searchTimeOutLength = 60
    var searchTimeLength = 0
    var searchTimer: Timer?
    var isConnect = Variable(false)
    var isWorkFree: Bool = true
    var connectStatus = Variable(LSDeviceConnectState.stateUnknown)
    var reportDataQueue = DispatchQueue.init(label: "com.commafit.report_bracelet_data")
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
//MARK: -  设置信息保存
    private var _setting: Setting?
    var setting: Setting {
        set {
            _setting = newValue
            updateDiskSetting()
        }
        get {
            if let memorySetting = _setting {
                return memorySetting
            }
            if let diskSetting = getSettingFromDisk() {
                _setting = diskSetting
                return diskSetting
            }
            return Setting()
        }
    }
    
    
    var measureDataReceived: Variable<LSPedometerData?> = Variable(nil)
    
    private override init() {
        super.init()
        _ = BluetoothManager.shared.isBluetoothStateOpen.asObservable().bind { (isOpen) in
            if isOpen && self.bleManager == nil {
                
                LSBluetoothManager.default().initManager(withDispatch: DispatchQueue.global())
                LSBluetoothManager.default().saveDebugMessage(true, forFileDirectory: self.logFilePath)
                self.bleManager = LSBluetoothManager.default()
            }
        }
    }
    
    //MARK: - 搜索设备
    func search(success: ((LSDeviceInfo) -> Void)?, error: EmptyClosure?) {
        connectStatus.value = .stateUnknown
        isWorkFree = false
        searchError = error
        startSearchCountDown()
        let deviceTypes = [NSNumber.init(value: LSDeviceType.pedometer.rawValue),NSNumber.init(value: LSDeviceType.unknown.rawValue)]
        bleManager?.searchDevice(deviceTypes, broadcast: BroadcastType.all) { (device) in
            if let device = device {
                dLog("搜索到=======\(device.macAddress)：\(device.broadcastId)--\(device.deviceName)\(device.peripheralIdentifier)")
            }
            guard let device = device,
                let bracelet = self.bracelet,
                bracelet.recognize(device) else {
                    return
            }
            debugPrint("deviceMac=\(device.broadcastId)")
            debugPrint("deviceName=\(device.deviceName)")
            self.stopSearch()
            self.device = device
            success?(device)
        }
    }
    
    func searchAndConnect(result: ((LSDeviceConnectState) -> Void)? = nil) {
        connectStatus.value = .stateUnknown
        isWorkFree = false
        let deviceTypes = [NSNumber.init(value: LSDeviceType.pedometer.rawValue)]
        bleManager?.searchDevice(deviceTypes, broadcast: BroadcastType.all) { (device) in
            if let device = device {
                dLog("搜索到=======：\(device.broadcastId)")
            }
            guard let device = device,
                let bracelet = self.bracelet,
                bracelet.recognize(device) else {
                    return
            }
            debugPrint("deviceMac=\(device.broadcastId)")
            debugPrint("deviceName=\(device.deviceName)")
            self.bleManager?.stopSearch()
            self.device = device
            self.connect(result: result)
        }
    }
    
    func connect(result: ((LSDeviceConnectState) -> Void)? = nil) {
        isWorkFree = false
        guard let device = device, let bleManager = bleManager else {
            return
        }
        connectStatus.value = .stateConnecting
        connectReslut = result
        let currentState = bleManager.checkDeviceConnectState(device.broadcastId)
        if currentState == .stateConnectSuccess {
            connectStatus.value = currentState
            isConnect.value = true
            connectReslut?(currentState)
            isWorkFree = true
            return
        }
        bleManager.setMeasureDeviceList(nil)
        bleManager.addMeasureDevice(device)
        bleManager.stopDataReceiveService()
        bleManager.startDataReceiveService(self)
    }
    
    func disconnect() {
        cancelUpgrade()
        bleManager?.setMeasureDeviceList(nil)
        bleManager?.stopDataReceiveService()
        isConnect.value = false
    }
    
    func stopSearch() {
        stopSearchCountDown()
        bleManager?.stopSearch()
    }
    
    func reset() {
        isWorkFree = true
        resetDevice()
        resetBracelet()
    }
    
    func resetDevice() {
        stopSearch()
        disconnect()
        device = nil
        batteryPercent.value = 0
    }
    
    func resetBracelet() {
        bracelet = nil
        newFirmwareInfo = nil
    }
    
}

extension BraceletManager {
    func startSearchCountDown() {
        stopSearchCountDown()
        searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(searchCountDown), userInfo: nil, repeats: true)
    }
    @objc func searchCountDown() {
        searchTimeLength += 1
        if searchTimeLength > searchTimeOutLength {
            stopSearch()
            searchError?()
        }
    }
    func stopSearchCountDown() {
        searchTimer?.invalidate()
        searchTimer = nil
        searchTimeLength = 0
    }
}

extension BraceletManager: LSDeviceDataDelegate {
    
    func readVoltage() {
        guard let device = device else {
            return
        }
        bleManager?.readDeviceVoltage(device.broadcastId)
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didConnectStateChange connectState: LSDeviceConnectState) {
        isWorkFree = true
        connectStatus.value = connectState
        if connectState == .stateConnectSuccess {
            isConnect.value = true
            readVoltage()
            debugPrint("===连接成功===")
            connectReslut?(connectState)
            // 第一次连接成功后，获取固件信息
            if newFirmwareInfo == nil {
                requestFirmwareInfo()
            } else if BluetoothManager.shared.isBluetoothStateOpen.value && !userGiveUpRetryUpgrade && !isUpgrading {
                try? upgradeFirmwareFromDiskResource()
            }
        } else {
            isConnect.value = false
            connectReslut?(connectState)
            debugPrint("连接断开")
        }
        
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didMeasureDataUpdateForPedometer dataObj: LSDeviceData!) {
        debugPrint("设备状态======")
        debugPrint(bleManager!.managerStatus.rawValue)
        parseMeasureData(dataObj)
    }
    
    func bleDeviceDidInformationUpdate(_ device: LSDeviceInfo!) {
        self.device = device
    }
    
    func bleDevice(_ lsDevice: LSDeviceInfo!, didBatteryVoltageUpdate voltageModel: LSUVoltageModel!) {
        batteryPercent.value = voltageModel.batteryPercent
    }
    
    func parseMeasureData(_ data: LSDeviceData?) {
        guard let dataObj = data?.dataObj else {
            return
        }
        switch dataObj {
        case let _data as LSPedometerData:
            dLog("收到数据：LSPedometerData=========================")
            dLog("calories = \(_data.calories)")
            dLog("measureTime = \(_data.measureTime)")
            dLog("walkSteps = \(_data.walkSteps)")
            dLog("distance = \(_data.distance)")
            dLog("utc = \(_data.utc)")
            dLog("sourceData = \(_data.sourceData)")
            dLog("exerciseTime=\(_data.exerciseTime)")
            dLog("收到数据：=========================")
            measureDataReceived.value = _data
            DataStoreManager.shared.saveBraceletData(_data)
        case let _data as LSUMeasureData:
            dLog("收到数据：LSUMeasureData=========================")
            dLog("calories = \(_data.calories)")
            dLog("measureTime = \(_data.measureTime)")
            dLog("walkSteps = \(_data.step)")
            dLog("distance = \(_data.distance)")
            dLog("收到数据：=========================")
        case let _data as LSUSportData:
            dLog("收到数据：LSUSportData=========================")
            dLog("calories = \(_data.calories)")
            dLog("measureTime = \(_data.measureTime)")
            dLog("walkSteps = \(_data.step)")
            dLog("收到数据：=========================")
        default:
            break
        }
        
    }
}

// MARK: - 手环设置
extension BraceletManager {
    
    func changeShockLevel(_ level: VibrationStrengthLevel) {
        setting.vibrationStrengthLevel = level
        if setting.incomingCallRemindOpen {
            callRemind(true) { (isSuc) in
                debugPrint("设置来电提醒振动强度成功")
            }
        }
        if setting.wechatMsgRemindOpen {
            wxMsgRemind(true) { (isSuc) in
                debugPrint("设置微信提醒振动强度成功")
            }
        }
        
        guard let device = device else {
            return
        }
        
//            let evenmind = LSDeviceEventReminderInfo()
//            evenmind.shockType = .interval
//            evenmind.shockTime = 15
//            evenmind.shockLevel1 = Int32(setting.vibrationStrengthLevel.rawValue)
//            evenmind.shockLevel2 = Int32(setting.vibrationStrengthLevel.rawValue)
//            evenmind.shockType = .interval
//            evenmind.addWeekDay(LSWeek.friday)
//            bleManager?.update(evenmind, forDevice: device.broadcastId, andBlock: { (isSuc, code) in
//
//                    dLog("--------震动设置成功\(code)")
//            })
    }
    //MARK: - 描述 添加闹钟提醒
    func addBlockinfoToDevice(complete:BoolClosure? = nil) {
       
        
    }
    
    func heartRateDetection(_ open: Bool, complete: BoolClosure? = nil) {
        guard let device = device else {
            return
        }
        let mode = open ? LSHRDetectionMode.turnOn : LSHRDetectionMode.turnOff
        bleManager?.updateHeartRateDetectionMode(mode, forDevice: device.broadcastId) { (isSuc, code) in
            complete?(isSuc)
        }
    }
    
    func callRemind(_ open: Bool, complete: BoolClosure? = nil) {
        msgRemind(open, msgType: .incomingCall, complete: complete)
    }
    
    func wxMsgRemind(_ open: Bool, complete: BoolClosure? = nil) {
        msgRemind(open, msgType: .wechat, complete: complete)
    }
    //MARK: - 描述 设置手环消息
    func msgRemind(_ open: Bool, msgType: LSDeviceMessageType, complete: BoolClosure? = nil) {
        guard let device = device else {
            return
        }
        let remind = LSDMessageReminder()
        remind.isOpen = open
        remind.shockDelay = 2
        remind.shockType = .interval
        remind.shockTime = 15
        remind.shockLevel1 = Int32(setting.vibrationStrengthLevel.rawValue)
        remind.shockLevel2 = Int32(setting.vibrationStrengthLevel.rawValue)
//        remind.type = .disconnect
        remind.type = msgType
        bleManager?.updateMessageRemind(remind, forDevice: device.broadcastId, andBlock: { (isSuc, code) in
            complete?(isSuc)
        })
        

    }
    
}

extension BraceletManager {
    
    enum VibrationStrengthLevel: Int, Codable {
        case low = 3
        case middle = 6
        case high = 9
    }
    
    struct Setting: Codable {
        var vibrationStrengthLevel: VibrationStrengthLevel = .middle
        var heartRateDetectionOpen: Bool = false
        var incomingCallRemindOpen: Bool = false
        var wechatMsgRemindOpen: Bool = false
    }
    
    func updateDiskSetting() {
        guard let mac = bracelet?.bracelet_mac else {
            return
        }
        do {
            let data = try JSONEncoder().encode(setting)
            StandardDefaults.set(data, forKey: mac)
        } catch {
            dLog(error.localizedDescription)
        }
    }
    
    func getSettingFromDisk() -> Setting? {
        guard let mac = bracelet?.bracelet_mac, let data = StandardDefaults.data(forKey: mac) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(Setting.self, from: data)
        } catch {
            dLog(error.localizedDescription)
        }
        return nil
    }
    
    func updateRemoteSetting() {
        guard let mac = bracelet?.bracelet_mac, device != nil else {
            return
        }
        
        let params: Dic = [
            "bracelet_mac": mac,
            "intensity": setting.vibrationStrengthLevel.rawValue,
            "heart_rate": setting.heartRateDetectionOpen ? 1 : 0,
            "tel_remind": setting.incomingCallRemindOpen ? 1 : 0,
            "wechat_remind": setting.wechatMsgRemindOpen ? 1 : 0
        ]
        NetWorker.put(ServerURL.BraceletConfig, params: params, success: { (_) in
            dLog("成功更改手环配置")
        }, error: { (code, msg) in
            dLog("更改手环配置失败：code=\(code),msg=\(msg)")
        }) { (err) in
            dLog("更改手环配置失败")
        }
    }
    
}


// MARK: - 上报体侧数据
extension BraceletManager {
    
    func reportData() {
        reportDataQueue.async {
            guard let mac = self.bracelet?.bracelet_mac,
                let dataList = DataStoreManager.shared.getBraceletData(mac: mac), !dataList.isEmpty else {
                    return
            }
            dLog("dataList.count=\(dataList.count)")
            debugPrint(dataList)
            for data in dataList {
                self.reportBraceletData(measureData: data) {
                    if let dateStr = data._dateStr.split(separator: " ").first, DataStoreManager.shared.todayDateStr.split(separator: " ")[0] == dateStr {
                        return
                    }
                    DataStoreManager.shared.deleteBraceletData(mac: mac, timeStr: data.measureTime.nonOptional)
                }
            }
        }
    }
    
    func reportBraceletData(measureData: BraceletTraining, success: EmptyClosure?) {
        let time = String(measureData._dateStr.split(separator: " ")[0]).replacingOccurrencesOfString("-", withString: "")
        let sportData: Dic = [
            "step_num": measureData._steps,
            "distance": measureData._distance,
            "kcal": measureData._calories,
            "measure_time": time
        ]

        let params: Dic = [
            "sport_data": sportData ?? [:],
            "device_id": GlobalAction.UUID.nonOptional
        ]
        NetWorker.post(ServerURL.SaveSportData, params: params, success: { (dataObj) in
            dLog("上报手环数据成功")
            success?()
        }, error: { (code, msg) in
            dLog("上报手环数据失败：\(msg)")
        }) { (_) in
            dLog("上报手环数据失败")
        }
    }
    
    var logFilePath: String {
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let logDirPath = document + "/LS-BLE"
        if !FileManager.default.fileExists(atPath: logDirPath) {
            do {
                try FileManager.default.createDirectory(atPath: logDirPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                dLog(error.localizedDescription)
            }
        }
        return logDirPath
    }
}


extension LSDeviceConnectState {
    var description: String {
        switch self {
        case .stateConnectFailure:
            return "手环连接失败"
        case .stateDisconnect:
            return "手环连接断开"
        case .stateConnecting:
            return "手环连接中"
        case .stateConnectionTimedout:
            return "手环连接超时"
        case .stateConnectSuccess:
            return "手环连接成功"
        default:
            return "手环未连接"
        }
    }
}






