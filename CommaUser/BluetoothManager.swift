//
//  BluetoothManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/11/18.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxCocoa
import RxSwift


class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let shared = BluetoothManager() // 单例
    
    var centralManager: CBCentralManager! // 蓝牙中心
    var peripherals = [CBPeripheral]() // 已扫描到的外设
    
    var bluetoothState: Variable<Int>?     //蓝牙状态(外部可通过该属性监测蓝牙状态)，由于iOS10和9之前的蓝牙state继承类不一致，所以这里只用一个Int来检查，而不是用枚举
    var isBluetoothStateOpen = Variable(false)
    
    var connectCompletion: ((ConnectState)->Void)?     //连接手环（成功或失败）后的回调
    var scanCompletion: ((ScanState)->Void)?        //扫描手环（成功或失败）后的回调
    var disconnectCompletion: ((_ peripheral:CBPeripheral,_ resp: Bool)->Void)?       //断开设备连接的回调
    
    let scanTimeoutLength = 20     //扫描超时时长
    let connectTimeoutLength = 20  //连接超时时长
    
    var isScanning: Bool { return scanCompletion != nil } //正在扫描
    var isConnecting: Bool { return connectCompletion != nil } //正在连接
    
    let serviceUUIDString = "18F0"
    
    private override init() {
        super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
    }
    
    //MARK: =============================  central 状态改变 =============================
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            break
        case .resetting:
            //正在重置状态
            dLog("Resetting")
        case .unsupported:
            LFAlertView.showAlertToKnow(Text.Wrong, message: "您的设备不支持蓝牙")
        case .unauthorized:
            // 设备未授权状态
            dLog("Resetting")
        case .poweredOff:
            dLog("PoweredOff")
        case .poweredOn:
            dLog("PoweredOn")
        }
        bluetoothState?.value = central.state.rawValue
        isBluetoothStateOpen.value = central.state == .poweredOn
    }
    
    
    //MARK: =============================  扫描 =============================
    
    // 外界调用的扫描
    func scanPeripheral(completion: ((ScanState)->Void)?) {
        
        //先判断蓝牙是否开启
        scanOperation(completion: completion)
    }
    
    //MARK: - 扫描操作
    func scanOperation(completion: ((ScanState)->Void)?) {
        scanCompletion = completion
        if centralManager.state != .poweredOn {
            completion?(.fail(.bluetoothOff))
            return
        }
        
        centralManager.retrieveConnectedPeripherals(withServices: [CBUUID.init(string: serviceUUIDString)]).forEach({ scanCompletion?(.findTargetPeripheral($0)) })
        
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        //开启扫描定时器
        timerOngoing()
    }
    
    // 停止扫描
    func stopScan() {
        if #available(iOS 9.0, *) {
            if centralManager.isScanning {
                centralManager.stopScan()
            }
        } else {
            centralManager.stopScan()
        }
        
        //及时释放扫描闭包对象
        scanCompletion = nil
        // 关闭定时器
        timerEnd()
    }
    
    // 停止连接
    func stopConnect() {
        //及时释放扫描闭包对象
        connectCompletion = nil
        // 关闭定时器
        timerEnd()
    }
    
    
    // 发现设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        dLog("搜索到===\(peripheral.name ?? "未命名")")
        scanCompletion?(.findTargetPeripheral(peripheral))
    }
    
    //MARK: =============================  连接  =============================
    
    //外部调用的连接蓝牙
    func connectPeripheral(_ peripheral: CBPeripheral, completion: ((ConnectState)->Void)?) {
        connectOperation(peripheral, completion: completion)
    }
    
    //MARK: - 断开连接
    func disconnectPeripheral(_ peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    //MARK: - 断开所有设备的连接
    func disconnectAllPeripheral() {
        guard isBluetoothStateOpen.value else {
            return
        }
        for peripheral in peripherals {
            disconnectPeripheral(peripheral)
        }
    }
    
    //MARK: - 连接操作
    func connectOperation(_ peripheral: CBPeripheral, completion: ((ConnectState)->Void)?) {
        if centralManager.state != .poweredOn {
            completion?(.fail(.bluetoothOff))
            return
        }
        connectCompletion = completion
        timerOngoing()
        centralManager.connect(peripheral, options: nil)
    }
    
    // 连接到设备
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectCompletion?(.success)
        timerEnd()
        dLog("did connect to \(peripheral.name ?? "")")
    }
    
    // 断开连接设备
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    // 连接设备失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            dLog("cant conect reason: \(error.localizedDescription)")
            dLog("未能连接到设备")
        }
    }
    
    //MARK: =============================  超时  =============================
    
    //MARK: - 超时处理
    var timer: Observable<Int>?
    let isCounting = Variable.init(false)
    var sendDate: Date!
    var timerBag:DisposeBag?
    
    func timerOngoing() {
        timerEnd()
        timerBag = DisposeBag()
        sendDate = Date()
        timer = Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance)
        let length = isScanning ? self.scanTimeoutLength : self.connectTimeoutLength
        timer?.bind { [unowned self] (second) in
            if self.sendDate == nil  { return }
            let count = length - Int(fabs(NSDate().timeIntervalSince(self.sendDate)))
            if count > 0 {
                self.isCounting.value = true
            } else {
                //超时
                if self.isScanning {
                    //扫描超时
                    self.scanCompletion?(.fail(.timeout))
                    self.stopScan()
                } else {
                    //连接超时
                    self.connectCompletion?(.fail(.timeout))
                    self.stopConnect()
                }
            }
            }.disposed(by: timerBag!)
    }
    
    func timerEnd() {
        isCounting.value = false
        sendDate = nil
        timer = nil
        timerBag = nil
    }
    
    func reset() {
        peripherals.removeAll()
        stopScan()
    }
    
}

//MARK: - 扫描状态枚举
enum ScanState {
    
    case findTargetPeripheral(CBPeripheral)       //发现新外设
    case fail(ScanError)                       //失败
    case stop                                  //正常停止
    
}

enum ScanError: Int {
    
    case bluetoothOff                           //蓝牙关闭
    case timeout                                //超时
    
    var description: String {
        switch self {
        case .bluetoothOff:
            return "蓝牙未开启"
        case .timeout:
            return "连接超时"
        }
    }
}



//MARK: - 蓝牙连接状态枚举
enum ConnectState {
    
    case none
    case ongoing
    case success
    case fail(PeripheralErrorReason)
    
}

enum BraceletEnterState {
    case success
    case scanFail(ScanError)
    case connectFail(PeripheralErrorReason)
    case braceletFail(BraceletFailType)
}

enum BraceletFailType {
    case unknown // 未知
    case unbind // 未绑定
}

enum PeripheralErrorReason: Int {
    
    case unknown = -1       //未知
    case bluetoothOff = 0 //蓝牙关闭
    case peripheralDisconnected // 设备断开连接
    case peripheralConnectedFailed // 设备连接失败
    case timeout            //设备连接超时
    
}

extension PeripheralErrorReason {
    var description: String {
        switch self {
        case .unknown:
            return ""
        case .bluetoothOff:
            return "蓝牙未开启"
        case .peripheralDisconnected:
            return "门禁已断开连接"
        case .peripheralConnectedFailed:
            return "门禁连接失败"
        case .timeout:
            return "连接超时"
        }
    }
}

