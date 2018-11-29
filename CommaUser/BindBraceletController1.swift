//
//  BindBraceletController1.swift
//  CommaUser
//
//  Created by yuanchao on 2018/4/17.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import CoreBluetooth

class BindBraceletController1: BaseController {
    
    let animateView = LanyaSearchAnimateView(frame: CGRect(x: 0, y: 0, width: 120.layout, height: 120.layout))
    let stateView = BluetoothStatusView()
    let searchSuccessView = SearchSuccessView()
    let bindSearchSuccessView = BindSuccessView()
    
    let bluetoothManager = LSBluetoothManager.default()
    
    let targetMac = "FE:04:55:00:30:BD"
    var resultDevice: LSDeviceInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(color: UIColor.clear)
        edgesForExtendedLayout = .all
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if bluetoothManager?.isBluetoothPowerOn == true {
            searchDevice()
        } else {
            alertToOpenBluetooth()
            stateView.status.value = .fail
        }
        LSBluetoothManager.default().checkingBluetoothStatus(self)
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
    }
    
    override func setUpViews() {
        super.setUpViews()
        setUpTopUI()
        setUpBg()
        setUpAnimateView()
        
    }
    
    override func setUpEvents() {
        searchSuccessView.connectClosure = { [unowned self] in
            guard let device = self.resultDevice else {
                return
            }
            if let paired = self.bluetoothManager?.pairing(withDevice: device, delegate: self), paired {
                print("paired 成功")
                print(self.bluetoothManager?.checkDeviceConnectState(self.targetMac).rawValue)
            } else {
                print("paired 失败")
                print(self.bluetoothManager?.checkDeviceConnectState(self.targetMac).rawValue)
            }
        }
        
        searchSuccessView.searchClosure = { [unowned self] in
            self.searchDevice()
        }
        
        stateView.status.asObservable().bind { (status) in
            if status == .ongoing {
                self.animateView.animateStart()
            } else {
                self.animateView.animateStop()
            }
            }.disposed(by: disposeBag)
        
        
    }
    
    func searchDevice() {
        resultDevice = nil
        stateView.status.value = .ongoing
        animateView.animateStart()
        let deviceType = NSNumber.init(value: LSDeviceType.pedometer.rawValue)
        bluetoothManager?.searchDevice([deviceType], broadcast: BroadcastType.all) { [weak self] (device) in
            guard let this = self, let device = device, device.macAddress == this.targetMac else {
                return
            }
            print("deviceMac=\(device.macAddress)")
            print("deviceName=\(device.deviceName)")
            this.handleSearchResult(device)
        }
    }
    
    func handleSearchResult(_ device: LSDeviceInfo) {
        resultDevice = device
        searchSuccessView.detailLabel.text = device.deviceName
        searchSuccessView.showInView(self.view)
        bluetoothManager?.stopSearch()
        stateView.status.value = .success
    }
    
    func alertToOpenBluetooth() {
        if #available(iOS 11.0, *) {
            presentBluetoothSettingAlert()
        } else {
            BluetoothManager.shared.showBluetoothSettingAlert()
        }
    }
    
    // iOS11及以上，不能弹出系统级提示开启蓝牙的alert，用下面方法替代
    func presentBluetoothSettingAlert() {
        let alert = UIAlertController(title: nil, message: Text.OpenBluetoothNotice, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Text.Known, style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
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
    
    deinit {
        bluetoothManager?.stopSearch()
    }
    
}

extension BindBraceletController1: LSDevicePairingDelegate {
    func bleDevice(_ lsDevice: LSDeviceInfo!, didPairingStatusChange pairingStatus: LSDevicePairedResults) {
        print(pairingStatus.description)
        print(bluetoothManager?.checkDeviceConnectState(targetMac))
    }
}

extension BindBraceletController1: LSBluetoothStatusDelegate {
    
    @available(iOS 10.0, *)
    func systemDidBluetoothStatusChange(_ bleState: CBManagerState) {
        if resultDevice != nil {
            return
        }
        if bleState == .poweredOn {
            searchDevice()
        } else {
            alertToOpenBluetooth()
            bluetoothManager?.stopSearch()
            stateView.status.value = .fail
        }
    }
}

extension LSDevicePairedResults {
    var description: String {
        switch self {
        case .failed:
            return "配对失败"
        case .success:
            return "配对成功"
        case .unknown:
            return "配对状态未知"
        }
    }
}
