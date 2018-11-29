//
//  AnnounceController.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/25.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
//MARK: - 描述 ？？
class AnnounceController: BaseController {
    
    let scrollV = UIScrollView()
    let titleLabel = BaseLabel()
    let announceLabel = BaseLabel()
    var instructionsImgV: BaseImageView!
    var rectImgV: BaseImageView!
    var triImgV: BaseImageView!
    lazy var announceAttr: [NSAttributedStringKey: AnyObject] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attr = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.paragraphStyle:style]
        return attr
    }()
    var announce: AnnounceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        guard let announce = announce else {
            customizeBackgroundView()
            return
        }
        setUpContentUI()
        
        setContent(announce: announce)
    }
    
    func setUpContentUI() {
        view.addSubview(scrollV)
        scrollV.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.showsVerticalScrollIndicator = false
        instructionsImgV = BaseImageView(image: UIImage(named: "user-instructions"))
        scrollV.addSubview(instructionsImgV)
        instructionsImgV.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(scrollV)
        }
        let tri_img = UIImage(named: "announce-bg-tri")
        let rect_img = UIImage(named: "announce-bg-rect")
        triImgV = BaseImageView(image: tri_img)
        triImgV.contentMode = .center
        rectImgV = BaseImageView(image: rect_img)
        scrollV.addSubview(triImgV)
        scrollV.addSubview(rectImgV)
        triImgV.snp.makeConstraints { (make) in
            make.top.equalTo(instructionsImgV.snp.bottom).offset(35)
            make.centerX.equalTo(scrollV)
        }
        titleLabel.textColor = UIColor.hx34c86c
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        announceLabel.textColor = UIColor.hx888b9a
        announceLabel.font = UIFont.systemFont(ofSize: 13)
        announceLabel.numberOfLines = 0
        scrollV.addSubview(titleLabel)
        scrollV.addSubview(announceLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rectImgV.snp.top).offset(50)
            make.centerX.equalTo(scrollV)
        }
        let dot1 = BaseView()
        let dot2 = BaseView()
        dot1.backgroundColor = UIColor.hx34c86c
        dot2.backgroundColor = UIColor.hx34c86c
        dot1.layer.cornerRadius = 2
        dot2.layer.cornerRadius = 2
        scrollV.addSubview(dot1)
        scrollV.addSubview(dot2)
        dot1.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-15)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSizeMake(4))
        }
        dot2.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(dot1)
            make.left.equalTo(titleLabel.snp.right).offset(15)
        }
        
        announceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalTo(view).offset(55)
            make.right.equalTo(view).offset(-55)
        }

    }
    
    func setContent(announce: AnnounceModel) {
        titleLabel.text = announce.gym_name
        let announceInfo = announce.announcement_info ?? ""
        let attrTxt = NSAttributedString(string: announceInfo, attributes: announceAttr)
        announceLabel.attributedText = attrTxt
        let announceSize = (announceInfo as NSString).boundingRect(with: CGSizeMake(Layout.ScreenWidth-110, CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: announceAttr, context: nil).size
        //只有一行 与 \n的情况
        if announceSize.height <= ceil(announceLabel.font.lineHeight) {
            announceLabel.textAlignment = .center
        } else if announceSize.width < Layout.ScreenWidth-110 {
            announceLabel.textAlignment = .center
        }
        let rectImgVH = 50+25+titleLabel.font.lineHeight+announceSize.height+67
        rectImgV.snp.makeConstraints { (make) in
            make.top.equalTo(triImgV.snp.bottom).offset(-12)
            make.centerX.equalTo(view)
            make.width.equalTo(Layout.ScreenWidth-20)
            make.height.equalTo(rectImgVH)
        }
        contentSizeH = rectImgVH + 40 + instructionsImgV.image!.size.height + 40
    }
    var contentSizeH: CGFloat = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollV.contentSize = CGSizeMake(Layout.ScreenWidth, contentSizeH)
       
    }
    
    
    override func customizeBackgroundView() {
        errorBackgroundView.title = Text.NoAnnounceNow
        errorBackgroundView.image = UIImage.init(named: "error-no-announce")
        errorBackgroundView.style = .noData
        errorBackgroundView.frame.origin.y = 20
        view.addSubview(errorBackgroundView)
    }
    
    
}

class AnnounceModel: BaseModel {
    
    var gym_id: String?
    var gym_name: String?
    var announcement_id: String?
    var announcement_info: String?
    
}
