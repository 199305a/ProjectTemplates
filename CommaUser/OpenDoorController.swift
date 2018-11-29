//
//  OpenDoorController.swift
//  CommaUser
//
//  Created by yuanchao on 2018/5/9.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 新访客远程开门
class OpenDoorController: BaseController, CustomNavBarCompatible {

    let scrollView = UIScrollView()
    let imageView = BaseImageView()
    let gymLabel = BaseLabel()
    let distanceLabel = BaseLabel()
    let switchBtn = BaseButton()
    let openDoorBtn = BaseButton()
    let noticeView = VisitNoticeView()
    let viewModel = OpenDoorViewModel()
    var refreshVisitEnableState: EmptyClosure?
    
    var gymId: String? {
        didSet {
            showLoading()
            viewModel.requestOpenDoorInfo(gymId)
        }
    }
    
    let openDoorOngoingView = OpenDoorPromptView.init(state: .ongoing)
    let openDoorSuccessView = OpenDoorPromptView.init(state: .success)
    lazy var openDoorFailureView = OpenDoorFailPromptView.init(state: .failure) { [unowned self] in
        self.open()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeLoadingObserver()
        gymId = CurrentGymID
        if !BluetoothManager.shared.isBluetoothStateOpen.value {
            alertToOpenBluetooth()
        }
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        customizeNavigationBar()
        handleNaviColorWhenError()
        changeTintColorWhenAppearOrNot()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BluetoothManager.shared.stopScan()
        disconnect()
        
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.VisitorOpenDoor
        scrollView.showsVerticalScrollIndicator = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(named: "placeholder_gym")
        imageView.clipsToBounds = true
        gymLabel.textColor = UIColor.hx5c5e6b
        gymLabel.font = UIFont.boldSystemFont(ofSize: 20)
        distanceLabel.textColor = UIColor.hx9b9b9b
        distanceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        switchBtn.setTitle("切换场馆", for: .normal)
        switchBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        switchBtn.titleLabel?.font = UIFont.boldAppFontOfSize(15)
        switchBtn.layer.borderColor = UIColor.hx129faa.cgColor
        switchBtn.layer.borderWidth = 1
        switchBtn.layer.cornerRadius = 5
        openDoorBtn.backgroundColor = UIColor.hx129faa
        openDoorBtn.setTitleColor(UIColor.white, for: .normal)
        openDoorBtn.setTitle("蓝牙开门", for: .normal)
        openDoorBtn.titleLabel?.font = UIFont.boldAppFontOfSize(15)
        openDoorBtn.layer.cornerRadius = 5
        noticeView.backgroundColor = UIColor.hxededed
        noticeView.layer.cornerRadius = 4
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(gymLabel)
        scrollView.addSubview(distanceLabel)
        scrollView.addSubview(switchBtn)
        scrollView.addSubview(openDoorBtn)
        scrollView.addSubview(noticeView)
        
        setUpConstraints()
    }
    
    
    func setUpConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.width.equalTo(view)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.centerX.width.equalTo(view)
            make.height.equalTo(345.layout)
        }
        gymLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(28)
            make.left.equalTo(21)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gymLabel.snp.right).offset(14)
            make.centerY.equalTo(gymLabel)
            make.right.equalTo(-15).priority(100)
        }
        switchBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.equalTo(gymLabel.snp.bottom).offset(30)
            make.height.equalTo(45)
        }
        openDoorBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(switchBtn)
            make.top.equalTo(switchBtn.snp.bottom).offset(15)
        }
        noticeView.snp.makeConstraints { (make) in
            make.top.equalTo(openDoorBtn.snp.bottom).offset(20)
            make.left.right.equalTo(openDoorBtn)
            make.bottom.equalTo(-20)
        }
    }
    
    override func setUpEvents() {
        
        viewModel.openDoorInfo.asObservable().bind { [weak self] (model) in
            self?.imageView.sd_setImage(with: URL.init(string: model.imgUrlStr.nonOptional), placeholderImage: UIImage.init(named: "placeholder_gym"))
            self?.gymLabel.text = model.name
            
            }.disposed(by: disposeBag)
        
        viewModel.doorInfoRequestError.bind { [weak self] (code) in
            self?.refreshVisitEnableState?()
        }.disposed(by: disposeBag)
        
        switchBtn.rx.tap.bind { [unowned self] in
            let vc = SwitchStoreController(onlyShowGymStyle: true)
            vc.itemClick = { [unowned self] store in
                self.gymId = store.gym_id
            }
            self.pushAnimated(vc)
        }.disposed(by: disposeBag)
        
        openDoorBtn.rx.tap.bind { [unowned self] in
            self.open()
        }.disposed(by: disposeBag)
        
        errorBackgroundView.buttonClick = { [unowned self] _ in
            guard let gymId = self.gymId else {
                return
            }
            self.viewModel.requestOpenDoorInfo(gymId)
        }
        
    }
    
    func open() {
        if !BluetoothManager.shared.isBluetoothStateOpen.value {
            self.alertToOpenBluetooth()
            return
        }
        self.openDoorOngoingView.show(in: self.view)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.scan()
        }
    }
    
    func scan() {
        BluetoothManager.shared.scanPeripheral { [weak self] (scanState) in
            guard let this = self else { return }
            switch scanState {
            case .findTargetPeripheral(let peripheral):
                dLog("发现外设：\(peripheral.name ?? "未命名")")
                guard let doorGuard = self?.viewModel.getTargetGuard(peripheral: peripheral) else {
                    return
                }
                BluetoothManager.shared.stopScan()
                self?.connect(doorGuard: doorGuard, peripheral: peripheral)
            case .fail(let error):
                this.showFailureState(msg: error.description)
            default:
                break
            }
        }
    }
    
    func connect(doorGuard: DoorGuardBluetoothModel, peripheral: CBPeripheral) {
        DoorGuardManager.shared.connect(peripheral, completion: { [weak self] (connectState) in
            switch connectState {
            case .success:
                self?.sendData(doorGuard.action.nonOptional)
            case .fail(let reason):
                self?.showFailureState(msg: reason.description)
            default:
                break
            }
        })
    }
    
    func sendData(_ content: String) {
        DoorGuardManager.shared.sendData(type: .openDoor, content: content, completion: { [weak self] (data) in
            dLog("收到开门数据：\(data as NSData)")
            self?.disconnect()
            if data == Data.init(bytes: [0x30]) {
                // 开门成功
                self?.viewModel.reportVisitRecord {
                    self?.refreshVisitEnableState?()
                }
                self?.openDoorOngoingView.dismiss()
                guard let this = self else { return }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
                    self?.openDoorSuccessView.show(in: this.view)
                    DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                })
            } else {
                // 开门失败
                self?.handleOpenFailure(msg: "开门失败")
            }
        })
    }
    
    func handleOpenFailure(msg: String) {
        if viewModel.loopEnable {
            scan()
            return
        }
        showFailureState(msg: msg)
    }
    
    func showFailureState(msg: String) {
        self.openDoorOngoingView.dismiss()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
            self.openDoorFailureView.show(in: self.view, msg: msg)
        })
    }
    
    func disconnect() {
        if let peripheral = DoorGuardManager.shared.peripheral {
            BluetoothManager.shared.disconnectPeripheral(peripheral)
        }
    }
    
    deinit {
        self.refreshVisitEnableState?()
    }
}

