//
//  CoursesController.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/8.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - 约课控制器
class CoursesController: CollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    let reuseIdentifier0 = "CoursesContentCVCell"
    let reuseIdentifier1 = "CourseTrainerCVCell"
    let headerReuseIdentifier = "CoursesHeaderCVCell"
    let bannerReuseIdentifier = "CourseBannerView"
//    let NoGroupCourseCVCellID = "NoGroupCourseCVCell"
    let CoursesNoGymCVCellID = "CoursesNoGymCVCell"
    let CourseItemsCVCellID = "CourseItemsCVCell"

    
    let viewModel = CoursesViewModel()
    let titleView = CoursesTitleView()
    let shadowImage = UIImage.imageWithColor(UIColor.white, width: Layout.ScreenWidth, height: 20)
    
    var coursesData: [CoursesGroupModel] { return viewModel.dataSource.value.courses }
    var trainersData: [CoursesTrainerModel] { return viewModel.dataSource.value.trainers }
    var bannerData: [CoursesBannerModel] { return viewModel.dataSource.value.banners }
    
    var hasGym: Bool { return viewModel.dataSource.value.gym?.isEmpty == false }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        abserverLocating()
        viewModel.loading?.asObservable().share().bind { [unowned self] status in
            self.titleView.locationButton.isHidden = status == .loading
            }.disposed(by: disposeBag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 如果进入首页没有定位，就去定位
        if !LocationManager.didChangedAuthStatus {
            _ = LocationManager.startLocating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = shadowImage
    }
    
    override func updateDataFromNet() {
        viewModel.updateDataSources()
        checkVisitorOpenDoor()
    }
    
    override func setUpViews() {
        super.setUpViews()
        navigationItem.titleView = titleView
        titleView.rightButton.isHidden = false
        errorBackgroundView.title = Text.HasNoCourseNow
        errorBackgroundView.image = UIImage.init(named: "error-no-course")
    }
    
    override func setUpCollectionView() {
        super.setUpCollectionView()
        collectionView.snp.remakeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        collectionView.registerClass(CourseItemsCVCell.self)
        
        collectionView.registerClass(CourseTrainerCVCell.self)
//        collectionView.registerClass(NoGroupCourseCVCell.self)
        collectionView.registerClass(CoursesNoGymCVCell.self)
        collectionView.register(CoursesHeaderCVCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.register(CourseBannerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: bannerReuseIdentifier)
    }
    
    override func setUpEvents() {
        registNotifications()
        
        titleView.rightButtonClick = { [unowned self] in
            self.toOpenDoor()
        }
        
        titleView.gymButtonClick = { [unowned self] in
            self.toGymList()
        }
        
        titleView.locationButtonClick = { [unowned self] in
            self.toGymList()
        }
        
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleData(model: model)
            }.disposed(by: disposeBag)
        
        
        viewModel.errorViewStyle.asObservable().share(replay: 1).bind { [unowned self] (style) in
            self.handleGymWhenNoWifi(style: style)
            }.disposed(by: disposeBag)
        
    }
    
    
    func registNotifications() {
        NotificationCenter.default.rx.notification(NotiKey.ChangedStore).bind { [unowned self] _ in
            self.updateDataFromNet()
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotiKey.LoginSuccess).bind { [unowned self] (_) in
            self.titleView.rightButton.isHidden = true // 重新登录后暂时隐藏蓝牙开门按钮
            self.updateDataFromNet()
            }.disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx.notification(NotiKey.ManualUnlogin).bind { [unowned self] (_) in
            self.updateDataFromNet()
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotiKey.PayDone).bind { [unowned self] noti in
            self.updateDataFromNet()
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotiKey.UserInfosCompleted).bind { [unowned self] noti in
            self.viewModel.dataSource.value.is_new = 0
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.reachabilityChanged).bind { (_) in
            if APPConfigManager.reachability?.connection == .none {
                return
            }
            if !LocationManager.CurrentLocationIsKnown && LocationManager.shared.locationEnable {
                LocationManager.startLocating()
            }
            }.disposed(by: disposeBag)
        
    }
    
    func handleData(model: CoursesIndexModel) {
        titleView.model = model.gym
        self.collectionView.reloadData()
        if model.isNewUser {
            toCompletionUserInfo()
        }
    }
    
    
    func handleGymWhenNoWifi(style: ErrorBackgroundViewStyle) {
        if style == .noWifi, let title = self.titleView.model?.gym_name, title == Text.Locating {
            let model = self.titleView.model
            model?.gym_name = Text.NoNetwork
            self.titleView.model = model
            self.view.bringSubview(toFront: self.errorBackgroundView)
        }
    }
    
    func toOpenDoor() {
        guard GlobalAction.isLogin else {
            Jumper.jumpToLogin()
            return
        }
        let vc = OpenDoorController()
        vc.refreshVisitEnableState = {
            self.checkVisitorOpenDoor()
        }
        vc.hidesBottomBarWhenPushed = true
        self.pushAnimated(vc)
    }
    
    
    func abserverLocating() {
        NotificationCenter.default.rx.notification(NotiKey.LocationUpdated).bind { [unowned self] noti in
            self.updateDataFromNet()
            }.disposed(by: disposeBag)
    }
    
    
    func toCompletionUserInfo() {
        let nav = CompleteNavController.init(rootViewController: CompletionFirstController())
        if  let navi = APP.tabBarController.presentedViewController as? UINavigationController, let _ = navi.viewControllers.first as? LoginController {
            GlobalAction.delayPerformOnMainQueue(1.5, task: {
                DispatchQueue.main.async {
                    APP.tabBarController.present(nav, animated: true, completion: nil)
                }
            })
        } else {
            DispatchQueue.main.async {
                APP.tabBarController.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func toGymList() {
        let vc = SwitchStoreController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击banner
    func bannerClick(index: Int) {
        guard let model = bannerData[safe: index] else { return }
        switch model.bannerType {
        case .HTML5:
            let vc = WebShareController.init(bannerModel: model)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .native:
            switch model.bannerNativeType {
            case .unknown:
                break
            case .card:
                let vc = CardsListController()
                vc.hidesBottomBarWhenPushed = true
                pushAnimated(vc)
            }
        default:
            break
        }
    }
    
    //  是否显示蓝牙开门页面
    func checkVisitorOpenDoor() {
        
        if !GlobalAction.isLogin {
            self.titleView.rightButton.isHidden = true
            return
        }
        
        NetWorker.get(ServerURL.CheckUserVisit, success: { (dataObj) in
            guard let canOpenDoor = dataObj["check_visit"] as? Int else { return }
            self.titleView.rightButton.isHidden = canOpenDoor != 1
        }, error: { (statusCode, message) in
        }) { (error) in
        }
    }
    
    // MARK: - collection view delegate & data source methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case _banner:
            count = 0
        case _groupCourse:
            count = hasGym ? 1 : 0
        case _trainer:
            count = trainersData.count
        case _noGym:
            count = hasGym ? 0 : 1
        default:
            break
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case _groupCourse:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseItemsCVCellID, for: indexPath) as! CourseItemsCVCell
            cell.detailLabel.text = viewModel.dataSource.value.little_team_courseMSG.nonOptional
            cell.groupFulldetailLabel.text = viewModel.dataSource.value.team_courseMSG.nonOptional
//            cell.coursesData = coursesData
            cell.groupFullClick = { [unowned self] in
                let vc = CourseListItemController()
                vc.classType = ClassType.group
                vc.hidesBottomBarWhenPushed = true
                self.pushAnimated(vc)
            }
            
            cell.littleGroupClick = { [unowned self]  in
                let vc = CourseListItemController()
                vc.classType = ClassType.littleGroup
                vc.hidesBottomBarWhenPushed = true
                self.pushAnimated(vc)
            }
            
            return cell
        case _trainer:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! CourseTrainerCVCell
            cell.dataSource = trainersData[indexPath.item]
            return cell
        case _noGym:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoursesNoGymCVCellID, for: indexPath) as! CoursesNoGymCVCell
            cell.isLocationSuccessful = LocationManager.CurrentLocationIsKnown
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        switch indexPath.section {
        case _groupCourse:
            size = CGSizeMake(Layout.ScreenWidth, 145)
//            size = coursesData.isEmpty ? CGSizeMake(Layout.ScreenWidth, 360.reH_less_4_7) : CGSizeMake(Layout.ScreenWidth, 237)
        case _trainer:
            size = trainersData.isEmpty ? .zero : CGSizeMake(Layout.ScreenWidth, 158)
        case _noGym:
            size = hasGym ? .zero : CGSizeMake(Layout.ScreenWidth, 348)
        default:
            break
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case _banner:
//            50
            return bannerData.isEmpty ? .zero : CGSizeMake(Layout.ScreenWidth, 180  )
        case _groupCourse:
            return CGSizeMake(Layout.ScreenWidth, 78)
//            return coursesData.isEmpty ? .zero : CGSizeMake(Layout.ScreenWidth, 78)
        case _trainer:
            return trainersData.isEmpty ? .zero :  CGSizeMake(Layout.ScreenWidth, 78)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
        case _banner:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: bannerReuseIdentifier, for: indexPath) as! CourseBannerView
            view.bannerView.clickItemOperationBlock = { [unowned self] index in
                self.bannerClick(index: index)
            }
            view.handleData(data: bannerData)
            return view
        case _groupCourse:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CoursesHeaderCVCell
            
            view.titleLabel.text = Text.Course
            view.detailLabel.text = "（部分团体课收费）"
            view.detailLabel.isHidden = true
            view.button.isHidden = true
            view.buttonClick = { [unowned self] in
                let vc = CoursesListController()
                vc.hidesBottomBarWhenPushed = true
                self.pushAnimated(vc)
            }
            return view
        case _trainer:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CoursesHeaderCVCell
            view.titleLabel.text = Text.Trainer
            view.detailLabel.text = nil
            view.button.isHidden = true
            return view
        default:
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == _groupCourse ? UIEdgeInsetsMake(0, 15, 0, 15) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == _groupCourse ? 15 : 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case _trainer:
            guard let id = trainersData[indexPath.row].trainer_id else {
                showServerErrorMessage()
                return
            }
            let vc = TrainerInfoController(trainerID: id)
            vc.hidesBottomBarWhenPushed = true
            pushAnimated(vc)
        case _groupCourse:
            guard viewModel.dataSource.value.canUseSelfHelpCourse && coursesData.isEmpty else {
                return
            }
            let vc = SelfHelpCourseController()
            vc.hidesBottomBarWhenPushed = true
            pushAnimated(vc)
        default:
            break
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private let _banner = 0
private let _groupCourse = 1
private let _trainer = 2
private let _noGym = 3



