//
//  BluetoothStatusView.swift
//  
//
//  Created by yuanchao on 2018/4/19.
//

import UIKit
import RxSwift

class BluetoothStatusView: BaseView {
    
    let titleLabel = BaseLabel()
    let detaillabel = BaseLabel()
    let searchBtn = BaseButton()
    
    let searchLabel = BaseLabel()
    
    var status = Variable(SearchStatus.ongoing)
    var researchClosure: EmptyClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldAppFontOfSize(20)
        titleLabel.text = "OOPS!"
        detaillabel.textColor = UIColor.white
        detaillabel.font = UIFont.boldAppFontOfSize(15)
        detaillabel.textAlignment = .center
        detaillabel.text = Text.BraceletSearceFailNotice
        searchBtn.setTitle(Text.ReSearch, for: .normal)
        searchBtn.layer.cornerRadius = 5
        searchBtn.layer.borderWidth = 1
        searchBtn.layer.borderColor = UIColor.white.cgColor
        searchBtn.titleLabel?.font = UIFont.appFontOfSize(15)
        searchLabel.textColor = UIColor.white
        searchLabel.font = UIFont.boldAppFontOfSize(20)
        searchLabel.text = Text.BraceletSearchOnging
        
        addSubview(titleLabel)
        addSubview(detaillabel)
        addSubview(searchBtn)
        addSubview(searchLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self)
        }
        detaillabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalTo(titleLabel)
        }
        searchBtn.snp.makeConstraints { (make) in
            make.top.equalTo(detaillabel.snp.bottom).offset(40)
            make.centerX.equalTo(detaillabel)
            make.size.equalTo(CGSize.init(width: 130, height: 40))
            make.bottom.equalTo(-40.addSafeAreaBottom)
        }
        searchLabel.snp.makeConstraints { (make) in
            make.center.equalTo(titleLabel)
        }

        status.asObservable().bind {[weak self] (status) in
            switch status {
            case .success:
                self?.searchLabel.isHidden = true
                self?.titleLabel.isHidden = true
                self?.detaillabel.isHidden = true
                self?.searchBtn.isHidden = true
            case .fail:
                self?.searchLabel.isHidden = true
                self?.titleLabel.isHidden = false
                self?.detaillabel.isHidden = false
                self?.searchBtn.isHidden = false
            case .ongoing:
                self?.searchLabel.isHidden = false
                self?.titleLabel.isHidden = true
                self?.detaillabel.isHidden = true
                self?.searchBtn.isHidden = true
            }
            }.disposed(by: disposeBag)
        
        searchBtn.rx.tap.bind { [unowned self] in
            self.researchClosure?()
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum SearchStatus {
    case ongoing
    case success
    case fail
}




