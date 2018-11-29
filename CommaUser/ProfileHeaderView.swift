//
//  ProfileHeaderView.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/18.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class ProfileHeaderView: BaseView {
    
    var model: ProfileModel? {
        didSet {
            guard let model = self.model else { return }
            
            dataView.unLoginView.isHidden = GlobalAction.isLogin
            dataView.loginedView.isHidden = !GlobalAction.isLogin
            
            let loginedView = dataView.loginedView
            loginedView.genderImageView.image = AppUser.gender.userImage
            loginedView.gymLabel.text = "活跃于" + (model.gym_name ?? "某场馆")
            loginedView.gymLabel.isHidden = model.cardStatus != .member
            let function = model.cardStatus == .member ? loginedView.reLayoutForMember : loginedView.reLayoutForNoCardUser
            function()
            loginedView.nameLabel.text = AppUser.user_name
            loginedView.avatarButton.sd_setImage(with: URL.stringURL(AppUser.avatar), for: .normal, placeholderImage: AppUser.gender.userPlaceholderImage)
            loginedView.unloginButton.isHidden = model.cardStatus != .noCard
            
            cardView.progressView.progress = model.day.toCGFloat / 864 // 最多864天（499+365）
            cardView.progressView.dayLabel.text = "\(model.day)"
            cardView.progressView.isHidden = model.cardStatus != .member
            
            cardView.progressView.isShowRenewButton = model.showRenewButton
            cardView.isUserInteractionEnabled = model.showRenewButton
            cardView.type = model.memberType
            cardView.isHidden = model.cardStatus == .noCard
            stoneImageView.isHidden = !cardView.isHidden
            
            frame.size.height = model.cardStatus == .noCard ? 128 : 298
        }
    }
    
    let dataView = DataView()
    let cardView = CardView()
    let stoneImageView = UIImageView.init(image: UIImage.init(named: "profile_card_background"))
    
    override func customizeInterface() {
        clipsToBounds = false
        frame = CGRectMake(0, 0, Layout.ScreenWidth, 298)
        addSubview(dataView)
        let view = UIView()
        view.backgroundColor = UIColor.white
        addSubview(view)
        addSubview(cardView)
        dataView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(108)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(dataView.snp.bottom)
            make.bottom.equalTo(self).offset(-3)
        }
        
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(dataView.snp.bottom)
            make.height.equalTo(87)
        }
        view.addSubview(stoneImageView)
        stoneImageView.layer.masksToBounds = true
        stoneImageView.contentMode = .top
        stoneImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(-5)
            make.centerX.equalTo(view)
            make.height.equalTo(25)
        }
    }
    
}

extension ProfileHeaderView {
    
    
    class DataView: BaseView {
        
        let unLoginView = UnLoginView()
        let loginedView = LoginedView()
        
        override func customizeInterface() {
            addSubview(unLoginView)
            addSubview(loginedView)
            loginedView.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
            unLoginView.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
    }
    
    class LoginedView: BaseView {
        
        let avatarButton = BaseButton()
        let genderImageView = UIImageView()
        let nameLabel = BaseLabel()
        let gymLabel = BaseLabel()
        let unloginButton = BaseButton()
        