class VisitNoticeView: BaseView {
    var titleLabel = BaseLabel()
    let noticeItems = ["仅针对从未在Comma Fit健身的新逗号们",
                       "只有一次体验机会",
                       "需要开启蓝牙",
                       "需要选择正确的门店",
                       "无法使用AB门，请从访客通道进出入"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "参观须知"
        titleLabel.textColor = UIColor.hx5c5e6b
        titleLabel.font = UIFont.boldAppFontOfSize(20)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20.layoutIf5S)
            make.top.equalTo(20)
        }
        setUpItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpItems() {
        var itemViews = [ItemView]()
        for item in noticeItems {
            let itemV = ItemView()
            itemV.infoLabel.text = item
            addSubview(itemV)
            itemViews.append(itemV)
        }
        setUpItemConstraints(itemViews)
    }
    
    func setUpItemConstraints(_ views: [UIView]) {
    
        for (i, v) in views.enumerated() {
            if i == 0 {
                v.snp.makeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(5)
                    make.left.equalTo(titleLabel)
                    make.right.equalTo(-20.layoutIf5S)
                }
            } else if i == views.count - 1{
                v.snp.makeConstraints { (make) in
                    make.top.equalTo(views[i-1].snp.bottom)
                    make.left.equalTo(titleLabel)
                    make.right.equalTo(-20.layoutIf5S)
                    make.bottom.equalTo(-22.5)
                }
            } else {
                v.snp.makeConstraints { (make) in
                    make.top.equalTo(views[i-1].snp.bottom)
                    make.left.equalTo(titleLabel)
                    make.right.equalTo(-20.layoutIf5S)
                }
            }
        }
    }
    
    class ItemView: BaseView {
        let infoLabel = BaseLabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            let sign = BaseView()
            sign.backgroundColor = UIColor.hx129faa
            sign.layer.cornerRadius = 3
            infoLabel.textColor = UIColor.hx5c5e6b
            infoLabel.font = UIFont.appFontOfSize(15)
            infoLabel.numberOfLines = 0
            addSubview(sign)
            addSubview(infoLabel)
            sign.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.size.equalTo(CGSizeMake(6))
                make.top.equalTo(14)
            }
            infoLabel.snp.makeConstraints { (make) in
                make.top.equalTo(7.5)
                make.bottom.equalTo(-7.5)
                make.left.equalTo(sign.snp.right).offset(15)
                make.right.equalTo(0)
            }

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
