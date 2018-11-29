//
//  CityOptionalController.swift
//  CommaUser
//
//  Created by lekuai on 17/2/15.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
//MARK: - 描述 城市选择
class CityOptionalController: TableController, UITableViewDataSource {
    
    typealias CityArray = [CityModel]
    let reuseIdentifier = "CityNameCell"
    var searchV: CustomSearchView!
    var locView: LocationStateView!
    var letterKeys = [String]()
    var citiesDic = [String : CityArray]()
    var filteredCities = CityArray()
    var searchResults: Observable<CityArray>!
    var isShowAllCities: Bool {
        return searchV?.searchBar?.text?.isEmpty ?? true
    }
    var searchEmptyView: ErrorBackgroundView!
    var itemSeleted: ((String)->Void)?
    lazy var locatingIndicatorV: UIActivityIndicatorView = {
        let indicatorV = UIActivityIndicatorView()
        indicatorV.activityIndicatorViewStyle = .gray
        indicatorV.hidesWhenStopped = true
        return indicatorV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        if LocationManager.shared.openCities.isEmpty {
            updateDataFromNet()
        } else {
            sortCitis()
            refreshPage()
        }
    }
    
    override func setUpViews() {
        
        searchV = CustomSearchView(frame: CGRect.init(x: 0, y: 0, width: Layout.ScreenWidth, height: 55))
        view.addSubview(searchV)
        searchV.backgroundColor = UIColor.white
        searchV.isHidSystemBorder = true
        searchV.textFieldHeight = 35
        searchV.layer.shadowColor = UIColor.black.cgColor
        searchV.layer.shadowOpacity = 0.06
        searchV.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        let cancelBtn = searchV.cancelBtn
        cancelBtn.setTitle(Text.Cancel, for: .normal)
        cancelBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let searchBar = searchV.searchBar
        searchBar?.placeholder = Text.CitySearchPlaceholder
        
        locView = LocationStateView()
        view.addSubview(locView)
        locView.snp.makeConstraints { (make) in
            make.top.equalTo(searchV.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(123)
        }
        
        if let curLoc = LocationManager.currentLocation {
            locView.state = .success
            locView.locBtn.setTitle(curLoc.city_name, for: .normal)
        } else {
            locView.state = .fail
        }
        
        searchV.updateSearchResults = { [unowned self] searchV in
            if !searchV.searchBar.isFirstResponder {
                self.refreshPage()
            }
        }
        
        searchEmptyView = ErrorBackgroundView()
        view.addSubview(searchEmptyView)
        searchEmptyView.errorImageView.image = UIImage(named: "no-city")
        searchEmptyView.errorButton.isHidden = true
        searchEmptyView.errorLabel.text = Text.NoResult
        searchEmptyView.isHidden = true
        
        super.setUpViews()
        
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.dataSource = self
        tableView.registerClass(CityNameCell.self)
        tableView.sectionIndexColor = UIColor.hx596167
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(locView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        searchEmptyView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalTo(view)
            make.top.equalTo(tableView.snp.top)
        }
        view.bringSubview(toFront: searchEmptyView)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 45
    }
    
    override func setUpEvents() {
        
        locView.locBtn.rx.tap.bind { [unowned self] in
            if let cityId = LocationManager.currentLocation?.city_id {
                self.selectCity(cityId: cityId)
            } else {
                //重新定位
                self.locView.state = .locating
                LocationManager.startLocating()
                if LocationManager.shared.openCities.isEmpty {
                    LocationManager.shared.requestOpenCityIdList()
                }
            }
            }.disposed(by: disposeBag)
        
        searchResults = searchV.searchBar.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).flatMapLatest { [unowned self] (query) -> Observable<CityArray> in
            if query.replacingOccurrences(of: " ", with: "").isEmpty {
                return .just([])
            }
            return self.searchByKeyword(keyword: query).catchErrorJustReturn([])
            }.observeOn(MainScheduler.instance)
        
        searchResults.bind { [unowned self] (cities) in
            self.filteredCities = cities
            self.refreshPage()
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotiKey.LocationUpdated).bind {[unowned self] noti in
            if noti.object as? Bool == true { // 定位成功
                self.locView.state = .success
                self.locView.locBtn.setTitle(LocationManager.currentLocation?.city_name, for: .normal)
                DispatchQueue.main.async {
                    self.sortCitis()
                    self.refreshPage()
                }
                return
            }
            self.locView.state = .fail
            // 定位失败
            if !LocationManager.shared.locationEnable {
                LFAlertView.showLocationSettingPrompt()
            }
            }.disposed(by: disposeBag)
        
        LocationManager.shared.isLocatingObserver.bind { [unowned self] (isLocating) in
            if isLocating {
                self.locView.state = .locating
            }
        }.disposed(by: disposeBag)
    }
    
