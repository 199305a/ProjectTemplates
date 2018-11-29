//
//  CoursesListHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/10.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CoursesListHeaderView: BaseView {

//    let topView = TopView()
    let bottomView = BottomView()
//    var isWholeType = false {
//        didSet {
//            bottomView.isHidden = !isWholeType
//            frame.size.height = isWholeType ? 140 : 80
//        }
//    }
    
    var serverDate:Date {
        get {
//            let timestamp = GlobalAction.serverTimestamp
//            let date = Date.init(timeIntervalSince1970: Double(timestamp))
            return Date()
        }
        set {
            
        }
    }
    
    var dateClick:IntClosure?
    
    
    
    let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let reuseIdentifier = "CoursesDateSelectCell"
    
    let formatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM.dd"
        fmt.timeZone = TimeZone.init(abbreviation: "GMT")!
        return fmt
    }()
    
    var selectedItem: Int = 0 {
        didSet {
            if let cell = self.collectionView.cellForItem(at:IndexPath.init(item: oldValue, section: 0))  as? CoursesDateSelectCell {
                //                cell.titleLabel.textColor = UIColor.hx9b9b9b
                cell.detailLabel.backgroundColor = UIColor.white
                cell.detailLabel.textColor = UIColor.hx5c5e6b
            }
            if let cell = self.collectionView.cellForItem(at:IndexPath.init(item: self.selectedItem, section: 0))  as? CoursesDateSelectCell {
//                cell.titleLabel.textColor = UIColor.hx5f5cf5
                cell.detailLabel.backgroundColor = UIColor.hx5c5e6b
                cell.detailLabel.textColor = UIColor.white
            }
        }
    }
    
    override func customizeInterface() {
        let itemWidth = (Layout.ScreenWidth - 30)/7
        collectionView.register(CoursesDateSelectCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth , height: 70)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        
//        frame = CGRectMake(0, 0, Layout.ScreenWidth, 80)
        frame = CGRectMake(0, 0, Layout.ScreenWidth, 60 + 100)
//        addSubview(topView)
        addSubview(bottomView)
        addSubview(collectionView)
        collectionView.shadow()
        collectionView.clipsToBounds = false
        collectionView.layer.cornerRadius = 6
        collectionView.backgroundColor = UIColor.white
//        topView.snp.makeConstraints { (make) in
//            make.left.top.right.equalTo(self)
//            make.height.equalTo(65)
//        }
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.top.equalTo(15)
            make.left.right.equalTo(self)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
            make.height.equalTo(70)
        }
        
    }
    
    class TopView: BaseView {
        
        var click: EmptyClosure?
        
        let addressLabel = BaseLabel()
        let distanceLabel = BaseLabel()
        let imageView = BaseImageView()
        
        override func customizeInterface() {
            backgroundColor = UIColor.white
            let view = UIView()
            view.backgroundColor = UIColor.hxc1c3c8.withAlphaComponent(0.18)
            view.layer.cornerRadius = 5
            addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalTo(self).inset(UIEdgeInsetsMake(10, 15, 10, 15))
            }
            view.addSubview(imageView)
            imageView.image = UIImage.init(named: "course_search")
            imageView.snp.makeConstraints { (make) in
                make.right.equalTo(view).offset(-15)
                make.centerY.equalTo(view)
            }
            view.addSubview(addressLabel)
            view.addSubview(distanceLabel)
            addressLabel.textColor = UIColor.hx5c5e6b
            addressLabel.font = UIFont.bold15
            addressLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(view)
                make.left.equalTo(view).offset(16)
            }
            distanceLabel.textColor = UIColor.hx9b9b9b
            distanceLabel.font = UIFont.boldAppFontOfSize(12)
            distanceLabel.snp.makeConstraints { (make) in
                make.left.equalTo(addressLabel.snp.right).offset(10).priority(500)
                make.bottom.equalTo(addressLabel)
                make.right.lessThanOrEqualTo(imageView.snp.right).offset(-6).priority(1000)
            }
            
            let tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            tap.rx.event.bind { [unowned self] (ges) in
                self.click?()
            }.disposed(by: disposeBag)
            addGestureRecognizer(tap)
        }
    }
    
    class BottomView: BaseTableViewCell {
        
        var click: EmptyClosure?
        let button = BaseButton()
        
        override func customizeInterface() {
            self.backgroundColor = UIColor.backgroundColor
            self.addSubview(button)
            button.setTitle(Text.AppointSelfHelpCourse, for: .normal)
            button.setImage(UIImage.init(named: "course_self_help"), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor.hx129faa
            button.titleLabel?.font = UIFont.bold15
            button.snp.makeConstraints { (make) in
                make.centerX.top.bottom.equalTo(self)
                make.left.equalTo(self).offset(15)
                make.right.equalTo(self).offset(-15)
                
            }
            button.layer.shadowOpacity = 0.5
            button.layer.shadowColor = UIColor.hx129faa.cgColor
            button.layer.shadowOffset = CGSizeMake(0, 1)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15)
            button.layer.cornerRadius = 5
            self.clipsToBounds = false
            button.rx.tap.bind { [unowned self] in
                self.click?()
            }.disposed(by: disposeBag)
        }
    }

}


extension CoursesListHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CoursesDateSelectCell
        
        let date = Date.init(timeInterval: TimeInterval(indexPath.row * 24 * 3600), since: self.serverDate)
        cell.detailLabel.text = formatter.string(from:date)
        
        cell.titleLabel.text = CalendarManager.tranformWeekToChineseCharacter(week: CalendarManager.weeklyOrdinality(date), prefix: "周")
        if indexPath.row == 0 {
            cell.titleLabel.text = "今天"
        }

        if indexPath.row == selectedItem {
            cell.detailLabel.backgroundColor = UIColor.hx5c5e6b
            cell.detailLabel.textColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.selectedItem = indexPath.row
        if self.dateClick != nil {
            self.dateClick!(indexPath.row)
        }
    }
    
}

class CoursesDateSelectCell: BaseCollectionViewCell {
    override func customizeInterface() {
        titleLabel = BaseLabel()
        detailLabel = BaseLabel()
        titleLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.font12)
        detailLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.font12)
        titleLabel.textAlignment = .center
        detailLabel.textAlignment = .center

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.backgroundColor = UIColor.clear
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-11)
            make.height.equalTo(20)
            make.width.equalTo(36)
        }
        
        detailLabel.layer.cornerRadius = 10
        detailLabel.clipsToBounds = true
    }

}

