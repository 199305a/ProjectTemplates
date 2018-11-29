//
//  SportListCell.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/9/2.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import TextAttributes

class SportListCell: BaseTableViewCell {
    
    override var dataSource: AnyObject? {
        didSet {
            guard let model = dataSource as? SportHistoryListModel else { return }
            iconImageView.image = model.sportType.image
            titleLabel.text = model.sportType.name
            switch model.sportType {
            case .treadmills:
                firstLabel.attributedText = attributed(text: model.total_distance?.commasString, unit: kmUnitStr)
                secondLabel.text = model.total_time
                thirdLabel.attributedText = attributed(text: model.total_cal?.commasString, unit: kcalUnitStr)
            case .smartspot:
                firstLabel.text = model.total_time
                secondLabel.attributedText = attributed(text: model.total_cal?.commasString, unit: kcalUnitStr)
                thirdLabel.text = nil
            default:
                firstLabel.attributedText = attributed(text: model.total_train_amount, unit: chineseJieStr)
                secondLabel.text = model.total_time
                thirdLabel.attributedText = attributed(text: model.total_cal?.commasString, unit: kcalUnitStr)
            }
        }
    }
    
    let playButton = BaseButton()
    var click: EmptyClosure?
    let attr = TextAttributes()
    let iconImageView = UIImageView()
    
    let firstLabel = BaseLabel()
    let secondLabel = BaseLabel()
    let thirdLabel = BaseLabel()
    
    let kcalUnitStr = NSAttributedString.init(string: " Kcal", attributes: [.font: UIFont.DINProBoldFontOf(size: 12)])
    let kmUnitStr = NSAttributedString.init(string: " Km", attributes: [.font: UIFont.DINProBoldFontOf(size: 12)])
    let chineseJieStr = NSAttributedString.init(string: " 节", attributes: [:])
    
    override func customizeInterface() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.width.equalTo(Layout.ScreenWidth - 30)
        }
        titleLabel = BaseLabel()
        titleLabel.textColor = UIColor.hx5c5e6b
        firstLabel.textColor = UIColor.hx129faa
        titleLabel.font = UIFont.bold15
        firstLabel.font = UIFont.DINProBoldFontOf(size: 15)
        containerView.addSubview(titleLabel)
        containerView.addSubview(firstLabel)
        containerView.addSubview(playButton)
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.left.equalTo(containerView).offset(8)
            make.bottom.equalTo(containerView).offset(-8)
        }
        
        playButton.setImage(UIImage.init(named: "sport_video"), for: .normal)
        playButton.snp.makeConstraints { (make) in
            make.right.equalTo(containerView).offset(-25)
            make.size.equalTo(CGSizeMake(24))
            make.top.equalTo(containerView).offset(10)
        }
        playButton.isUserInteractionEnabled = false
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).offset(7)
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.right.lessThanOrEqualTo(playButton.snp.left).offset(-15)
        }
        
        firstLabel.adjustsFontSizeToFitWidth = true
        firstLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.lastBaseline).offset(5)
            make.left.equalTo(titleLabel)
        }
        
        playButton.isHidden = true
        
        containerView.addSubview(secondLabel)
        containerView.addSubview(thirdLabel)
        
        secondLabel.adjustsFontSizeToFitWidth = true

        secondLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.DINProBoldFontOf(size: 15))
        thirdLabel.setUp(textColor: UIColor.hx129faa, font: UIFont.DINProBoldFontOf(size: 15))
        secondLabel.snp.makeConstraints { (make) in
            make.lastBaseline.equalTo(firstLabel)
            make.left.equalTo(firstLabel.snp.right).offset(14)
        }
        
        thirdLabel.adjustsFontSizeToFitWidth = true
        thirdLabel.snp.makeConstraints { (make) in
            make.lastBaseline.equalTo(firstLabel)
            make.left.equalTo(secondLabel.snp.right).offset(14)
            make.right.lessThanOrEqualTo(playButton.snp.left).offset(-15)
        }
        
    }
    
    func attributed(text: String?, unit: NSAttributedString) -> NSAttributedString {
        let str = text ?? "-"
        let project = NSAttributedString.init(string: str, attributes: [.font: UIFont.DINProBoldFontOf(size: 15)])
        let data = NSMutableAttributedString.init(attributedString: project)
        data.append(unit)
        return data
    }
    
}