        override func customizeInterface() {
            backgroundColor = UIColor.white
            addSubview(avatarButton)
            addSubview(genderImageView)
            addSubview(nameLabel)
            addSubview(gymLabel)
            addSubview(unloginButton)
            avatarButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(self).offset(-20)
                make.left.equalTo(self).offset(20)
                make.size.equalTo(CGSizeMake(46))
            }
            avatarButton.layer.cornerRadius = 23
            avatarButton.clipsToBounds = true
            avatarButton.imageView?.contentMode = .scaleAspectFill
            nameLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold15)
            nameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self).offset(44)
                make.left.equalTo(avatarButton.snp.right).offset(20)
            }
            nameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 100), for: UILayoutConstraintAxis.horizontal)
            genderImageView.snp.makeConstraints { (make) in
                make.centerY.equalTo(nameLabel)
                make.left.equalTo(nameLabel.snp.right).offset(9)
                make.size.equalTo(CGSize.init(width: 17, height: 17))
                make.right.equalTo(unloginButton.snp.left).offset(-8).priority(200)
            }
            gymLabel.setUp(textColor: UIColor.hx9b9b9b, font: UIFont.boldAppFontOfSize(12))
            gymLabel.snp.makeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(6)
                make.left.equalTo(avatarButton.snp.right).offset(20)
            }
            
            unloginButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(avatarButton)
                make.right.equalTo(self).offset(-20)
            }
            unloginButton.setImage(UIImage.init(named: "profile_logout"), for: .normal)
        }
        
        func reLayoutForMember() {
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(self).offset(44)
                make.left.equalTo(avatarButton.snp.right).offset(20)
            }
        }
        
        func reLayoutForNoCardUser() {
            nameLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(avatarButton)
                make.left.equalTo(avatarButton.snp.right).offset(20)
            }
        }
    }
    
    class UnLoginView: BaseView {
        
        let avatarImageView = UIImageView(image: UIImage(named: "user_male_normal"))
        let arrowImageView = UIImageView(image: UIImage(named: "course_info_arrow"))
        let label = BaseLabel()
        let loginButton = BaseButton()
        
        override func customizeInterface() {
            backgroundColor = UIColor.white
            addSubview(avatarImageView)
            addSubview(arrowImageView)
            addSubview(label)
            addSubview(loginButton)
            avatarImageView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self).offset(-20)
                make.left.equalTo(self).offset(20)
            }
            label.text = "您还未登录"
            label.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold15)
            label.snp.makeConstraints { (make) in
                make.centerY.equalTo(avatarImageView)
                make.left.equalTo(avatarImageView.snp.right).offset(18)
            }
            arrowImageView.snp.makeConstraints { (make) in
                make.centerY.equalTo(label)
                make.left.equalTo(label.snp.right).offset(6)
            }
            loginButton.snp.makeConstraints { (make) in
                make.left.equalTo(avatarImageView)
                make.right.equalTo(arrowImageView)
                make.bottom.equalTo(avatarImageView).offset(10)
                make.top.equalTo(avatarImageView).offset(-10)
            }
            loginButton.rx.tap.bind {
                Jumper.jumpToLogin()
                }.disposed(by: disposeBag)
        }
    }
    
    
}


extension ProfileHeaderView {
    
    class CardView: BaseView {
        
        var click: EmptyClosure?
        
        var type: MemberVipType = .unknown {
            didSet {
                imageView.image = type.image
                progressView.type = type
            }
        }
        
        let imageView = UIImageView(image: MemberVipType.unlogin.image)
        let progressView = ProgressView()
        
        override func customizeInterface() {
            
            addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.bottom.centerX.equalTo(self)
                make.width.equalTo(Layout.ScreenWidth - 6)
            }
            
