//
//  SportChartView.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/9/18.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class SportChartView: BaseView {
    
    var model: SportListStatsModel? {
        didSet {
            guard let model = model else { return }
            setUpChartView(model: model)
            DispatchQueue.main.async {
                
                guard self.firstSelected && self.DataIsNotEmpty && self.dataCorrect else {
                    return
                }
                self.firstSelected = false
                let index = self.startDates.count - 1
                self.currentSelectedDate = self.startDates[index]
                let indexPath = IndexPath.init(row: index, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: [], animated: false)
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                self.currentStartDate = self.startDates[index]
                self.currentEndDate = self.endDates[index]
                self.chartSelected?(self.startDates[index], self.endDates[index])
            }
        }
    }
    
    let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let reuseIdentifier = "SportChartCell"
    var chartSelected: ((String, String) -> ())?
    var currentStartDate: String = ""
    var currentEndDate: String = ""
    
    
    let loadView = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
    
    var dataCorrect = false
    var startDates: [String] = []
    var endDates: [String] = []
    var durations: [Float] = []
    var maxValue: Float = 0
    let formatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"
        fmt.timeZone = TimeZone.init(abbreviation: "GMT")!
        return fmt
    }()
    
    var type: SportTitleType!
    
    var DataIsNotEmpty: Bool {
        if startDates.count > 0 && endDates.count > 0 && durations.count > 0 {
            return true
        }
        return false
    }
    
    var scrollToTop: StringClosure?
    
    var firstSelected = true
    var currentSelectedDate: String!
    
    let currentYear = CalendarManager.currentYearMonthDay().year
    
    var singlePageDataCount = 0
    let itemWidth: CGFloat = 80
    
    init(frame: CGRect, type: SportTitleType = .day) {
        super.init(frame: frame)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func customizeInterface() {
        backgroundColor = UIColor.clear
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.backgroundView = UIImageView.init(image: UIImage.init(named: "training_background"))
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self).offset(30)
        }
        
        let label = BaseLabel()
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.numberOfLines = 0
        label.font = UIFont.bold13
        label.text = "刷\n新\n数\n据"
        label.textAlignment = .center
        collectionView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(collectionView)
            make.right.equalTo(collectionView.snp.left).offset(-10)
            make.width.equalTo(20)
        }
        collectionView.addSubview(loadView)
        loadView.startAnimating()
        loadView.snp.makeConstraints { (make) in
            make.centerX.equalTo(label)
            make.top.equalTo(label.snp.lastBaseline).offset(10)
        }
        
        
        collectionView.register(SportChartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth , height: 255)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
    }
    
    func setUpChartView(model: SportListStatsModel) {
        var startDates: [String] = []
        var endDates: [String] = []
        var durations: [Float] = []
        model.list.forEach { model in
            if let date = model.start_date {
                startDates.append(date)
            }
            if let date = model.end_date {
                endDates.append(date)
            }
            if let dur = model.seconds, let duration = Float.init(dur) {
                durations.append(duration / 60)
            }
        }
        let count0 = model.list.count
        let count1 = startDates.count
        let count2 = durations.count
        let count3 = endDates.count
        guard count0 == count1 && count1 == count2 && count2 == count3 else {
            self.dataCorrect = false
            return
        }
        singlePageDataCount = count0
        self.startDates.insert(contentsOf: startDates.reversed(), at: 0)
        self.durations.insert(contentsOf: durations.reversed(), at: 0)
        self.endDates.insert(contentsOf: endDates.reversed(), at: 0)
        self.maxValue = self.durations.max() ?? 0
        self.dataCorrect = true
        
        reloadChartData()
    }
    
    
    func reloadChartData() {
        
        guard dataCorrect else {
            return
        }
        
        collectionView.reloadData()
        
        guard !self.firstSelected && self.DataIsNotEmpty else {
            return
        }
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.singlePageDataCount, section: 0), at: .left, animated: false)
            self.collectionView.setContentOffset(CGPoint.init(x: self.itemWidth * (CGFloat(self.singlePageDataCount) - 0.5), y: 0), animated: true)
            GlobalAction.delayPerformOnMainQueue(0.5) {
                self.collectionView.setContentOffset(CGPoint.init(x: self.itemWidth * CGFloat(self.singlePageDataCount), y: 0), animated: true)
            }
        }
        
    }
    
    func setUpTime(xVals: [String], index: Int) -> String {
        switch type! {
        case .day:
            return date(day: xVals, index: index)
        case .week:
            return  date(week: xVals, index: index)
        case .month:
            return  date(month: xVals, index: index)
        }
    }
    
    func date(day: [String], index: Int) -> String {
        let dateStr = startDates[index]
        let d = formatter.date(from: dateStr)
        guard let date = d else {
            return " \n "
        }
        // 转换星期
        let turple = CalendarManager.getYearMonthDayWithDate(date: date)
        guard let month = turple.month, let day = turple.day else {
            return " \n "
        }
        
        if let year = turple.year, currentYear == year {
            return String.init(format: "%02d.%02d", month, day)
        }
        
        let yearStr = turple.year == nil ? " " : String.init(turple.year!)
        
        return String.init(format: "%@.%02d.%02d", yearStr, month, day)
    }
    
    func date(week: [String], index: Int) -> String {
        let startStr = startDates[index]
        let endStr = endDates[index]
        let startD = formatter.date(from: startStr)
        let endD = formatter.date(from: endStr)
        guard let startDate = startD, let endDate = endD else {
            return " \n "
        }
        let startTurple = CalendarManager.getYearMonthDayWithDate(date: startDate)
        let endTurple = CalendarManager.getYearMonthDayWithDate(date: endDate)
        guard let sMonth = startTurple.month, let sDay = startTurple.day, let eMonth = endTurple.month, let eDay = endTurple.day else {
            return " \n "
        }
        
        if let year = startTurple.year, currentYear == year {
            return "\n" + String.init(format: "%02d.%02d-%02d.%02d", sMonth, sDay, eMonth, eDay)
        }
        
        let yearStr = startTurple.year == nil ? " " : String.init(startTurple.year!)
        
        return  yearStr + "\n" + String.init(format: "%02d.%02d-%02d.%02d", sMonth, sDay, eMonth, eDay)
        
        
    }
    
    func date(month: [String], index: Int) -> String {
        let dateStr = startDates[index]
        let d = formatter.date(from: dateStr)
        guard let date = d else {
            return " \n "
        }
        let turple = CalendarManager.getYearMonthDayWithDate(date: date)
        guard let month = turple.month else {
            return " \n "
        }
        
        if let year = turple.year, currentYear == year {
            return "\n" + String.init(month) + Text.Month
        }
        
        let yearStr = turple.year == nil ? " " : String.init(turple.year!)
        
        return  yearStr + "\n" + String.init(month) + Text.Month
    }
    
}



