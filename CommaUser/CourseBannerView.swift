//
//  CourseBannerView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/9.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
import SDCycleScrollView
import RxSwift

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class CourseBannerView: UICollectionReusableView {
    
    lazy var disposeBag = DisposeBag()
    var topNotiView:BaseView!
    var bannerView: BannerView!
    var notiClick:EmptyClosure?
    override init(frame: CGRect) {
        super.init(frame: frame)
        bannerView = BannerView.init(frame: .zero, delegate: nil, placeholderImage: UIImage.init(named: "index_banner"))
        addSubview(bannerView)
        
        topNotiView = BaseView()
        topNotiView.backgroundColor = UIColor.hx129faa
        addSubview(topNotiView)
        
        topNotiView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(50)
        }
        
        topNotiView.isHidden = true
        
        let tap1 = UITapGestureRecognizer()
        tap1.rx.event.bind { [unowned self] _ in
            if self.notiClick != nil {
                self.notiClick!()
            }
        }.disposed(by: disposeBag)
        
        topNotiView.addGestureRecognizer(tap1)
        
        let notiLab = BaseLabel()
        notiLab.setUp(textColor: UIColor.white, font: UIFont.font15)
        notiLab.text = Text.CourseNotiStr
        
        let arrrowimage = BaseImageView.init(image: UIImage.init(named: "arrow-right-white"))
        notiLab.isUserInteractionEnabled = true
        arrrowimage.isUserInteractionEnabled = true
        topNotiView.addSubview(notiLab)
        topNotiView.addSubview(arrrowimage)
        
        notiLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        arrrowimage.snp.makeConstraints { (make) in
            make.left.equalTo(notiLab.snp.right).offset(0)
            make.centerY.equalToSuperview()
        }
        
        bannerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self).offset(0)
        }
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleData(data: [CoursesBannerModel]) {
        let images = data.map{$0.img_url ?? ""}
        bannerView.imageURLStringsGroup = images
    }
    
}

extension CourseBannerView:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! CustomViewCell
        return cell
    }
}
