//
//  ChooseSubscribeTimeController.swift
//  CommaUser
//
//  Created by macbook on 2018/11/6.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 选择预约时间
class ChooseSubscribeTimeController: ListController,UITableViewDataSource {

    let reuseIdentifier = "CourresSubscribeTimeCell"
    let headerID = "Header"
    
    let header = CoursesListHeaderView()
    
    let viewModel = TrainerTimeViewModel()

    var modelBack:((TrainerTimeSateModel) -> Void)?

    override func viewDidLoad() {
        self.tableView = BaseTableView(frame: .zero, style: .grouped)
        super.viewDidLoad()
        updateDataFromNet()
        removeLoadingObserver()
    }
    
    init(trainerID: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.trainerID = trainerID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpViews() {
        super.setUpViews()
        title = Text.ChooseSubscribeTime
        self.view.addSubview(header)
        header.dateClick = { [unowned self] date in
            if self.viewModel.dataSource.value.count > date {
                if self.viewModel.dataSource.value[date].contents!.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: date), at: .none, animated: true)
                }
            }
        }
    }
    
    override func setUpEvents() {
        super.setUpEvents()
        viewModel.dataSource.asObservable().bind { [unowned self] model in
                        self.handleNetData(model: model)
//            self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.registerClass(CourresSubscribeTimeCell.self)
        tableView.register(CoursesListItemSectionHeader.self, forHeaderFooterViewReuseIdentifier: headerID)
        
        tableView.rx.setDataSource(self).disposed(by: disposeBag)
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        viewModel.dataSource.asObservable().bind { [unowned self] model in
//            self.handleNetData(model: model)
            self.errorBackgroundView.removeFromSuperview()
            
            }.disposed(by: disposeBag)
        header.frame = CGRectMake(0, 0, Layout.ScreenWidth,  100)
        header.bottomView.isHidden = true
        header.selectedItem = 0
        tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(header.height)
        }
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    

    
    func handleNetData(model: [TrainerTimeModel]) {
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value[section].contents?.count ?? 0
//        return data[section].contents.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
        
    return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.dequeueReusableCell(withIdentifier: <#T##String#>)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! CourresSubscribeTimeCell
        cell.setUpModel(viewModel.dataSource.value[indexPath.section].contents![indexPath.row])
        cell.isFirstCell = indexPath.row == 0
        cell.isLastCell =  indexPath.row == ((viewModel.dataSource.value[indexPath.section].contents?.count  ?? 1)  - 1)
        cell.updateConstraints()
        cell.btnClick = { [weak self] model in
            if model != nil,let parentModel = self?.viewModel.dataSource.value[indexPath.section] {
                model?.date = "\(parentModel.year.nonOptional).\(parentModel.month.nonOptional).\(parentModel.day.nonOptional)"
                self?.modelBack?(model!)
            }
            self?.popAnimated()
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CoursesListItemSectionHeader
        view.TrainerModel = viewModel.dataSource.value[section]
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if viewModel.dataSource.value.list[section].contents.count == 0 {
//            return CGFloat.leastNormalMagnitude
//        }
        return 52
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class CourresSubscribeTimeCell: BaseTableViewCell,BindCell {
        
        let maskLayer = CAShapeLayer()
        var isFirstCell: Bool = false
        let subscribBtn = BaseButton()
        var btnClick:((TrainerTimeSateModel?) -> Void)?
        
        override func customizeInterface() {
            
            containerView.backgroundColor = UIColor.white
            contentView.addSubview(containerView)
            titleLabel = BaseLabel()
            
            titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.font15)
            titleLabel.numberOfLines = 0
            containerView.addSubview(titleLabel)
            containerView.addSubview(subscribBtn)
            
            subscribBtn.setTitle(Text.Appoint, for: .normal)
            subscribBtn.setTitleColor(UIColor.hx129faa, for: .normal)
            subscribBtn.setTitleColor(UIColor.hx9b9b9b, for: .disabled)
            subscribBtn.layer.cornerRadius = 5
            subscribBtn.layer.borderWidth = 1
            subscribBtn.layer.borderColor = UIColor.hx129faa.cgColor
            subscribBtn.titleLabel?.font = UIFont.PingFangSCMediumFontOf(size: 15)

            containerView.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }
            
            
            subscribBtn.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.top.equalTo(25)

                make.size.equalTo(CGSize.init(width: 70, height: 30))
                make.right.equalToSuperview().offset(-15)
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.centerY.equalTo(subscribBtn)
            }
            subscribBtn.rx.tap.bind { [weak self] in
                if self?.btnClick != nil {
                    self?.btnClick?(self?.model)
                }
            }.disposed(by: disposeBag)
        }
        var model:TrainerTimeSateModel?
        
        override func setUpModel(_ aModel: AnyObject) {
            if let model = aModel as? TrainerTimeSateModel {
                self.model = model
                titleLabel.text = model.duration.nonOptional
                subscribBtn.isEnabled = model.state == 0
                subscribBtn.setTitle(model.stateStr, for: .normal)
                if model.state == 0 {
                subscribBtn.layer.borderColor = UIColor.hx129faa.cgColor
                }else if model.state == 1 {
                    subscribBtn.layer.borderColor = UIColor.hx9b9b9b.cgColor
                }
            }
        }
        override func updateConstraints() {
            subscribBtn.snp.updateConstraints { make in
                make.bottom.equalTo(containerView).offset(isLastCell ? -20 : 0)
            }
            
            super.updateConstraints()
//            guard indexPath.section == 0, let cell = cell as? BindCell else { return }
            let path: UIBezierPath!
            var frame = self.bounds
            frame.size.width = Layout.ScreenWidth - 30
            if self.isFirstCell {
                frame.size.height = 75
                
                path = UIBezierPath.init(roundedRect: frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSizeMake(5))
            } else if self.isLastCell {
                frame.size.height = 75
                
                path = UIBezierPath.init(roundedRect: frame, byRoundingCorners: [.bottomLeft, . bottomRight], cornerRadii: CGSizeMake(5))
            } else {
                frame.size.height = 75

                path = UIBezierPath.init(roundedRect: frame, byRoundingCorners: [], cornerRadii: CGSizeMake(5))
            }
            self.maskLayer.frame = frame
            self.maskLayer.path = path.cgPath
            self.containerView.layer.mask = self.maskLayer
            
        }
        
    
    }

}


protocol BindCell {
    var maskLayer: CAShapeLayer { get }
    var isFirstCell: Bool { get }
    var isLastCell: Bool { get }
    var containerView: ContainerView { get }
    var bounds: CGRect { get }
}
