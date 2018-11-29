//
//  LocationManager.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD
import RxSwift
import RxCocoa

class LocationManager: NSObject, AMapLocationManagerDelegate, AMapSearchDelegate {
    
    static let shared = LocationManager()
    static var currentLocation: LocationModel?
    let locManager = CLLocationManager()   // 苹果原生位置管理器
    let amapLocManager = AMapLocationManager() // 高德地图管理器
    let search = AMapSearchAPI() // 高德地图搜索类
    //所有省市
    var region: [ProvinceModel]?
    // 开通的城市列表
    var openCityIdList = [String]()
    var openCities = [CityModel]()
    
    static var CurrentLocationIsKnown: Bool { return currentLocation != nil }
    static var didChangedAuthStatus = false // 是否调用了amap的授权改变方法
    // 正在定位
    static var isLocating: Bool = false  {
        didSet {
            shared.isLocatingObserver.onNext(isLocating)
        }
    }
    static var isReGeocodeSearching: Bool = false // 正在反地理编码
    
    let isLocatingObserver = PublishSubject<Bool>()
    
    let cityHandleQueue = OperationQueue()
    //操作
    var allCitiesOperation: Operation!
    var openCitiesOpration: Operation!
    
    private override init() {
        super.init() // 初始化高德地图
        amapLocManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        amapLocManager.pausesLocationUpdatesAutomatically = false
        amapLocManager.delegate = self
        search?.delegate = self
        
        allCitiesOperation = BlockOperation(block: {
            self.resolveRegionDataSource()
        })
        openCitiesOpration = BlockOperation(block: {
            self.generateOpenCities()
        })
        openCitiesOpration.addDependency(allCitiesOperation)
        
    }
    
    // 解析所有城市信息
    func resolveRegionDataSource() {
        let path = Bundle.main.path(forResource: "region", ofType: ".plist")
        let dict = NSDictionary(contentsOfFile: path!)
        region = ProvinceModel.parses(arr: dict!["regions"] as! NSArray) as? [ProvinceModel]
    }
    
    // 处理所有开通城市
    func generateOpenCities() {
        guard let region = LocationManager.shared.region else {
            return
        }
        var openCities = [CityModel]()
        for province in region {
            guard let cities = province.cities else { continue }
            for city in cities {
                guard let code = city.city_code else { continue }
                if openCityIdList.contains(code) {
                    openCities.append(city)
                }
            }
        }
        self.openCities = openCities
    }
    
    // 根据cityCode找到城市
    func getCityInfo(cityCode: String?) -> CityModel? {
        guard let region = region,
              let cityCode = cityCode else {
            return nil
        }
        for province in region {
            guard let cities = province.cities else { continue }
            for city in cities {
                guard let code = city.city_code else { continue }
                if cityCode == code {
                    return city
                }
            }
        }
        return nil
    }
    
    // 停止定位
    class func stopLocating() {
        shared.amapLocManager.stopUpdatingLocation() // 关闭定位
    }
    
    /**
     启动定位
     
     - parameter showMessage: 是否有loading
     返回值： 是否已经开始了高德定位
     */
    class func startLocating() {
        if isLocating { return }
        
        // 如果没决定授权状态，请求一次授权（弹框），然后跳出函数。 * 会在请求授权的函数里面，会再次发起定位
        if LocationManager.shared.requestingAuthorization() {
            return
        }
        if !LocationManager.shared.locationEnable {
            LocationManager.handleForLocationFailed()
            return
        }
        
        isLocating = true
        LocationManager.shared.amapLocManager.startUpdatingLocation()
    }
    
    // 对获得的定位进行设置
    class func setCurrentCity(_ coordinate: CLLocationCoordinate2D,reGeocode: AMapReGeocode) {
        let model = LocationModel()
        model.city_name = reGeocode.addressComponent.city
        model.city_code = reGeocode.addressComponent.citycode
        let city = shared.getCityInfo(cityCode: model.city_code)
        model.city_id = city?.city_id ?? "0"
        model.district_id = reGeocode.addressComponent.adcode ?? "0"
        model.longitude = "\(coordinate.longitude)"
        model.latitude = "\(coordinate.latitude)"
        model.reGeocode = reGeocode
        currentLocation = model
    }
    
    
    class func handleForLocationFailed() {
        LocationManager.currentLocation = nil
        LocationManager.isLocating = false
        NotificationCenter.default.post(name: NotiKey.LocationUpdated, object: false)
    }
    
