//
//  SwitchStoreController.swift
//  CommaUser
//
//  Created by lekuai on 16/9/14.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

//MARK: - 描述 切换场馆
class SwitchStoreController: ListController {
    
    let reuseIdentifier = "StoreCell"
    let titleView = TitleImageView()
    let viewModel = OptionalStoreViewModel()
    
    var onlyShowGymStyle: Bool!
    var itemClick: ((ScanStoresModel)-> Void)?
    var currentSelectGymID: String? = CurrentGym.gym_id
    
    
    init(onlyShowGymStyle: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.onlyShowGymStyle = onlyShowGymStyle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.mj_header = nil
        updateDataFromNet()
        errorBackgroundView.forceRender = true
        errorBackgroundView.title = Text.CityHasNoGym
        errorBackgroundView.errorLabel.numberOfLines = 1
        errorBackgroundView.errorLabel.adjustsFontSizeToFitWidth = true
        errorBackgroundView.image = UIImage.init(named: "no-city")
    }
    
    override func setUpViews() {
        super.setUpViews()
        navigationItem.titleView = titleView
        
        if let id = CurrentGym.city_id {
            viewModel.cityId = id
            titleView.title = CurrentGym.city_name.nonOptional
        } else if let location = LocationManager.currentLocation, location.city_id != Text.UnknowCityID {
            viewModel.cityId = location.city_id
            titleView.title = location.city_name
        } else {
            titleView.title = "选择城市"
        }
        
        titleView.image = UIImage.init(named: "arrow-down")!
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(StoreCell.self)
        tableView.rowHeight = 135
        tableView.contentInset.top = 7.5
        tableView.contentInset.bottom = 7.5
        
        viewModel.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: StoreCell.self)) { [weak self] row, model, cell in
            
            guard let weakSelf = self else { return }
            cell.isNearest = row == 0 && !model.distance.nonOptional.isEmpty
            cell.selectedGymID = weakSelf.currentSelectGymID
            cell.model = model
            cell.storeInfoClosure = { store in
                let vc = StoreController(gymID: store.gym_id ?? "")
                weakSelf.pushAnimated(vc)
            }
            
            }.disposed(by: disposeBag)
        
        viewModel.hasCard.asObservable().bind { [weak self] (hasCard) in
            guard let this = self else { return }
            if !hasCard && GlobalAction.isLogin && !this.onlyShowGymStyle {
                this.tableView.tableHeaderView = this.noCardNoticeImgV
            } else {
                self?.tableView.tableHeaderView = nil
            }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { [unowned self] indexpath in
            let gym = self.viewModel.dataSource.value[indexpath.row]
            self.itemClick?(gym)
            self.outViewController(animated: true, model: gym)
            }.disposed(by: disposeBag)
        
    }
    
    override func setUpEvents() {
        
        titleView.tap?.bind{ [unowned self] (_) in
            self.toCityOptionVC()
        }.disposed(by: disposeBag)
        
    }
    
    override func updateDataFromNet() {
        viewModel.dataSource.value.removeAll()
        super.updateDataFromNet()
    }
    
    func toCityOptionVC() {
        let cityOptionalVC = CityOptionalController()
        cityOptionalVC.title = titleView.title
        cityOptionalVC.itemSeleted = { [weak self] cityId in
            guard let this = self else {
                return
            }
            this.titleView.title = this.getCityNameById(cityId).nonOptional
            this.viewModel.cityId = cityId
            this.updateDataFromNet()
        }
        let navC = PresentNavController.init(rootViewController: cityOptionalVC)
        self.present(navC, animated: true, completion: nil)
    }
    
    func outViewController(animated: Bool, model: ScanStoresModel) {
        
        if onlyShowGymStyle {
            currentSelectGymID = model.gym_id
            tableView.reloadData()
            navigationController?.popViewController(animated: animated)
            return
        }
        outViewController(animated: animated, id: model.gym_id)
    }
    
    func outViewController(animated: Bool, id: String?) {
        UserManager.shared.currentGymID = id ?? DefaultGymID
        _ = navigationController?.popToRootViewController(animated: animated)
    }
    
    /** 无卡提示图片 */
    lazy var noCardNoticeImgV: UIImageView = {
        let imgV = UIImageView(frame:CGRect(x: 15, y: 0, width: Layout.ScreenWidth - 30, height: 170.0 / 345 * (Layout.ScreenWidth - 30)))
        imgV.isUserInteractionEnabled = true
        imgV.image = UIImage(named: "no-card")
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(onNext: { [unowned self](_) in
            self.pushAnimated(CardsListController())
        }).disposed(by: disposeBag)
        imgV.addGestureRecognizer(tap)
        return imgV
    }()
    
    //根据城市Id获取城市名
    func getCityNameById(_ cityId:String) -> String? {
        for city in LocationManager.shared.openCities {
            if city.city_id == cityId {
                return city.city_name ?? ""
            }
        }
        return LocationManager.currentLocation?.city_name
    }
    
}