    override func updateDataFromNet() {
        NetWorker.get(ServerURL.GetOpenCityList, success: { (dataObj) in
            guard let openCityIds = dataObj.parseList as? [String] else {
                return
            }
            LocationManager.shared.openCityIdList = openCityIds
            LocationManager.shared.generateOpenCities()
            DispatchQueue.main.async {
                self.sortCitis()
                self.refreshPage()
            }
        }, error: { (statusCode, message) in
            dLog(message)
        }) { (error) in
            dLog(error)
        }
    }
    
    func refreshPage() {
        tableView.reloadData()
        if isShowAllCities {
            locView.snp.remakeConstraints { (make) in
                make.top.equalTo(searchV.snp.bottom)
                make.left.right.equalTo(view)
                make.height.equalTo(123)
            }
            locView.isHidden = false
            searchEmptyView.isHidden = true
        } else {
            locView.snp.remakeConstraints { (make) in
                make.top.equalTo(searchV.snp.bottom)
                make.left.right.equalTo(view)
                make.height.equalTo(1)
            }
            locView.isHidden = true
            searchEmptyView.isHidden = !filteredCities.isEmpty
        }
    }
    
    // tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return isShowAllCities ? letterKeys.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowAllCities ? citiesDic[letterKeys[section]]!.count : filteredCities.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isShowAllCities ? letterKeys : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isShowAllCities ? 25 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isShowAllCities { return nil }
        let sectionV = SectionView(height: 25)
        sectionV.backgroundColor = UIColor.hexColor(0xeaeef0)
        let label = BaseLabel()
        sectionV.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(sectionV).offset(17)
            make.top.bottom.right.equalTo(sectionV)
        }
        label.text = letterKeys[section]
        label.font = UIFont.boldAppFontOfSize(12)
        label.textColor = UIColor.hx5c5e6b
        return sectionV
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CityNameCell
        if isShowAllCities {
            let sectionCities = citiesDic[letterKeys[indexPath.section]]
            cell.city = sectionCities?[indexPath.row]
            cell.xline.isHidden = sectionCities?.count == indexPath.row + 1
        } else {
            if let city = filteredCities[safe:indexPath.row] {
                cell.city = city
            }
            cell.xline.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var tempCity: CityModel?
        if isShowAllCities {
            tempCity = citiesDic[letterKeys[indexPath.section]]?[indexPath.row]
        } else {
            tempCity = filteredCities[indexPath.row]
            
        }
        guard let cityId = tempCity?.city_id else {
            return
        }
        selectCity(cityId: cityId)
        dismiss(animated: true, completion: nil)
    }
    
    func searchByKeyword(keyword: String) -> Observable<CityArray> {
        let tempCities: CityArray = LocationManager.shared.openCities.filter { matchCity(city: $0, keyword: keyword) }
        return Observable<CityArray>.from(optional: tempCities)
    }
    
    func matchCity(city: CityModel, keyword: String) -> Bool {
        //处理city
        let cityName = city.city_name
        let pinyin = cityName?.pinyinValue().lowercased()
        
        let pinyin_initial = pinyin!.components(separatedBy: " ").map { (str) -> String in
            return String(str[..<str.index(str.startIndex, offsetBy: 1)])
            }.joined()
        let pinyinNoSpace = pinyin?.replacingOccurrences(of: " ", with: "")
        let dest = [cityName, pinyin_initial, pinyinNoSpace]
        //处理keyword
        let keyword = keyword.trimmingCharacters(in: CharacterSet.whitespaces).replacingOccurrences(of: " ", with: "").lowercased()
        
        return dest.filter({ (str) -> Bool in
            return str?.hasPrefix(keyword) ?? false
        }).count > 0
        
    }
    
    //
    func selectCity(cityId: String) {
        itemSeleted?(cityId)
        dismiss(animated: true, completion: nil)
    }
    
    
    //城市按拼音首字母排序
    func sortCitis()  {
        let allCities = LocationManager.shared.openCities
        letterKeys.removeAll()
        citiesDic.removeAll()
        allCities.forEach { (city) in
            if let cityName = city.city_name {
                let cityPinyin = cityName.pinyinValue()
                let initailIndex = cityPinyin.index(cityPinyin.startIndex, offsetBy: 1)
                let initail = String(cityPinyin[..<initailIndex]).uppercased()
                if !letterKeys.contains(initail) {
                    letterKeys.append(initail)
                    citiesDic[initail] = CityArray()
                }
                citiesDic[initail]?.append(city)
            }
        }
        letterKeys.sort()
        citiesDic.forEach { (key, value) in
            citiesDic[key] = value.sorted(by: { (city1, city2) -> Bool in
                return city1.city_name!.pinyinValue() < city2.city_name!.pinyinValue()
            })
        }
        
    }
    
    deinit {
        debugPrint("销毁")
    }
    
}