    // 开启逆地理查询
    func searchReGeocodeWithCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let regeo = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        search?.aMapReGoecodeSearch(regeo)
        LocationManager.isReGeocodeSearching = true
    }
    
    // MARK: - location delegate
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        debugPrint(error)
        LocationManager.stopLocating() // 关闭定位
        LocationManager.handleForLocationFailed() // 处理定位失败
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        if LocationManager.isReGeocodeSearching { // 如果正在查询逆向地理编码，则跳出
            return
        }
        LocationManager.stopLocating() // 关闭定位
        // 定位拿到的经纬度无效
        if location == nil {
            // 处理定位失败
            LocationManager.handleForLocationFailed()
            return
        }
        // 拿到经纬度有效，去查询地理
        searchReGeocodeWithCoordinate(location.coordinate)
        
    }
    
    //MARK:- AMapSearchDelegate
    
    // 逆地理查询失败
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        // 处理定位失败
        LocationManager.isReGeocodeSearching = false
        LocationManager.handleForLocationFailed()
        
        debugPrint("request :\(request), error: \(error)")
    }
    
    
    
    // 逆地理查询回调
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        dLog("response :\(response.formattedDescription())")
        LocationManager.isReGeocodeSearching = false
        // 逆地理数据失败
        guard let regeocode = response.regeocode else {
            LocationManager.handleForLocationFailed()
            return
        }
        // 逆地理数据成功
        let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
        LocationManager.isLocating = false // 去掉正在定位标识
        
        let operation = BlockOperation.init {
            LocationManager.setCurrentCity(coordinate, reGeocode: regeocode)
            OperationQueue.main.addOperation {
                NotificationCenter.default.post(name: NotiKey.LocationUpdated, object: true)
            }
        }
        operation.addDependency(allCitiesOperation)
        cityHandleQueue.addOperation(operation)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
        LocationManager.didChangedAuthStatus = true
        // 如果上一次定位失败，则开启定位
        if !LocationManager.CurrentLocationIsKnown {
            _ = LocationManager.startLocating()
        }
        
    }
}

extension LocationManager {
    //判断定位服务是否打开
    var severceEnable: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    //判断是否授权
    var authorized: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    //MARK: - 判断用户是否允许定位
    var locationEnable: Bool {
        return severceEnable && authorized
    }
    
    //MARK: - 展示授权弹框
    func requestingAuthorization() -> Bool {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locManager.requestWhenInUseAuthorization()
            return true
        }
        return false
    }
}

extension LocationManager {
    
    func handleCitiesInfo() {
        requestOpenCityIdList()
    }
    
    func requestOpenCityIdList(success: EmptyClosure? = nil) {
        NetWorker.get(ServerURL.GetOpenCityList, success: { (dataObj) in
            guard let idList = dataObj.parseList as? [String], !idList.isEmpty else {
                return
            }
            self.openCityIdList = idList
            self.executeFilterOpenCities()
            success?()
        }, error: { (statusCode, message) in
            dLog("获取开通城市列表失败：\(message)")
        }) { (error) in
            dLog("获取开通城市列表失败")
        }
    }
    
    func executeGetRegionFromDisk() {
        if cityHandleQueue.operations.contains(allCitiesOperation) || region != nil {
            return
        }
        cityHandleQueue.addOperation(allCitiesOperation)
    }
    
    func executeFilterOpenCities() {
        if cityHandleQueue.operations.contains(openCitiesOpration) || !openCities.isEmpty  {
            return
        }
        cityHandleQueue.addOperation(openCitiesOpration)
    }
}


class LocationModel: BaseModel {
    var longitude: String = "0"
    var latitude: String = "0"
    var city_id: String = Text.UnknowCityID
    var city_name: String = Text.UnknowCity
    var city_code: String?
    var district_id: String = "0"
    var reGeocode: AMapReGeocode? // 地理信息
    var coordinate: CLLocationCoordinate2D { // 坐标
        return CLLocationCoordinate2D.init(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
    }
    var inCityList: Bool { // 当前城市是否在城市列表中
        guard let cityCode = city_code, city_name != Text.UnknowCity else { return false }
        return LocationManager.shared.openCities.contains(where: { $0.city_code == cityCode })
    }
}

class ProvinceModel: BaseModel {
    var cities: [CityModel]?
    var province_id: String?
    var province_name: String?
}


class CityModel: BaseModel {
    var city_id: String?
    var city_name: String?
    var city_code: String?
    var districts: [DistrictModel]?
}

class DistrictModel: BaseModel {
    var district_id: String?
    var district_name: String?
}

extension CityModel {
    func getDistrict(_ districtId: String) -> DistrictModel? {
        return districts?.filter({ $0.district_id == districtId }).first
    }
}
