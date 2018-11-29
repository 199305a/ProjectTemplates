//
//  DoorGuardManager.swift
//  CommaUser
//
//  Created by yuanchao on 2018/5/9.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import CoreBluetooth

class DoorGuardManager: NSObject, CBPeripheralDelegate {

    typealias DoorGuardRecievedData = (Data) -> ()
    static let shared = DoorGuardManager()
    var targetMac: String?
    var peripheral: CBPeripheral?
    var serviceClosure: ((ConnectState)->Void)? // 获取到特性后的回调闭包
    
    var rxCharacteristic: CBCharacteristic? // 可读特性
    var txCharacteristic: CBCharacteristic? // 可写特性
    let serviceUUIDString = "18F0"
    let rxCharacteristicUUIDString = "2AF0"
    let txCharacteristicUUIDString = "2AF1"
    let filterPrefix = "LK"
    var response = [CommandType:DoorGuardRecievedData]()
    var openDoorClosure: DoorGuardRecievedData?
    
    // 连接设备
    func connect(_ peripheral: CBPeripheral,completion: ((ConnectState)->Void)?) {
        serviceClosure = completion
        self.peripheral = peripheral
        BluetoothManager.shared.connectPeripheral(peripheral) { state in
            switch state {
            case.success:
                self.peripheral = peripheral
                self.peripheral?.delegate = self
                self.peripheral?.discoverServices([])
            default:
                self.serviceClosure?(state)
            }
        }
    }
    
    // 发现 service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            dLog("can't discover services reason: \(error.localizedDescription)")
            self.serviceClosure?(.fail(.unknown))
            return
        }
        // 获取所有的service，然后获得它们的特性
        peripheral.services?.forEach({ (service) in
            dLog("service的UUID=\(service.uuid.uuidString)")
            if service.uuid.uuidString == serviceUUIDString {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        })
    }
    
    // 发现特性 (call from discoverCharacteristics forService).  you can do write/read/nofity method here
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            dLog("can't discover character reason: \(error.localizedDescription)")
            self.serviceClosure?(.fail(.unknown))
            return
        }
        dLog("discovered Characteristics")
        service.characteristics?.forEach { [unowned peripheral, unowned self] characteristic in
            dLog("characteristic的UUID=\(characteristic.uuid.uuidString)")
            switch characteristic.uuid.uuidString {
            case rxCharacteristicUUIDString:
                self.rxCharacteristic = characteristic
            case txCharacteristicUUIDString:
                self.txCharacteristic = characteristic
            default:
                break
            }
            if characteristic.properties.contains(.notify) || characteristic.properties.contains(.notifyEncryptionRequired) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        if rxCharacteristic != nil && txCharacteristic != nil {
            self.serviceClosure?(.success)
        } else {
            self.serviceClosure?(.fail(.unknown))
        }
    }
    
    // 更新特性（call readValueForCharacteristic之后）
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            dLog("can't read reason: \(error.localizedDescription)")
            return
        }
        debugPrint("didUpdateValueFor: \(characteristic.value as NSData?)")
        guard let data = characteristic.value else {
            return
        }
        
        // 默认开门成功为30（16进制）
        let bytes = [UInt8](data)
        if bytes.count < 5 { return }
        guard bytes.count >= 5, let _ = CommandType.init(rawValue: bytes[1]) else {
            openDoorClosure?(Data())
            return
        }
        
        let content = Data.init(bytes: bytes[3..<bytes.count-2])
        openDoorClosure?(content)
    }
    
    // 通知 setNotifyValue call back
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            dLog("cant nofity update character state reason: \(error.localizedDescription)")
            return
        }
        dLog("didUpdateNotificationStateFor")
    }
    
    
    // 已写
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            dLog("cant write  character value reason: \(error.localizedDescription)")
            return
        }
        dLog("写入数据成功:\(String(describing: characteristic.value))")
    }
    
    
    // 发送数据
    func sendData(type: CommandType, content: String = "", completion: DoorGuardRecievedData?) {
        response[type] = completion
        openDoorClosure = completion
        guard let tx = txCharacteristic else {
            response[type]?(Data())
            return
        }
        let prefix: UInt8 = 0xAA          // 起始位
        let typeByte: UInt8 = type.rawValue   // 类型
        let contentBytes: [UInt8] = [UInt8](content.data(using: .utf8) ?? Data())  //内容包
        let contentSize = UInt8(contentBytes.count)               // 内容包大小
        let encrypt = contentBytes.reduce(typeByte ^ contentSize, ^)  // 校验位
        let suffix: UInt8 = 0x55         // 结束位
        
        let bytes = [prefix, typeByte, contentSize] + contentBytes + [encrypt, suffix]
        let dataPacket = Data.init(bytes: bytes)
        
        if tx.properties.contains(.write) {
            peripheral?.writeValue(dataPacket, for: tx, type: .withResponse)
        } else if tx.properties.contains(.writeWithoutResponse) {
            peripheral?.writeValue(dataPacket, for: tx, type: .withoutResponse)
        }
        dLog("发送开门指令:\(dataPacket as NSData)")
        
    }
    
    
    func reset() {
        peripheral = nil
        rxCharacteristic = nil
        txCharacteristic = nil
    }
    
    enum CommandType: UInt8 {
        case openDoor = 0x11
        case openDoorResp = 0x12
        case retry = 0x13
        case obtainDeviceInfo = 0x14
        case deviceInfoResp = 0x15
    }

}




