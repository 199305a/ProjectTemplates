//
//  UINavigationBar+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/4/14.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit


protocol LikingCompatible: BaseProtocol {
    
    associatedtype Base
    
    var lk: CommaUser<Base> { get set }
    
}

extension LikingCompatible {
    
    var lk: CommaUser<Self> {
        get {
            return CommaUser(base: self)
        }
        set {
            
        }
    }
}


struct CommaUser<Base> {
    let base: Base
}

private var overlayKey: UInt8 = 0

extension CommaUser where Base: UINavigationBar {
    
    
    var overlay: UIView? {
        
        set {
            objc_setAssociatedObject(base, &overlayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let tmpOverlay: UIView
            if let existing = objc_getAssociatedObject(base, &overlayKey) as? UIView {
                tmpOverlay = existing
            } else {
                guard let view = base.subviews.first else { return nil }
                tmpOverlay = UIView(frame: CGRectMake(0, 0, base.width, base.height + Layout.StatusBarHeight))
                tmpOverlay.isUserInteractionEnabled = false
                tmpOverlay.autoresizingMask = .flexibleWidth
                objc_setAssociatedObject(base, &overlayKey, tmpOverlay, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                base.setBackgroundImage(UIImage(), for: .default)
                view.insertSubview(tmpOverlay, at: 0)
            }
            return tmpOverlay
            
        }
        
    }
    
    
    func background(color: UIColor?, animated: Bool = false) {
        if !animated {
            overlay?.backgroundColor = color
            return
        }
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
            self.overlay?.backgroundColor = color
        }
    }
    
    
    mutating func reset() {
        base.setBackgroundImage(nil, for: .default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
    
    var translationY: CGFloat {
        
        set {
            base.transform = CGAffineTransform.init(translationX: 0, y: newValue)
        }
        
        get {
            return base.transform.ty
        }
    }
    
    func setElements(alpha: CGFloat) {
        
        (base.value(forKey: "_leftViews") as? [UIView])?.forEach { view in
            view.alpha = alpha
        }
        
        (base.value(forKey: "_rightViews") as? [UIView])?.forEach { view in
            view.alpha = alpha
        }
        
        (base.value(forKey: "_titleView") as? UIView)?.alpha = alpha
        
        base.subviews.forEach { view in
            
            if view.isKind(of: NSClassFromString("UINavigationItemView")!)  || view.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView")!) {
                view.alpha = alpha
            }
        }
    }
    
    func setElements(tintColor: UIColor?) {
        
        (base.value(forKey: "_leftViews") as? [UIView])?.forEach { view in
            view.tintColor = tintColor
        }
        
        (base.value(forKey: "_rightViews") as? [UIView])?.forEach { view in
            view.tintColor = tintColor
        }
        
        (base.value(forKey: "_titleView") as? UIView)?.tintColor = tintColor
        
        base.subviews.forEach { view in
            
            if view.isKind(of: NSClassFromString("UINavigationItemView")!)  || view.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView")!) {
                view.tintColor = tintColor
            }
        }
        
    }
    
}

