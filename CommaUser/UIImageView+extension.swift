//
//  UIImageView+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

extension UIImageView{
    func roundImage()
    {
        //height and width should be the same
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
}

class BaseImageView: UIImageView {
    
}

class FillImageView: BaseImageView {
    
    init() {
        super.init(frame: CGRect.zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CycleImageView: FillImageView {
    
    override init() {
        super.init()
        layer.borderWidth = 1
        layer.borderColor = UIColor.hexColor(0xd8dade).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TypeImageView: BaseImageView {
    var type: ClassType! {
        didSet {
            guard let _ = type else { return }
            self.image = type == .group ? UIImage.init(named: "type_group") : UIImage.init(named: "type_private")
            typeLabel.text = type == .group ?  Text.GroupClass : Text.PrivateClass
            typeLabel.textColor = type == .group ? UIColor.black : UIColor.white
        }
    }
    
    var isFee: Bool! {
        didSet {
            self.image = UIImage.init(named: "type_fee_group")
            typeLabel.text = isFee == true ? "付费团体课" : "免费团体课"
        }
    }
    
    
    let typeLabel = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(typeLabel)
        typeLabel.font = UIFont.appFontOfSize(12)
        typeLabel.textAlignment = .center
        typeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ImageLoadingView: UIView {
    
    let imageView = UIImageView()
    let animationKey = "animationKey"
    
    // default is YES. calls -setHidden when animating gets set to NO
    var hidesWhenStopped: Bool = true {
        didSet {
            if !hidesWhenStopped {
                isHidden = false
            }
        }
    }
    
    var color: UIColor? {
        didSet {
            if let color = color, var image = imageView.image {
                image = image.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = color
                imageView.image = image
                return
            }
            imageView.tintColor = nil
            let image = imageView.image?.withRenderingMode(.alwaysOriginal)
            imageView.image = image
        }
    }
    
    var isAnimating: Bool { return layer.animationKeys()?.contains(animationKey) != nil }
    
    init(image: UIImage?) {
        let size = image?.size ?? CGSize.zero
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = image
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.size.equalTo(size)
        }
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func startAnimating() {
        if isAnimating {
            return
        }
        if isHidden {
            isHidden = false
        }
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 2
        anim.fromValue = 0
        anim.toValue = Double.pi * 2
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        layer.add(anim, forKey: animationKey)
        
        
    }
    func stopAnimating() {
        
        layer.removeAnimation(forKey: animationKey)
        if hidesWhenStopped {
            isHidden = true
        }
    }
    
}

extension UIImageView {
    func customTopBarStyleImage(imageURL: String?) {
        guard let str = imageURL, let url = URL.init(string: str) else {
            return
        }
        contentMode = .top
        clipsToBounds = true
        sd_setImage(with: url) { [weak self] (image, _, _, _) in
            var img = image
            if let size = image?.size, size.width < Layout.ScreenWidth {
                img = image?.resizeImage(targetSize: CGSizeMake(Layout.ScreenWidth, Layout.ScreenWidth * size.height / size.width))
            }
            self?.image = img
        }
    }
}