            addSubview(progressView)
            progressView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self)
                make.bottom.equalTo(self).offset(-41)
                make.height.equalTo(65)
            }
            
            let tap = UITapGestureRecognizer()
            addGestureRecognizer(tap)
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            tap.rx.event.bind { [unowned self] _ in
                self.click?()
                }.disposed(by: disposeBag)
            
        }
    }
    
    
    class ProgressView: BaseView {
        
        var type: MemberVipType = .unknown {
            didSet {
                
                let color = type == .black ? UIColor.hexColor(0xE5CBA4) : UIColor.white
                progressView.backgroundColor = color
                contentProgressView.backgroundColor = color.withAlphaComponent(0.2652)
                dayLabel.textColor = color
                unitLabel.textColor = color
                introLabel.textColor = color.withAlphaComponent(0.6)
                renewButton.setTitleColor(color, for: .normal)
                renewButton.layer.borderColor = color.cgColor
            }
        }
        
        var isShowRenewButton: Bool = false {
            didSet {
                renewButton.isHidden = !isShowRenewButton
                if isShowRenewButton {
                    contentProgressView.snp.remakeConstraints { (make) in
                        make.height.equalTo(6)
                        make.left.equalTo(self).offset(35.reW)
                        make.right.equalTo(renewButton.snp.left).offset(-35.reW)
                        make.bottom.equalTo(self)
                    }
                } else {
                    contentProgressView.snp.remakeConstraints { (make) in
                        make.left.equalTo(self).offset(35.reW)
                        make.right.equalTo(self).offset(-35.reW)
                        make.bottom.equalTo(self)
                        make.height.equalTo(6)
                    }
                    
                }
            }
        }
        
        var progress: CGFloat = 0 {
            didSet {
                let p = min(max(0, progress), 1)
                progressView.snp.remakeConstraints { make in
                    make.left.top.bottom.equalTo(contentProgressView)
                    make.width.equalTo(contentProgressView).multipliedBy(p)
                }
            }
        }
        
        
        let introLabel = BaseLabel()
        let dayLabel = BaseLabel()
        let unitLabel = BaseLabel()
        
        let contentProgressView = UIView()
        let progressView = UIView()
        
        let renewButton = BaseButton()
        
        override func customizeInterface() {
            addSubview(introLabel)
            addSubview(dayLabel)
            addSubview(unitLabel)
            addSubview(contentProgressView)
            addSubview(renewButton)
            
            renewButton.isUserInteractionEnabled = false
            renewButton.layer.cornerRadius = 4
            renewButton.layer.borderColor = UIColor.white.cgColor
            renewButton.layer.borderWidth = 1
            renewButton.titleLabel?.font = UIFont.bold15
            renewButton.setTitle("续 卡", for: .normal)
            renewButton.snp.makeConstraints { (make) in
                make.right.equalTo(self).offset(-35.reW)
                make.bottom.equalTo(self)
                make.size.equalTo(CGSizeMake(75, 30))
            }
            
            contentProgressView.layer.cornerRadius = 3
            progressView.layer.cornerRadius = 3
            contentProgressView.snp.makeConstraints { _ in }
            contentProgressView.addSubview(progressView)
            
            introLabel.font = UIFont.bold12
            dayLabel.font = UIFont.DINProBoldFontOf(size: 15)
            unitLabel.font = UIFont.bold12
            unitLabel.text = Text.Sky
            introLabel.text = "会员卡剩余时间："
            introLabel.snp.makeConstraints { (make) in
                make.left.equalTo(contentProgressView)
                make.bottom.equalTo(contentProgressView.snp.top).offset(-9)
            }
            
            dayLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(introLabel)
                make.left.equalTo(introLabel.snp.right).offset(3)
            }
            
            unitLabel.snp.makeConstraints { (make) in
                make.left.equalTo(dayLabel.snp.right).offset(3)
                make.centerY.equalTo(dayLabel)
            }
        }
    }
}


enum MemberVipType {
    
    init?(cardStatus: Int, color: Int) {
        if !GlobalAction.isLogin {
            self = .unlogin
            return
        }
        switch cardStatus {
        case 1:
            self = .notVip
        case 2:
            switch color {
            case 1:
                self = .black
            case 2:
                self = .blue
            case 3:
                self = .purple
            default:
                self = .purple
            }
        case 3:
            self = .expired
        default:
            return nil
        }
        
    }
    
    case black
    case blue
    case purple
    case notVip
    case expired
    case unlogin
    case unknown
    
    var image: UIImage? {
        let text: String
        switch self {
        case .black:
            text = "black_card"
        case .blue:
            text = "blue_card"
        case .purple:
            text = "purple_card"
        case .unlogin, .notVip:
            text = "user_card"
        case .expired:
            text = "renew_card"
        default:
            text = "card_placeholder"
        }
        return UIImage.init(named: text)
    }
}

