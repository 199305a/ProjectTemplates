//
//  GymInfoFooterView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/23.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit


class GymInfoFooterView: BaseView {
    
    var model: AnyObject? {
        didSet {
            guard let model = model as? GymInfoModel else {
                return
            }
            statusLabel.text = model.bis_status
            gymLabel.text = model.gym_name
            addressDetailLabel.text = model.address
            addressDetailLabel.setLineSpace(8)
            timeDetailLabel.text = model.open_time
            
            var status = [Bool]()
            status.append(model.has_wifi == 1)
            status.append(model.has_shower == 1)
            status.append(model.has_room == 1)
            status.append(model.is_all_day == 1)
            
            var goodImages = ["gym_wifi_good", "gym_shower_good", "gym_room_good", "gym_allday_good"]
            var badImages = ["gym_wifi_bad", "gym_shower_bad", "gym_room_bad", "gym_allday_bad"]
            
            for (index, item) in serviceView.items.enumerated() {
                let canUse = status[index]
                item.imageView.image = canUse == true ? UIImage(named: goodImages[index]) : UIImage(named: badImages[index])
                item.label.textColor = canUse ? UIColor.hx5c5e6b : UIColor.hxc1c3c8
            }
        }
    }
    
    let gymLabel = BaseLabel()
    let addressLabel = BaseLabel()
    let addressDetailLabel = BaseLabel()
    let timeLabel = BaseLabel()
    let timeDetailLabel = BaseLabel()
    let statusLabel = BaseLabel()
    let locationButton = BaseButton()
    let serviceView = ServiceView()
    var locationClick: EmptyClosure?
    
    override func customizeInterface() {
        
        frame = CGRectMake(0, 0, Layout.ScreenWidth, 272.reH)
        
        backgroundColor = UIColor.white
        addSubview(gymLabel)
        addSubview(addressLabel)
        addSubview(addressDetailLabel)
        addSubview(timeLabel)
        addSubview(timeDetailLabel)
        addSubview(statusLabel)
        addSubview(locationButton)
        addSubview(serviceView)
        gymLabel.textColor = UIColor.hx5c5e6b
        gymLabel.font = UIFont.boldAppFontOfSize(20)
        addressLabel.textColor = UIColor.hx9b9b9b
        addressLabel.font = UIFont.bold15
        addressDetailLabel.textColor = UIColor.hx5c5e6b
        addressDetailLabel.font = UIFont.bold15
        timeLabel.textColor = UIColor.hx9b9b9b
        timeLabel.font = UIFont.bold15
        timeDetailLabel.textColor = UIColor.hx5c5e6b
        timeDetailLabel.font = UIFont.bold15
        statusLabel.textColor = UIColor.hx129faa
        statusLabel.font = UIFont.bold15
        addressLabel.text = "场馆地址:"
        timeLabel.text = "营业时间:"
        statusLabel.text = ""
        locationButton.setImage(UIImage.init(named: "gym_location"), for: .normal)
        locationButton.rx.tap.bind { [unowned self] in
            self.locationClick?()
            }.disposed(by: disposeBag)
        
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(34.reH)
            make.right.equalTo(self).offset(-20)
        }
        
        gymLabel.adjustsFontSizeToFitWidth = true
        gymLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.lastBaseline.equalTo(statusLabel)
            make.right.lessThanOrEqualTo(statusLabel.snp.left).offset(-8)
        }
        
        let size = locationButton.imageView?.image?.size ?? .zero
        locationButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(statusLabel.snp.bottom).offset(26)
            make.size.equalTo(size)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gymLabel)
            make.centerY.equalTo(locationButton)
        }
        
        addressDetailLabel.numberOfLines = 2
        addressDetailLabel.adjustsFontSizeToFitWidth = true
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(94)
            make.top.equalTo(addressLabel)
            make.right.equalTo(locationButton.snp.left).offset(-28)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel)
            make.top.equalTo(addressDetailLabel.snp.bottom).offset(20)
        }
        
        timeDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressDetailLabel)
            make.top.equalTo(timeLabel)
            make.right.lessThanOrEqualTo(addressDetailLabel)
        }
        
        serviceView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(98.reH)
        }
    }
    
    class ServiceView: BaseView {
        
        var items: [ServiceItem] = []
        var titles: [String] = ["WIFI","淋浴","智能操房","24小时"]
        var images: [String] = ["gym_wifi_good", "gym_shower_good", "gym_room_good", "gym_allday_good"]
        override func customizeInterface() {
            for index in 0...3 {
                let item = ServiceItem()
                item.imageView.image = UIImage.init(named: images[index])
                item.label.text = titles[index]
                addSubview(item)
                let width = Layout.ScreenWidth / 4
                item.snp.makeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.width.equalTo(width)
                    make.left.equalTo(self).offset(width * index.toCGFloat)
                }
                items.append(item)
            }
        }
    }
    
    class ServiceItem: BaseView {
        let label = BaseLabel()
        let imageView = BaseImageView()
        
        override func customizeInterface() {
            addSubview(label)
            addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.centerX.equalTo(self)
            }
            label.textColor = UIColor.hx5c5e6b
            label.font = UIFont.boldAppFontOfSize(12)
            label.snp.makeConstraints { (make) in
                make.centerX.bottom.equalTo(self)
                make.top.equalTo(imageView.snp.bottom).offset(4)
            }
            
        }
    }
}

