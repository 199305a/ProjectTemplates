//
//  StoreController.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/16.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - 描述 门店详情
class StoreController: TableController, CustomNavBarCompatible {
    
    let bannerView = BannerView(frame: CGRectMake(0, 0, Layout.ScreenWidth, 395.reH), delegate: nil, placeholderImage: nil)
    let callItem = CallBarButtonItem()
    let viewModel = GymInfoViewModel()
    var gymID: String!
    let footer = GymInfoFooterView()
    var statusImageView: UIImageView?
    
    init(gymID: String) {
        super.init(nibName: nil, bundle: nil)
        self.gymID = gymID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromNet()
        customizeNavigationBar()
        handleNaviColorWhenError()
        changeTintColorWhenAppearOrNot()
        statusImageView = dynamicStatusBarImage(imageURL: nil)
    }
    
    override func updateDataFromNet() {
        viewModel.updateDataSources(gymID)
    }
    

    override func setUpViews() {
        super.setUpViews()
        navigationItem.rightBarButtonItem = callItem
        bannerView.placeholderImage = UIImage.init(named: "gym_info")
        bannerView.bannerImageViewContentMode = .scaleAspectFill
    }
    
    override func setUpEvents() {
        
        footer.locationClick = { [unowned self] in
            self.toMapController()
        }
        
        viewModel.dataSource.asObservable().bind { [unowned self] (model) in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
        bannerView.itemDidScrollOperationBlock = { [unowned self] index in
            self.refreshStatusImage(index: index)
        }
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.tableHeaderView = bannerView
        tableView.tableFooterView = footer
        tableView.backgroundColor = UIColor.white
    }
    
    
    func handleData(model: GymInfoModel) {
        bannerView.imageURLStringsGroup = model.images
        footer.model = model
        if model.images.count == 1 {
            statusImageView?.customTopBarStyleImage(imageURL: model.images.first)
        }
    }
    
    func refreshStatusImage(index: Int) {
        let imageURLStr = viewModel.dataSource.value.images[safe: index]
        statusImageView?.customTopBarStyleImage(imageURL: imageURLStr)
    }
    
    
    func toMapController() {
        let vc = GymMapController.init(model: viewModel.dataSource.value)
        pushAnimated(vc)
    }
}


