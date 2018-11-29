//
//  CourseListItemController.swift
//  CommaUser
//
//  Created by macbook on 2018/10/19.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CourseListItemController: BaseController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let reuseIdentifier = "UICollectionViewCell"
    let couseVC = CoursesListController.init(classType: ClassType.littleGroup)
    let groupVC = CoursesListController.init(classType: ClassType.group)
    let titleView = MyClassesTitleView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    var classType: ClassType!
    init(classType: ClassType = .group) {
        super.init(nibName: nil, bundle: nil)
        self.classType = classType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.couseVC.loadingView?.startLoading()
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        TingYunSDKManager.beginTracer("CourseListItemController")
        
        NBSAppAgent.leaveBreadcrumb("CourseListItemController")
        NBSAppAgent.trackEvent("CourseListItemController")
        NBSAppAgent.setCustomerData("CourseListItemController", forKey: "CourseListItemController")
        
        TingYunSDKManager.endTracer("CourseListItemController")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if classType! == .group {
//            self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition(), animated: true)
//            titleView.selectedItem = 1
//        }
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.visibleCells.forEach({ $0.frame.origin.y = 0 })
    }
    
    
    override func setUpViews() {
        super.setUpViews()
        navigationItem.titleView = titleView
        titleView.items[0].setTitle(Text.littleGroupClass, for: .normal)
        titleView.items[1].setTitle(Text.GroupFullClass, for: .normal)
        for item in titleView.items {
            item.snp.updateConstraints { (make) in
                make.width.equalTo(70)

            }
   
        }
        
        titleView.buttonClick = { [unowned self] index in
            self.collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition(), animated: true)
            self.classType = ClassType(rawValue: index + 1)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        collectionViewSetup()
        
        
        let frm = CGRect(x: 0, y: 0, width: Layout.ScreenWidth, height: Layout.ScreenHeight - Layout.TopBarHeight)
        couseVC.view.frame = frm
        groupVC.view.frame = frm


        self.addChildViewController(couseVC)
        self.addChildViewController(groupVC)
        
    }
    
    override func setUpEvents() {
//        couseVC.toOrderClass = { GlobalAction.popToRootAndSelectedTab(index: CoursesIndex) }
//        privateVC.toOrderClass = { GlobalAction.popToRootAndSelectedTab(index: CoursesIndex) }
    }
    
    func collectionViewSetup() -> Void {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: Layout.ScreenWidth, height: Layout.ScreenHeight - 64)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        if classType! == .group {
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition(), animated: false)
                self.titleView.selectedItem = 1
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.contentView.addSubview(couseVC.view)
        } else {
            cell.contentView.addSubview(groupVC.view)
        }
        cell.frame.origin.y = 0
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = Int(scrollView.contentOffset.x / Layout.ScreenWidth)
        titleView.selectedItem = x
        classType = ClassType(rawValue: x + 1)
        collectionView.visibleCells.forEach({ $0.frame.origin.y = 0 })
    }
}
