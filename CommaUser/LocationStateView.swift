//
//  LocationStateView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift

class LocationStateView: UIView {
    
    var locBtn: BaseButton!
    var state = LocationState.none {
        didSet{
            print("当前线程: \(Thread.current)")
            switch state {
            case .locating:
                showLocatingIndicator()
                locBtn.snp.updateConstraints { (make) in
                    make.width.greaterThanOrEqualTo(Layout.ScreenWidth - 30)
                }
            case .success:
                dismissLocatingIndicator()
                locBtn.snp.updateConstraints { (make) in
                    make.width.greaterThanOrEqualTo(100)
                }
            case .fail:
                dismissLocatingIndicator()
                locBtn.snp.updateConstraints { (make) in
                    make.width.greaterThanOrEqualTo(Layout.ScreenWidth - 30)
                }
                locBtn.setTitle(Text.PleaseReLocate, for: .normal)
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commitInit() {
        backgroundColor = UIColor.hexColor(0xf4f8f9)
        
        let locCityLabel = BaseLabel()
        addSubview(locCityLabel)
        locCityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.left.equalTo(self).offset(15)
        }
        locCityLabel.text = Text.LocCity
        locCityLabel.textColor = UIColor.hx5c5e6b
        locCityLabel.font = UIFont.boldAppFontOfSize(20)
        
        locBtn = BaseButton()
        addSubview(locBtn)
        locBtn.snp.makeConstraints { (make) in
            make.left.equalTo(locCityLabel)
            make.top.equalTo(locCityLabel.snp.bottom).offset(11)
            make.height.equalTo(45)
            make.width.greaterThanOrEqualTo(100)
        }
        locBtn.backgroundColor = UIColor.hx129faa
        locBtn.layer.cornerRadius = 4
        locBtn.setTitleColor(UIColor.white, for: .normal)
        locBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
    }
    
    // 定位时在定位的按钮上显示活动指示器
    func showLocatingIndicator() {
        if locatingIndicatorV.isAnimating { return }
        locBtn.setTitleColor(UIColor.clear, for: .normal)
        if locatingIndicatorV.superview == nil {
            locBtn.addSubview(locatingIndicatorV)
            locatingIndicatorV.snp.makeConstraints { (make) in
                make.center.equalTo(locBtn)
            }
        }
        locatingIndicatorV.startAnimating()
    }
    
    // 定位成功或失败移除活动指示器
    func dismissLocatingIndicator() {
        locatingIndicatorV.stopAnimating()
        DispatchQueue.main.async { [unowned self] in
            self.locBtn.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    lazy var locatingIndicatorV: UIActivityIndicatorView = {
        let indicatorV = UIActivityIndicatorView()
        indicatorV.activityIndicatorViewStyle = .white
        indicatorV.hidesWhenStopped = true
        return indicatorV
    }()
    
    enum LocationState {
        case none
        case locating
        case success
        case fail
    }
}
