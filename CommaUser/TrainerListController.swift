//
//  TrainerListController.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/12.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 描述 私教列表
class TrainerListController: PagingController, UITableViewDataSource {

    let reuseIdentifier = "TrainerListCell"
    let viewModel = TrainerListViewModel()
    var data: [CoursesTrainerModel] { return viewModel.dataSource.value }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromNet()
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.Trainer
    }
    
    override func setUpTableView() { 
        super.setUpTableView()
        tableView.registerClass(TrainerListCell.self)
        tableView.rx.setDataSource(self).disposed(by: disposeBag)
        tableView.rowHeight = 158
        tableView.tableHeaderView = UIView.init(frame: CGRectMake(0, 0, Layout.ScreenWidth, 15))
        viewModel.dataSource.asObservable().bind { [unowned self] _ in
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func setUpEvents() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TrainerListCell
        cell.dataSource = data[safe: indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = data[indexPath.row].gym_id else {
            showServerErrorMessage()
            return
        }
        let vc = TrainerInfoController(trainerID: id)
        pushAnimated(vc)
    }

}
