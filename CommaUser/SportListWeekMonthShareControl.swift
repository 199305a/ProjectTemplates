//
//  SportListWeekMonthShareControl.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/10/17.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import TextAttributes

class SportListWeekMonthShareControl: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier = "SportListWeekMonthShareCell"
    
    var isHiddenKeepData = false {
        didSet {
            header.isHiddenKeepData = isHiddenKeepData
        }
    }
    
    let tableView = BaseTableView.init(frame: ScreenBounds, style: .plain)
    
    let header = SportListWeekMonthShareHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: Layout.ScreenWidth, height: 370))
    let footer = ShareFooterView.init(frame: CGRect.init(x: 0, y: 0, width: Layout.ScreenWidth, height: 145))
    
    
    var viewModel: SportListWeekMonthViewModel!
    
    var date: String?
    
    init(viewModel: SportListWeekMonthViewModel) {
        super.init()
        self.viewModel = viewModel
        setUp()
    }
    
    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        tableView.registerClass(SportListWeekMonthShareCell.self)
        tableView.backgroundColor = UIColor.hexColor(0x2C2D35)
        if SDK_Over_iOS11 {
            tableView.isAutoEstimatedHeightEnable = false
        }
    }
    
    func captureShot(imageClosure: ImageClosure?) {
        header.setUp(date: date, data: viewModel.dataSource.value, compelte: { [unowned self] in
            self.tableView.reloadData()
            DispatchQueue.main.async { [unowned self] in
                if let image = self.tableView.toLongImage {
                    imageClosure?(image)
                }
            }
        })
    }
    
    // MARK: - collection view delegate methods & data sources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SportListWeekMonthShareCell
        cell.setUpModel(viewModel.dataSource.value, atIndexPath: indexPath)
        return cell
    }
    
    
}


class SportListWeekMonthShareCell: BaseTableViewCell {
    
    let rightLabel = BaseLabel()
    let attr = TextAttributes()
    let theImageView = UIImageView()
    let backView = UIView()
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        backView.backgroundColor = UIColor.hexColor(0x23272A)
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
        }
        titleLabel = BaseLabel()
        titleLabel.font = UIFont.boldAppFontOfSize(14)
        titleLabel.textColor = UIColor.hexColor(0xf5f5f5)
        detailLabel = BaseLabel()
        contentView.addSubview(theImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(rightLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(25)
            make.centerY.equalTo(theImageView)
        }
        
        theImageView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.left).offset(110)
            make.centerY.equalTo(contentView)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-25)
            make.centerY.equalTo(titleLabel)
        }
        
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(rightLabel.snp.left).offset(-35)
            make.centerY.equalTo(titleLabel)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8)
        }
    }
    
    override func setUpModel(_ aModel: AnyObject?, atIndexPath indexPath: IndexPath) {
        guard let model = aModel as? SportListWeekMonthDataModel else {
            return
        }
        
        let unit: String
        let detail: String
        let title: String
        let right: String
        var image: UIImage?
        switch indexPath.row {
        case 0:
            unit = "  " + Text.Kms
            title = Text.RunStep
            detail = model.run_distance ?? "-"
            right = model.run_time ?? "-"
            image = UIImage.init(named: "sport_run")
        case 1:
            unit = "  " + Text.Times
            title = Text.PowerTraining
            detail = model.smartspot_exercise ?? "-"
            right = model.smartspot_time ?? "-"
            image = UIImage.init(named: "sport_SMARTSPOT")
        case 2:
            unit = "  " + Text.Times
            title = Text.GroupClass
            detail = model.course ?? "-"
            right = model.course_time ?? "-"
            image = UIImage.init(named: "sport_course")
        default:
            unit = "  " + Text.Times
            title = Text.PrivateClass
            detail = model.personal ?? "-"
            right = model.personal_time ?? "-"
            image = UIImage.init(named: "sport_trainer")
        }
        
        attr.font(UIFont.init(name: Text.Impact, size: 25)).foregroundColor(UIColor.hx34c86c)
        let detail0 = NSAttributedString.init(string: detail, attributes: attr)
        let right0 = NSAttributedString.init(string: right, attributes: attr)
        attr.font(UIFont.init(name: Text.Impact, size: 12)).foregroundColor(UIColor.hexColor(0xf5f5f5))
        let detail1 = NSAttributedString.init(string: unit, attributes: attr)
        let right1 = NSAttributedString.init(string: "  " + Text.Minutes, attributes: attr)
        
        let detailStr = NSMutableAttributedString.init(attributedString: detail0)
        detailStr.append(detail1)
        
        let rightStr = NSMutableAttributedString.init(attributedString: right0)
        rightStr.append(right1)
        
        theImageView.image = image
        titleLabel.text = title
        detailLabel.attributedText = detailStr
        rightLabel.attributedText = rightStr
    }
    
}