// delegates
extension SportChartView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return startDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SportChartCell
        cell.setUpData(dates: startDates, durations: durations, endDates: endDates, maxValue: maxValue, atIndexPath: indexPath)
        cell.timeLabel.text = setUpTime(xVals: startDates, index: indexPath.item)
        if currentSelectedDate != nil {
            cell.isSelected = startDates[safe: indexPath.item]  == currentSelectedDate
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        guard let start = startDates[safe: index], let end = endDates[safe: index] else {
            return
        }
        
        for (_, value) in collectionView.indexPathsForVisibleItems.enumerated() {
            if indexPath == value {
                continue
            }
            let cell = collectionView.cellForItem(at: value)
            if cell?.isSelected == true {
                cell?.isSelected = false
            }
        }
        
        currentSelectedDate = start
        self.currentStartDate = start
        self.currentEndDate = end
        chartSelected?(start, end)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        if x != -4 {
            return
        }
        
        guard let time = startDates.first else {
            return
        }
        scrollToTop?(time)
    }
}

class SportChartCell: BaseCollectionViewCell {
    
    var currentValue: Float = 0
    var dataViewHeight: CGFloat = 0
    
    func setUpData(dates: [String], durations: [Float], endDates: [String], maxValue: Float, atIndexPath indexPath: IndexPath) {
        let index = indexPath.item
        let value = durations[safe: index] ?? 0
        currentValue = value
        noDataImageView.isHidden = value != 0
        
        var height: CGFloat = maxValue == 0 ? 0 : (CGFloat(value / maxValue) * 158)
        if height >= 0 && height < 12 {
            height = 12
        }
        if height != dataViewHeight {
            dataViewHeight = height
            setNeedsUpdateConstraints()
        }
        
    }
    
    
    override var isSelected: Bool {
        didSet {
            
            timeLabel.textColor = isSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.6)
            dataView.backgroundColor = isSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
            gLayer.isHidden = !isSelected
            noDataImageView.image = isSelected ? UIImage.init(named: "no_workout_selected") : UIImage.init(named: "no_workout")
        }
    }
    
    let arrowImageView = UIImageView.init(image: UIImage.init(named: "sport_up"))
    let dataView = UIView()
    let timeLabel = BaseLabel()
    
    let gLayer = CAGradientLayer()
    
    let noDataImageView = UIImageView()
    
    
    override func customizeInterface() {
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.layer.addSublayer(gLayer)
        gLayer.colors = [UIColor.white.withAlphaComponent(0.01).cgColor, UIColor.white.withAlphaComponent(0.2).cgColor]
        gLayer.startPoint = CGPointMake(0.5, 0)
        gLayer.endPoint = CGPointMake(0.5, 1)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(dataView)
        contentView.addSubview(noDataImageView)
        
        dataView.layer.cornerRadius = 6
        dataView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        dataView.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(timeLabel.snp.top).offset(-14)
            make.height.equalTo(0)
        }
        
        timeLabel.numberOfLines = 2
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.DINProBoldFontOf(size: 12)
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-14)
            make.left.right.equalTo(contentView).inset(5)
        }
        

        noDataImageView.image = UIImage.init(named: "no_workout")
        noDataImageView.contentMode = .scaleToFill
        noDataImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(dataView)
            make.bottom.equalTo(dataView.snp.top).offset(-10)
        }
        noDataImageView.isHidden = true
        
        gLayer.isHidden = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gLayer.frame = contentView.bounds
        gLayer.frame.height = 160
        gLayer.frame.y = contentView.height - 160
    }
    
    override func updateConstraints() {
        dataView.snp.updateConstraints { make in
            make.height.equalTo(dataViewHeight)
        }
        super.updateConstraints()
    }
    
    
}

