//
//  GymMapController.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/7/25.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import MapKit

//MARK: - 描述 地图导航
class GymMapController: TableController, MAMapViewDelegate, UITableViewDataSource {
    
    let pointReuseIndentifier = "pointReuseIndentifier"
    let reuseIdentifier = "GymMapCell"
    
    var mapView: MAMapView!
    var mapType = MapPlatformType.native
    let model: GymMapProtocol
    
    init(model: GymMapProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.MapNavigation
    }
    
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(GymMapCell.self)
        tableView.dataSource = self
        tableView.rowHeight = Layout.ScreenHeight - Layout.TopBarHeight
        tableView.isScrollEnabled = false
    }
    
    func setUpMapView(cell: GymMapCell) {
        mapView = cell.mapView
        mapView.delegate = self
        cell.dataSource = model
        addGymLocation()
        cell.buttonClick = { [weak self] in
            guard let this = self else {
                return
            }
            this.showMapSelection()
        }
        
    }
    
    func toNavigator() {
        switch mapType {
        case .native:
            openMapAppWithNative()
        case .gaode:
            openMapAppWithGaode()
        case .baidu:
            openMapAppWithBaidu()
        case .tencent:
            openMapAppWithTencent()
        }
    }
    
    func addGymLocation() {
        let pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = model.coordinate
        pointAnnotation.title = model.gymName
        pointAnnotation.subtitle = model.gymAddress
        mapView.addAnnotation(pointAnnotation)
        DispatchQueue.main.async {
            self.mapView.zoomLevel = 15
            self.mapView.centerCoordinate = pointAnnotation.coordinate
        }
    }
    
    func showMapSelection() {
        let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        addAction(vc: vc, mapType: .native)
        addAction(vc: vc, mapType: .gaode)
        addAction(vc: vc, mapType: .baidu)
        addAction(vc: vc, mapType: .tencent)
        
        let cancelAction = UIAlertAction.init(title: Text.Cancel, style: .cancel, handler: nil)
        vc.addAction(cancelAction)
        
        present(vc, animated: true, completion: nil)
    }
    
    func addAction(vc: UIAlertController, mapType: MapPlatformType) {
        
        func addAction() {
            let action = UIAlertAction.init(title: mapType.name, style: .default) { [unowned self] _ in
                self.mapType = mapType
                self.toNavigator()
            }
            vc.addAction(action)
        }
        
        if mapType.url == nil {
            addAction()
            return
        }
        
        if let url = mapType.url, UIApplication.shared.canOpenURL(url) {
            addAction()
        }
        
        
        
        
    }
    
    
    // MARK: - table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GymMapCell
        setUpMapView(cell: cell)
        return cell
    }
    
    
    // MARK: - map view delegate methods
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        guard annotation is MAPointAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier) as? MAPinAnnotationView
        
        if annotationView == nil {
            annotationView = MAPinAnnotationView.init(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
        }
        
        annotationView?.animatesDrop = true
        annotationView?.isDraggable = true
        
        return annotationView
    }
    
}

extension GymMapController {
    
    func openMapAppWithNative() {
        
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: model.coordinate, addressDictionary: nil))
        MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true])
    }
    
    func openMapAppWithGaode() {
        let coordinate = model.coordinate
        let urlString = String.init(format: "iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2", AppName, AppKey.AppScheme, coordinate.latitude, coordinate.longitude).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let str = urlString, let url = URL.init(string: str) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func openMapAppWithBaidu() {
        let coordinate = model.coordinate
        let urlString = String.init(format: "baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let str = urlString, let url = URL.init(string: str) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func openMapAppWithTencent() {
        let coordinate = model.coordinate
        let urlString = String.init(format: "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",coordinate.latitude, coordinate.longitude).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let str = urlString, let url = URL.init(string: str) {
            UIApplication.shared.openURL(url)
        }
    }
}


enum MapPlatformType: Int {
    case native
    case gaode
    case baidu
    case tencent
    
    var url: URL? {
        var str: String?
        switch self {
        case .gaode:
            str = "iosamap://"
        case .baidu:
            str = "baidumap://"
        case .tencent:
            str = "qqmap://"
        default:
            break
        }
        if let string = str {
            return URL.init(string: string)
        }
        return nil
    }
    
    var name: String {
        let str: String
        switch self {
        case .native:
            str = Text.AppleMap
        case .gaode:
            str = Text.GaodeMap
        case .baidu:
            str = Text.BaiduMap
        case .tencent:
            str = Text.TencentMap
        }
        return str
    }
    
}