class SportListWeekMonthShareHeaderView: BaseView {
    
    func setUp(date: String?, data: SportListWeekMonthDataModel?, compelte: EmptyClosure?) {
        guard let model = data else {
            return
        }
        let user = AppUser
        bigImageView.sd_setImage(with: user.avatar?.toURL, placeholderImage: UIImage.PlaceHolderAvatar)
        avatarImageView.sd_setImage(with: user.avatar?.toURL, placeholderImage: UIImage.PlaceHolderAvatar, options: []) { (_, _, _, _) in
            compelte?()
        }
        nameLabel.text = user.user_name
        detailLabel.text = (date ?? " ") + "\n" + "在CommaUser健身累计训练"
        
        for (index, view) in views.enumerated() {
            var title: String?
            var detail: String?
            var unit: String?
            switch index {
            case 0:
                title = Text.AllExcise
                detail = model.total_seconds
                unit = Text.Minutes
            case 1:
                title = Text.KeepExcise
                detail = model.total_day
                unit = Text.Day
                
            default:
                title = Text.AllBurn
                detail = model.total_cal
                unit = Text.ThousandCal
                
            }
            
            view.setUp(title: title, detail: detail, unit: unit)
        }
    }
    
    var isHiddenKeepData = false {
        didSet {
            reLayout()
        }
    }
    
    let avatarImageView = CycleImageView()
    let detailLabel = BaseLabel()
    let nameLabel = BaseLabel()
    let titleLabel = BaseLabel()
    let backView = UIView()
    let topView = UIView()
    let bigImageView = FillImageView()
    let upLine = UIView()
    let bottomLine = UIView()
    var views: [dataView] = []
    let contentView = UIView()
    let detailImageView = UIImageView.init(image: UIImage.init(named: "sport_details"))
    
