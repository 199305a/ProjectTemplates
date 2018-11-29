//
//  MessageListController.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/25.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//MARK: - 描述 消息列表  公告、消息
class MessageListController: PagingController {
    
    let reuseIdentifier = "MessageCell"
    let kreuseIdentifier = "MessageListCell"
    let viewModel = MessageListViewModel()
    var prepareReadMsgId: String?
    var type = AnnounceType.announce
    var titleView: ToggleTitleView!
    
    init(type: AnnounceType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackgroundView()
        viewModel.type = type
        loadingView?.startLoading()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalAction.isLogin {
            updateDataFromNet()
        } else {
            showNoMessageUI()
        }
        
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(MessageCell.self)
        tableView.register(UINib(nibName: kreuseIdentifier, bundle: nil), forCellReuseIdentifier: kreuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 138
        tableView.dataSource = self
    }
    
    override func customizeBackgroundView() {
        errorBackgroundView.title = Text.NoMessageNow
        errorBackgroundView.image = UIImage.init(named: "error-no-message")
        errorBackgroundView.frame = ScreenBounds
    }
    
    func checkLogin() {
        if !GlobalAction.isLogin {
            Jumper.jumpToLogin()
        }
    }
    
    override func setUpEvents() {
        if type == .announce {
            viewModel.dataSource.asObservable().bind { [unowned self] (models) in
                if models.count == 0 {
                    self.showNoMessageUI()
                } else {
                    self.errorBackgroundView.removeFromSuperview()
                    self.tableView.reloadData()
                    
                    if self.titleView != nil && self.viewModel.haveNotices.count > 0 {
                        self.titleView.counts = self.viewModel.haveNotices
                    }
                }
            }.disposed(by: disposeBag)
        } else {
            viewModel.mDataSource.asObservable().bind { [unowned self] (models) in
                if models.count == 0 {
                    self.showNoMessageUI()
                } else {
                    self.errorBackgroundView.removeFromSuperview()
                    self.tableView.reloadData()
                    
                    if self.titleView != nil && self.viewModel.haveNotices.count > 0 {
                        self.titleView.counts = self.viewModel.haveNotices
                    }
                }
            }.disposed(by: disposeBag)
        }
    }
    
    func showNoMessageUI() {
        removeLoadingObserver()
        errorBackgroundView.style = .noData
        errorBackgroundView.frame.origin.y = 20
        view.addSubview(errorBackgroundView)
    }
    
    deinit {
    }
   
}

//MARK: - 代理
extension MessageListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .announce {
            return viewModel.dataSource.value.count
        } else {
            return viewModel.mDataSource.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .announce {
            let model = viewModel.dataSource.value[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MessageCell
            cell.message = model
            return cell
        } else {
            let model = viewModel.mDataSource.value[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: kreuseIdentifier) as! MessageListCell
            cell.model = model
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .message {
            let model = viewModel.mDataSource.value[indexPath.row]
            let message_id = model.msg_url.components(separatedBy: "message_id=").last ?? ""
            
            if model.msg_type == "3" {
                let vc = MyTeamCourseDetailVC()
                vc.message_ID = message_id
                vc.schedule_ID = model.schedule_id
                pushAnimated(vc)
            } else if model.msg_type == "2" {
                
            }
            
        } else {
            let announcementInfoVC = AnnouncementInfoController()
            let ann = self.viewModel.dataSource.value[indexPath.row]
            announcementInfoVC.annId = ann.ann_id.nonOptional
            announcementInfoVC.readSuccess = { annId in
                ann.is_read = "1"
                self.tableView.reloadData()
            }
            self.pushAnimated(announcementInfoVC)
        }
    }
    
}
