//
//  TestUnBindController.swift
//  CommaUser
//
//  Created by Marco Sun on 17/1/17.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class TestUnBindController: BaseController {
    
    let unbindButton = BaseButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = BaseButton()
        button.setTitle("连接蓝牙", for: .normal)
        button.rx.tap.bind { [unowned self] in
            self.connect()
            }.disposed(by: disposeBag)
        
        unbindButton.setTitle("真解绑", for: .normal)
        unbindButton.rx.tap.bind { [unowned self] in
            self.unbind()
            }.disposed(by: disposeBag)
        
        unbindButton.isEnabled = false
        
        button.backgroundColor = UIColor.red
        unbindButton.backgroundColor = UIColor.blue
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        unbindButton.frame = CGRect(x: 0, y: 150, width: 100, height: 100)
        
        view.addSubview(unbindButton)
        view.addSubview(button)
        
    }
    
    func unbind() {
//        BraceletManager.shared.unblindRequest { (succ) in
//            let str = succ ? "解绑成功" : "解绑失败"
//            uLog(str)
//        }
    }
    
    func connect() {
        guard let mac = AppUser.braceletMac else {
            uLog("后台没mac地址")
            return
        }
//        BraceletManager.shared.enter(mac) { [weak self] (state) in
//            switch state {
//            case .success:
//                uLog("连接成功")
//                self?.unbindButton.isEnabled = true
//            default:
//                uLog("连接失败")
//                break
//
//            }
//        }
    }
    
    deinit {
//        BraceletManager.shared.reset()
    }
    
}
