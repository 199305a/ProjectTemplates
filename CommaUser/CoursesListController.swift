//
//  CoursesListController.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/10.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 描述 团体课列表
class CoursesListController: PagingController, UITableViewDataSource {
    
    let reuseIdentifier = "CoursesListItemCell"
    let headerID = "Header"
    
    let header = CoursesListHeaderView()
    let viewModel = CoursesListViewModel()
    var data: [CoursesListDetailModel] { return viewModel.dataSource.value.list }
    
    var classType: ClassType!
    init(classType: ClassType = .group) {
        super.init(nibName: nil, bundle: nil)
        self.classType = classType
        viewModel.classType = classType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.tableView = BaseTableView(frame: .zero, style: .grouped)
        super.viewDidLoad()
        self.tableView.mj_footer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataFromNet()
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.GroupClass
        self.view.addSubview(header)
        header.dateClick = { [unowned self] date in
            if self.viewModel.dataSource.value.list.count > date {
                if self.viewModel.dataSource.value.list[date].contents.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: date), at: .none, animated: true)
                }
            }
        }
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(CoursesListItemCell.self)
        tableView.register(CoursesListItemSectionHeader.self, forHeaderFooterViewReuseIdentifier: headerID)

        tableView.rx.setDataSource(self).disposed(by: disposeBag)
//        tableView.rowHeight = UITableViewAutomaticDimension
        viewModel.dataSource.asObservable().bind { [unowned self] model in
            self.handleNetData(model: model)
            self.errorBackgroundView.removeFromSuperview()

        }.disposed(by: disposeBag)
//        if  self.classType == ClassType.littleGroup {
        header.frame = CGRectMake(0, 0, Layout.ScreenWidth,  100)
        header.bottomView.isHidden = true
//        }
        header.selectedItem = 0
        tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(header.height)
        }

        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    override func setUpEvents() {
        header.bottomView.click = { [unowned self] in
            let vc = SelfHelpCourseController()
            self.pushAnimated(vc)
        }
    }
    
    func handleNetData(model: CoursesIndexListModel) {
//        tableView.tableHeaderView = model.canSchedule ? header : nil
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
        return data[section].contents.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count

//        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CoursesListItemCell
//        cell.dataSource = data[safe: indexPath.row]
//        cell.tagView.createCloudTagsWithTitles(["腹肌撕裂","核心轰炸","核心轰炸核心轰炸"])
        cell.setUpModel(data[indexPath.section].contents[indexPath.row])
        cell.btnClick =  {
        
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section].contents[indexPath.row]

        if model.schedule_id == nil {
            showServerErrorMessage()
            return
        }
        let vc = CourseInfoController(classType: self.classType, scheduleID: model.schedule_id!)
        pushAnimated(vc)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CoursesListItemSectionHeader
        view.model = data[section]
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.dataSource.value.list[section].contents.count == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
