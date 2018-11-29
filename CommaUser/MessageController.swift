//
//  MessageController.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/25.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

enum AnnounceType {
    case announce
    case message
}
//MARK: - 描述 消息列表
class MessageController: BaseController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let reuseIdentifier = "UICollectionViewCell"
    
    let annonceVC = MessageListController(type: .announce)
    let messageListVC = MessageListController(type: .message)
    let titleView = ToggleTitleView.init(itemTitles: [Text.Announcement, Text.Message])
    
    var type = AnnounceType.announce
    
    init(type: AnnounceType = .announce) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        annonceVC.titleView = titleView
        messageListVC.titleView = titleView
        addChildViewController(annonceVC)
        addChildViewController(messageListVC)
        DispatchQueue.main.async {
            self.loadingView?.startLoading()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.visibleCells.forEach({ $0.frame.origin.y = 0 })
    }
    
    override func setUpViews() {
        super.setUpViews()
        titleView.frame.size = CGSizeMake(2*titleView.btnW+titleView.btnSpace, 44)
        navigationItem.titleView = titleView
        titleView.buttonClick = { [unowned self] index in
            self.collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition(), animated: true)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        collectionViewSetup()
        
        let frm = CGRect(x: 0, y: 0, width: Layout.ScreenWidth, height: Layout.ScreenHeight - Layout.TopBarHeight)
        annonceVC.view.frame = frm
        messageListVC.view.frame = frm
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
        if type == .message {
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
            cell.addSubview(annonceVC.view)
        } else {
            cell.addSubview(messageListVC.view)
        }
        cell.frame.origin.y = 0
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = Int(scrollView.contentOffset.x / Layout.ScreenWidth)
        titleView.selectedItem = x
        collectionView.visibleCells.forEach({ $0.frame.origin.y })
    }
    
}