    override func customizeInterface() {
        addSubview(bigImageView)
        addSubview(topView)
        addSubview(backView)
        addSubview(avatarImageView)
        addSubview(detailLabel)
        addSubview(nameLabel)
        addSubview(upLine)
        addSubview(bottomLine)
        addSubview(contentView)
        addSubview(detailImageView)
        addSubview(titleLabel)
        
        bigImageView.alpha = 0.1
        bigImageView.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self)
            make.size.equalTo(Layout.ScreenWidth)
        }
        
        
        topView.backgroundColor = UIColor.hexColor(0x23272A)
        let layer = topView.layer
        layer.cornerRadius = 3
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.height.equalTo(15)
        }
        
        backView.backgroundColor = UIColor.hexColor(0x23272A)
        backView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.top.equalTo(topView.snp.bottom).offset(-5)
            make.left.right.equalTo(topView)
        }
        
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.layer.borderColor = UIColor.hexColor(0x4B4F5A).cgColor
        avatarImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(60))
            make.centerY.equalTo(topView.snp.top)
            make.centerX.equalTo(self)
        }
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.appFontOfSize(11)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.width.equalTo(Layout.ScreenWidth - 50)
        }
        
        detailLabel.textColor = UIColor.white
        detailLabel.font = UIFont.bold15
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 2
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(nameLabel.snp.lastBaseline).offset(25)
            make.width.equalTo(Layout.ScreenWidth - 50)
        }
        
        upLine.backgroundColor = UIColor.hexColor(0x363A3D)
        upLine.snp.makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(25, 2))
            make.centerX.equalTo(self)
            make.top.equalTo(detailLabel.snp.lastBaseline).offset(30)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(Layout.ScreenWidth - 50)
            make.top.equalTo(upLine.snp.bottom).offset(35)
            make.height.equalTo(40)
        }
        
        let width = (Layout.ScreenWidth - 50) / 3
        for index in 0...2 {
            let view = dataView()
            contentView.addSubview(view)
            views.append(view)
            view.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(contentView)
                make.width.equalTo(width)
                make.left.equalTo(contentView).offset(CGFloat(index) * width)
            }
        }
        
        bottomLine.backgroundColor = UIColor.hexColor(0x363A3D)
        bottomLine.snp.makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(25, 2))
            make.centerX.equalTo(self)
            make.top.equalTo(contentView.snp.bottom).offset(30)
        }
        
        titleLabel.font = UIFont.boldAppFontOfSize(17)
        titleLabel.text = Text.JoinedItem
        titleLabel.textColor = UIColor.hx34c86c
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.lastBaseline.equalTo(self.snp.bottom).offset(-25)
        }
        
        detailImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(44)
            make.lastBaseline.equalTo(self.snp.bottom).offset(-32)
        }
    }
    
    class dataView: UIView {
        
        let titleLabel = BaseLabel()
        let detailLabel = BaseLabel()
        let attr = TextAttributes()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(titleLabel)
            addSubview(detailLabel)
            titleLabel.textAlignment = .center
            detailLabel.textAlignment = .center
            titleLabel.adjustsFontSizeToFitWidth = true
            detailLabel.adjustsFontSizeToFitWidth = true
            titleLabel.snp.makeConstraints { (make) in
                make.left.right.top.equalTo(self)
            }
            detailLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(titleLabel.snp.lastBaseline).offset(13)
            }
            titleLabel.textColor = UIColor.hexColor(0x95979e)
            titleLabel.font = UIFont.boldAppFontOfSize(11)
            attr.alignment(.center)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUp(title: String?, detail: String?, unit: String?) {
            titleLabel.text = title
            attr.foregroundColor(UIColor.hx34c86c).font(UIFont.init(name: Text.Impact, size: 18))
            let d = NSAttributedString.init(string: detail ?? "-", attributes: attr)
            attr.foregroundColor(UIColor.white)
            attr.font(UIFont.boldAppFontOfSize(11))
            let u = NSAttributedString.init(string: "  " + (unit ?? "-"), attributes: attr)
            let text = NSMutableAttributedString.init(attributedString: d)
            text.append(u)
            detailLabel.attributedText = text
        }
    }
    
    func reLayout() {
        let w: CGFloat = isHiddenKeepData ? 2 : 3
        let width = (Layout.ScreenWidth - 50) / w
        for (index, view) in views.enumerated() {
            if !isHiddenKeepData {
                view.isHidden = false
                view.snp.remakeConstraints { (make) in
                    make.top.bottom.equalTo(contentView)
                    make.width.equalTo(width)
                    make.left.equalTo(contentView).offset(CGFloat(index) * width)
                }
            } else {
                var idx = index
                if index == 1 {
                    view.isHidden = true
                    continue
                }
                if index == 2 {
                    idx = 1
                }
                view.snp.remakeConstraints { (make) in
                    make.top.bottom.equalTo(contentView)
                    make.width.equalTo(width)
                    make.left.equalTo(contentView).offset(CGFloat(idx) * width)
                }
            }
        }
    }
    
}

