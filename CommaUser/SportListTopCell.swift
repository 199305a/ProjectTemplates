//
//  SportListTopCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class SportListTopCell: BaseTableViewCell {
    
    override var dataSource: AnyObject? {
        didSet {
            guard let model = dataSource as? SportHistoryModel else {
                return
            }
            timeView.topLabel.text = model.total_minutes?.commasString
            calView.topLabel.text = model.total_cal?.commasString
            dayView.topLabel.text = model.total_days?.commasString
        }
    }
    
    let backImageView = FillImageView()
    let timeView = LabelView()
    let calView = LabelView()
    let dayView = LabelView()
    
    override func customizeInterface() {
        contentView.addSubview(backImageView)
        backImageView.contentMode = .bottom
        let image = UIImage.init(named: "training_background")
        let size = image?.size ?? .zero
        let reImage = image?.resizeImage(targetSize: CGSizeMake(Layout.ScreenWidth, Layout.ScreenWidth * size.height / size.width))
        backImageView.image = reImage
        backImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.height.equalTo(134)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(contentView)
        }
        containerView.backgroundColor = UIColor.hexColor(0xFAFDFD)
        containerView.layer.cornerRadius = 6
        containerView.clipsToBounds = false
        
        let view = UIView()
        view.backgroundColor = containerView.backgroundColor
        containerView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(containerView)
            make.height.equalTo(3)
        }
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(containerView)
            make.bottom.equalTo(contentView)
            make.top.equalTo(containerView.snp.bottom)
            make.height.equalTo(22)
        }
        
        titleLabel = BaseLabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.DINProBoldFontOf(size: 20))
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(17)
            make.right.equalTo(containerView).offset(-15)
            make.top.equalTo(containerView).offset(20)
        }
        
        containerView.addSubview(timeView)
        containerView.addSubview(calView)
        containerView.addSubview(dayView)
        timeView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        calView.snp.makeConstraints { (make) in
            make.top.equalTo(timeView)
            make.left.equalTo(timeView.snp.right).offset(30.reW_less_4_7)
        }
        
        dayView.snp.makeConstraints { (make) in
            make.top.equalTo(timeView)
            make.left.equalTo(calView.snp.right).offset(30.reW_less_4_7)
        }
        
        timeView.bottomLabel.text = "总运动时间(分)"
        calView.bottomLabel.text = "消耗热量(Kcal)"
        dayView.bottomLabel.text = "坚持天数"
    }
    
    class LabelView: UIView {
        
        let topLabel = BaseLabel()
        let bottomLabel = BaseLabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(topLabel)
            addSubview(bottomLabel)
            topLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.DINProBoldFontOf(size: 20))
            bottomLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.boldAppFontOfSize(12))
            topLabel.snp.makeConstraints { (make) in
                make.top.left.equalTo(self)
            }
            bottomLabel.snp.makeConstraints { (make) in
                make.left.bottom.equalTo(self)
                make.right.equalTo(self)
                make.top.equalTo(topLabel.snp.bottom).offset(4)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
